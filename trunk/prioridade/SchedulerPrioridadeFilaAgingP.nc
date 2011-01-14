#define NO_STARVATION_NUM 10

//Define this to use on the TOSSIM
//#define SIM__

#include "hardware.h"

#ifdef SIM__
#include <sim_event_queue.h>
#endif


module SchedulerPrioridadeFilaAgingP {
    provides interface Scheduler;
    provides interface TaskBasic[uint8_t id];
    provides interface TaskPrioridade[uint8_t id];
    uses interface McuSleep;
}
implementation
{
    enum
    {
        NUM_TASKS = uniqueCount("TinySchedulerC.TaskBasic"),
        NUM_PTASKS = uniqueCount("TinySchedulerC.TaskPrioridade"),
        NO_TASK = 255,
    };

    volatile uint8_t m_head;
    volatile uint8_t m_tail;
    volatile uint8_t m_next[NUM_TASKS];
    volatile uint8_t p_head;
    volatile uint8_t p_tail;
    volatile uint8_t p_next[NUM_PTASKS];
    volatile uint8_t p_prioridade[NUM_PTASKS];

    #ifdef SIM__
    // Aqui entram as funcoes responsaveis pelos eventos do simulador
    // As tasks são simuladas por eventos no TOSSIM

    bool sim_scheduler_event_pending = FALSE;
    sim_event_t sim_scheduler_event;

    int sim_config_task_latency() {return 100;}


    /* Only enqueue the event for execution if it is
       not already enqueued. If there are more tasks in the
       queue, the event will re-enqueue itself (see the handle
       function). */

    void sim_scheduler_submit_event() {
        if (sim_scheduler_event_pending == FALSE) {
            sim_scheduler_event.time = sim_time() + sim_config_task_latency();
            sim_queue_insert(&sim_scheduler_event);
            sim_scheduler_event_pending = TRUE;
        }
    }

    void sim_scheduler_event_handle(sim_event_t* e) {
        sim_scheduler_event_pending = FALSE;

        // If we successfully executed a task, re-enqueue the event. This
        // will always succeed, as sim_scheduler_event_pending was just
        // set to be false.  Note that this means there will be an extra
        // execution (on an empty task queue). We could optimize this
        // away, but this code is cleaner, and more accurately reflects
        // the real TinyOS main loop.

        if (call Scheduler.runNextTask()) {
            sim_scheduler_submit_event();
        }
    }


    /* Initialize a scheduler event. This should only be done
     * once, when the scheduler is initialized. */
    void sim_scheduler_event_init(sim_event_t* e) {
        e->mote = sim_node();
        e->force = 0;
        e->data = NULL;
        e->handle = sim_scheduler_event_handle;
        e->cleanup = sim_queue_cleanup_none;
    }
    #endif

    // Helper functions (internal functions) intentionally do not have atomic
    // sections.  It is left as the duty of the exported interface functions to
    // manage atomicity to minimize chances for binary code bloat.

    // move the head forward
    // if the head is at the end, mark the tail at the end, too
    // mark the task as not in the queue
    inline uint8_t popMTask()
    {
        dbg("Prioridade", "Poped a Mtask (ou nao)\n");
            if( m_head != NO_TASK )
            {
                uint8_t id = m_head;
                m_head = m_next[m_head];
                if( m_head == NO_TASK )
                {
                    m_tail = NO_TASK;
                }
                m_next[id] = NO_TASK;
                return id;
            }
            else
            {
                return NO_TASK;
            }
    }

    bool isMWaiting( uint8_t id )
    {
        dbg("Prioridade", "isMWaiting: %d\n", (m_next[id] != NO_TASK) || (m_tail == id));
        return (m_next[id] != NO_TASK) || (m_tail == id);
    }

    bool pushMTask( uint8_t id )
    {
        dbg("Prioridade", "pushMTask %i\n", (int)id);
        if( !isMWaiting(id) )
        {
            if( m_head == NO_TASK )
            {
                m_head = id;
                m_tail = id;
            }
            else
            {
                m_next[m_tail] = id;
                m_tail = id;
            }
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }

    inline uint8_t popPTask()
    {
        uint8_t atual;
        dbg("Prioridade", "Poped a Dtask (ou nao)\n");
        if( p_head != NO_TASK )
        {
            uint8_t id = p_head;
            p_head = p_next[p_head];
            if( p_head == NO_TASK )
            {
                p_tail = NO_TASK;
            }
            p_next[id] = NO_TASK;

            //antes de retornar, aumentar a prioridade de todas tarefas
            atual = p_head;
            while (atual != NO_TASK)
            {
                if (p_prioridade[atual] > 0)
                    p_prioridade[atual]--;
                atual = p_next[atual];
            }

            dbg("Prioridade_run", "Rodou PTask %i\n\tcom prioridade %i\n", (int) id, (int) p_prioridade[id]);
            return id;
        }
        else
        {
            return NO_TASK;
        }
    }

    bool isPWaiting( uint8_t id )
    {
        dbg("Prioridade", "isPWaiting: %d\n", (p_next[id] != NO_TASK) || (p_tail == id));
        return (p_next[id] != NO_TASK) || (p_tail == id);
    }

    bool pushPTask( uint8_t id, uint8_t prioridade )
    {
        dbg("Prioridade", "pushPTask %i\n", (int)id);
        if( !isPWaiting(id) )
        {
            if( p_head == NO_TASK )
            {
                p_head = id;
                p_tail = id;
            }
            else
            {
                uint8_t t_curr = p_head;
                uint8_t t_prev = p_head;
                while (p_prioridade[t_curr] <= prioridade &&
                        t_curr != NO_TASK) {
                    t_prev = t_curr;
                    t_curr = p_next[t_curr];
                }
                p_next[id] = t_curr;
                if (t_curr == p_head) {
                    p_head = id;
                }
                else {
                    p_next[t_prev] = id;
                    if (t_curr == NO_TASK) { 
                        p_tail = id;
                    }
                }
            }
            p_prioridade[id] = prioridade;
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }


    command void Scheduler.init()
    {
        dbg("Prioridade", "init\n");
        atomic
        {
            memset( (void *)m_next, NO_TASK, sizeof(m_next) );
            m_head = NO_TASK;
            m_tail = NO_TASK;
            memset( (void *)p_next, NO_TASK, sizeof(p_next) );
            p_head = NO_TASK;
            p_tail = NO_TASK;
            
            #ifdef SIM__
            sim_scheduler_event_pending = FALSE;
            sim_scheduler_event_init(&sim_scheduler_event);
            #endif
        }
    }

    command bool Scheduler.runNextTask()
    {
        uint8_t nextTask;
        dbg("Prioridade", "runNextTask\n");
        atomic
        {
            nextTask = popPTask();
            dbg("Prioridade", "popPTask: %i\n", (int)nextTask);
            if( nextTask == NO_TASK )
            {
                nextTask = popMTask();
                dbg("Prioridade", "popMTask: %i\n", (int)nextTask);
                if (nextTask == NO_TASK) {
                    return FALSE;
                }
                dbg("Prioridade", "Running basic task %i\n", (int)nextTask);
                signal TaskBasic.runTask[nextTask]();
                return TRUE;
            }
        }
        dbg("Prioridade", "Running prioridade task %i\n", (int)nextTask);
        signal TaskPrioridade.runTask[nextTask]();
        return TRUE;
    }

    command void Scheduler.taskLoop()
    {
        uint8_t max_ptask = 0;
        dbg("Prioridade", "Taskloop\n");
        for (;;)
        {
            uint8_t nextPTask = NO_TASK;
            uint8_t nextMTask = NO_TASK;

            if (max_ptask > NO_STARVATION_NUM)
            {
                max_ptask = 0;
                atomic {
                nextMTask = popMTask();
                }
                if (nextMTask != NO_TASK)
                    signal TaskBasic.runTask[nextMTask]();
            }
            if (nextMTask == NO_TASK)
            {
                atomic
                {
                    while ((nextPTask = popPTask()) == NO_TASK &&
                            (nextMTask = popMTask()) == NO_TASK)
                    {
                        call McuSleep.sleep();
                    }   
                }
                if (nextPTask != NO_TASK) {
                    dbg("Prioridade", "Running prioridade task %i\n", (int)nextPTask);
                    max_ptask++;
                    signal TaskPrioridade.runTask[nextPTask]();
                }
                else if (nextMTask != NO_TASK) {
                    dbg("Prioridade", "Running basic task %i\n", (int)nextMTask);
                    max_ptask = 0;
                    signal TaskBasic.runTask[nextMTask]();
                }
            }
        }
    }

    /**
     * Return SUCCESS if the post succeeded, EBUSY if it was already posted.
     */

    async command error_t TaskBasic.postTask[uint8_t id]()
    {
        error_t result;

        dbg("Prioridade", "postTaskBasic\n");
        atomic {
            result = pushMTask(id) ? SUCCESS : EBUSY;
        }
        #ifdef SIM__
        if (result == SUCCESS)
            sim_scheduler_submit_event();
        #endif

        return result;
        
    }

    default event void TaskBasic.runTask[uint8_t id]()
    {
    }



    async command error_t TaskPrioridade.postTask[uint8_t id](uint8_t prioridade)
    {
        error_t result;

        dbg("Prioridade", "postTaskBasic\n");
        atomic {
            result = pushPTask(id, prioridade) ? SUCCESS : EBUSY;
        }
        #ifdef SIM__
        if (result == SUCCESS)
            sim_scheduler_submit_event();
        #endif

        return result;
    }

    default event void TaskPrioridade.runTask[uint8_t id]()
    {
    }

}

