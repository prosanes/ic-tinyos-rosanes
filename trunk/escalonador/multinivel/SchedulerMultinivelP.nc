#define NO_STARVATION_NUM 10

//Define this to use on the TOSSIM
//#define SIM__

#include "hardware.h"

#ifdef SIM__
#include <sim_event_queue.h>
#endif


module SchedulerMultinivelP {
    provides interface Scheduler;
    provides interface TaskBasic[uint8_t id];
    provides interface TaskRadio[uint8_t id];
    provides interface TaskSerial[uint8_t id];
    provides interface TaskSense[uint8_t id];
    uses interface McuSleep;
}
implementation
{
    enum
    {
        NUM_TASKSBASIC  = uniqueCount("TinySchedulerC.TaskBasic"),
        NUM_TASKSRADIO  = uniqueCount("TinySchedulerC.TaskRadio"),
        NUM_TASKSSERIAL = uniqueCount("TinySchedulerC.TaskSerial"),
        NUM_TASKSSENSE  = uniqueCount("TinySchedulerC.TaskSense"),
        NO_TASK = 255,
    };

    volatile uint8_t basic_head;
    volatile uint8_t basic_tail;
    volatile uint8_t basic_next[NUM_TASKSBASIC];
    volatile uint8_t radio_head;
    volatile uint8_t radio_tail;
    volatile uint8_t radio_next[NUM_TASKSRADIO];
    volatile uint8_t serial_head;
    volatile uint8_t serial_tail;
    volatile uint8_t serial_next[NUM_TASKSSERIAL];
    volatile uint8_t sense_head;
    volatile uint8_t sense_tail;
    volatile uint8_t sense_next[NUM_TASKSSENSE];

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

    /****************************
    *** Funcoes Task Basic ******
    ****************************/
    inline uint8_t popTaskBasic()
    {
        dbg("Prioridade", "Poped a Mtask (ou nao)\n");
            if( basic_head != NO_TASK )
            {
                uint8_t id = basic_head;
                basic_head = basic_next[basic_head];
                if( basic_head == NO_TASK )
                {
                    basic_tail = NO_TASK;
                }
                basic_next[id] = NO_TASK;
                return id;
            }
            else
            {
                return NO_TASK;
            }
    }

    bool isWaitingBasic( uint8_t id )
    {
        dbg("Prioridade", "isWaitingBasic: %d\n", (basic_next[id] != NO_TASK) || (basic_tail == id));
        return (basic_next[id] != NO_TASK) || (basic_tail == id);
    }

    bool pushTaskBasic( uint8_t id )
    {
        dbg("Prioridade", "pushTaskBasic %i\n", (int)id);
        if( !isWaitingBasic(id) )
        {
            if( basic_head == NO_TASK )
            {
                basic_head = id;
                basic_tail = id;
            }
            else
            {
                basic_next[basic_tail] = id;
                basic_tail = id;
            }
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }

    /****************************
    *** Funcoes Task Radio ******
    ****************************/
    inline uint8_t popTaskRadio()
    {
        dbg("Prioridade", "Poped a task Radio (ou nao)\n");
            if( radio_head != NO_TASK )
            {
                uint8_t id = radio_head;
                radio_head = radio_next[radio_head];
                if( radio_head == NO_TASK )
                {
                    radio_tail = NO_TASK;
                }
                radio_next[id] = NO_TASK;
                return id;
            }
            else
            {
                return NO_TASK;
            }
    }

    bool isWaitingRadio( uint8_t id )
    {
        dbg("Prioridade", "isWaitingRadio: %d\n", (radio_next[id] != NO_TASK) || (radio_tail == id));
        return (radio_next[id] != NO_TASK) || (radio_tail == id);
    }

    bool pushTaskRadio( uint8_t id )
    {
        dbg("Prioridade", "pushTaskRadio %i\n", (int)id);
        if( !isWaitingRadio(id) )
        {
            if( radio_head == NO_TASK )
            {
                radio_head = id;
                radio_tail = id;
            }
            else
            {
                radio_next[radio_tail] = id;
                radio_tail = id;
            }
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }

    /****************************
    *** Funcoes Task Serial ******
    ****************************/
    inline uint8_t popTaskSerial()
    {
        dbg("Prioridade", "Poped a task Serial (ou nao)\n");
            if( serial_head != NO_TASK )
            {
                uint8_t id = serial_head;
                serial_head = serial_next[serial_head];
                if( serial_head == NO_TASK )
                {
                    serial_tail = NO_TASK;
                }
                serial_next[id] = NO_TASK;
                return id;
            }
            else
            {
                return NO_TASK;
            }
    }

    bool isWaitingSerial( uint8_t id )
    {
        dbg("Prioridade", "isWaitingSerial: %d\n", (serial_next[id] != NO_TASK) || (serial_tail == id));
        return (serial_next[id] != NO_TASK) || (serial_tail == id);
    }

    bool pushTaskSerial( uint8_t id )
    {
        dbg("Prioridade", "pushTaskSerial %i\n", (int)id);
        if( !isWaitingSerial(id) )
        {
            if( serial_head == NO_TASK )
            {
                serial_head = id;
                serial_tail = id;
            }
            else
            {
                serial_next[serial_tail] = id;
                serial_tail = id;
            }
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }

    /****************************
    *** Funcoes Task Sense ******
    ****************************/
    inline uint8_t popTaskSense()
    {
        dbg("Prioridade", "Poped a task Sense (ou nao)\n");
            if( sense_head != NO_TASK )
            {
                uint8_t id = sense_head;
                sense_head = sense_next[sense_head];
                if( sense_head == NO_TASK )
                {
                    sense_tail = NO_TASK;
                }
                sense_next[id] = NO_TASK;
                return id;
            }
            else
            {
                return NO_TASK;
            }
    }

    bool isWaitingSense( uint8_t id )
    {
        dbg("Prioridade", "isWaitingSense: %d\n", (sense_next[id] != NO_TASK) || (sense_tail == id));
        return (sense_next[id] != NO_TASK) || (sense_tail == id);
    }

    bool pushTaskSense( uint8_t id )
    {
        dbg("Prioridade", "pushTaskSense %i\n", (int)id);
        if( !isWaitingSense(id) )
        {
            if( sense_head == NO_TASK )
            {
                sense_head = id;
                sense_tail = id;
            }
            else
            {
                sense_next[serial_tail] = id;
                sense_tail = id;
            }
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
            memset( (void *)basic_next, NO_TASK, sizeof(basic_next) );
            basic_head = NO_TASK;
            basic_tail = NO_TASK;

            memset( (void *)radio_next, NO_TASK, sizeof(radio_next) );
            radio_head = NO_TASK;
            radio_tail = NO_TASK;
            
            memset( (void *)serial_next, NO_TASK, sizeof(serial_next) );
            serial_head = NO_TASK;
            serial_tail = NO_TASK;

            memset( (void *)sense_next, NO_TASK, sizeof(sense_next) );
            sense_head = NO_TASK;
            sense_tail = NO_TASK;

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
            nextTask = popTaskSerial();
            dbg("Prioridade", "popTaskSerial: %i\n", (int)nextTask);

            if( nextTask == NO_TASK )
            {
                nextTask = popTaskRadio();
                dbg("Prioridade", "popTaskRadio: %i\n", (int)nextTask);

                if (nextTask == NO_TASK)
                {
                    nextTask = popTaskSense();
                    dbg("Prioridade", "popTaskSense: %i\n", (int)nextTask);
                    if (nextTask == NO_TASK)
                    {
                        nextTask = popTaskBasic();
                        dbg("Prioridade", "popTaskBaic: %i\n", (int)nextTask);

                        if (nextTask == NO_TASK) {
                            return FALSE;
                        }
                    dbg("Prioridade", "Running task basic %i\n", (int)nextTask);
                    signal TaskBasic.runTask[nextTask]();
                    return TRUE;
                    }

                    dbg("Prioridade", "Running task sense %i\n", (int)nextTask);
                    signal TaskSense.runTask[nextTask]();
                    return TRUE;
                }
                dbg("Prioridade", "Running task radio %i\n", (int)nextTask);
                signal TaskRadio.runTask[nextTask]();
                return TRUE;
            }
        }
        dbg("Prioridade", "Running task serial %i\n", (int)nextTask);
        signal TaskSerial.runTask[nextTask]();
        return TRUE;
    }

    command void Scheduler.taskLoop()
    {
        dbg("Prioridade", "Taskloop\n");
        for (;;)
        {
            uint8_t nextTaskBasic = NO_TASK;
            uint8_t nextTaskRadio = NO_TASK;
            uint8_t nextTaskSerial = NO_TASK;
            uint8_t nextTaskSense = NO_TASK;

            atomic
            {
                while (
                    (nextTaskSerial = popTaskSerial()) == NO_TASK &&
                    (nextTaskRadio  = popTaskRadio() ) == NO_TASK &&
                    (nextTaskSense  = popTaskSense() ) == NO_TASK &&
                    (nextTaskBasic  = popTaskBasic() ) == NO_TASK )
                {
                    call McuSleep.sleep();
                }   
            }
            if (nextTaskSerial != NO_TASK) {
                dbg("Prioridade", "Running task serial %i\n", (int)nextTaskSerial);
                signal TaskSerial.runTask[nextTaskSerial]();
            }
            else if (nextTaskRadio != NO_TASK) {
                dbg("Prioridade", "Running task radio %i\n", (int)nextTaskRadio);
                signal TaskRadio.runTask[nextTaskRadio]();
            }
            else if (nextTaskSense != NO_TASK) {
                dbg("Prioridade", "Running task sense %i\n", (int)nextTaskSense);
                signal TaskSense.runTask[nextTaskSense]();
            }
            else if (nextTaskBasic != NO_TASK) {
                dbg("Prioridade", "Running task basic %i\n", (int)nextTaskBasic);
                signal TaskBasic.runTask[nextTaskBasic]();
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
            result = pushTaskBasic(id) ? SUCCESS : EBUSY;
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

    async command error_t TaskSerial.postTask[uint8_t id]()
    {
        error_t result;

        dbg("Prioridade", "postTaskSerial\n");
        atomic {
            result = pushTaskSerial(id) ? SUCCESS : EBUSY;
        }
        #ifdef SIM__
        if (result == SUCCESS)
            sim_scheduler_submit_event();
        #endif

        return result;
    }

    default event void TaskSerial.runTask[uint8_t id]()
    {
    }

    async command error_t TaskRadio.postTask[uint8_t id]()
    {
        error_t result;

        dbg("Prioridade", "postTaskRadio\n");
        atomic {
            result = pushTaskRadio(id) ? SUCCESS : EBUSY;
        }
        #ifdef SIM__
        if (result == SUCCESS)
            sim_scheduler_submit_event();
        #endif

        return result;
    }

    default event void TaskRadio.runTask[uint8_t id]()
    {
    }

    async command error_t TaskSense.postTask[uint8_t id]()
    {
        error_t result;

        dbg("Prioridade", "postTaskSense\n");
        atomic {
            result = pushTaskSense(id) ? SUCCESS : EBUSY;
        }
        #ifdef SIM__
        if (result == SUCCESS)
            sim_scheduler_submit_event();
        #endif

        return result;
    }

    default event void TaskSense.runTask[uint8_t id]()
    {
    }
}

