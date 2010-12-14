// $Id: SchedulerBasicP.nc,v 1.1.2.5 2006/02/14 17:01:46 idgay Exp $

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/*
 *
 * Authors:		Philip Levis
 * Date last modified:  $Id: SchedulerBasicP.nc,v 1.1.2.5 2006/02/14 17:01:46 idgay Exp $
 *
 */

/**
 * SchedulerBasic implements the default TinyOS scheduler sequence, as
 * documented in TEP 106.
 *
 * @author Philip Levis
 * @author Cory Sharp
 * @date   January 19 2005
 */

/**
 * Modificado para funcionar em simulacoes também.
 *
 */

#include "hardware.h"
#include <sim_event_queue.h>

module SchedulerDeadlineP {
    provides interface Scheduler;
    provides interface TaskBasic[uint8_t id];
    provides interface TaskDeadline<TMilli>[uint8_t id];
    uses interface McuSleep;
    uses interface Leds;
    //uses interface LocalTime<TMilli>;
}
implementation
{
    enum
    {
        NUM_TASKS = uniqueCount("TinySchedulerC.TaskBasic"),
        NUM_DTASKS = uniqueCount("TinySchedulerC.TaskDeadline"),
        NO_TASK = 255,
    };

    volatile uint8_t m_head;
    volatile uint8_t m_tail;
    volatile uint8_t m_next[NUM_TASKS];
    volatile uint8_t d_head;
    volatile uint8_t d_tail;
    volatile uint8_t d_next[NUM_DTASKS];
    volatile uint32_t d_time[NUM_DTASKS];

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


    // Helper functions (internal functions) intentionally do not have atomic
    // sections.  It is left as the duty of the exported interface functions to
    // manage atomicity to minimize chances for binary code bloat.

    // move the head forward
    // if the head is at the end, mark the tail at the end, too
    // mark the task as not in the queue
    inline uint8_t popMTask()
    {
        dbg("Deadline", "Poped a Mtask (ou nao)\n");
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
        dbg("Deadline", "isMWaiting: %d\n", (m_next[id] != NO_TASK) || (m_tail == id));
        return (m_next[id] != NO_TASK) || (m_tail == id);
    }

    bool pushMTask( uint8_t id )
    {
        dbg("Deadline", "pushMTask %i\n", (int)id);
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

    inline uint8_t popDTask()
    {
        dbg("Deadline", "Poped a Dtask (ou nao)\n");
        if( d_head != NO_TASK )
        {
            uint8_t id = d_head;
            d_head = d_next[d_head];
            if( d_head == NO_TASK )
            {
                d_tail = NO_TASK;
            }
            d_next[id] = NO_TASK;
            return id;
        }
        else
        {
            return NO_TASK;
        }
    }

    bool isDWaiting( uint8_t id )
    {
        dbg("Deadline", "isDWaiting: %d\n", (m_next[id] != NO_TASK) || (m_tail == id));
        return (d_next[id] != NO_TASK) || (d_tail == id);
    }

    bool pushDTask( uint8_t id, uint32_t deadline )
    {
        dbg("Deadline", "pushDTask %i\n", (int)id);
        if( !isDWaiting(id) )
        {
            if( d_head == NO_TASK )
            {
                d_head = id;
                d_tail = id;
            }
            else
            {
                uint8_t t_curr = d_head;
                uint8_t t_prev = d_head;
                uint32_t local = 0;  //call LocalTime.get();
                while (d_time[t_curr] - local <= deadline &&
                        t_curr != NO_TASK) {
                    t_prev = t_curr;
                    t_curr = d_next[t_curr];
                }
                d_next[id] = t_curr;
                if (t_curr == d_head) {
                    d_head = id;
                }
                else {
                    d_next[t_prev] = id;
                    if (t_curr == NO_TASK) { 
                        d_tail = id;
                    }
                }
            }
            //d_time[id] = call LocalTime.get() + deadline;
            d_time[id] = 0 + deadline;
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }


    command void Scheduler.init()
    {
        dbg("Deadline", "init\n");
        atomic
        {
            memset( (void *)m_next, NO_TASK, sizeof(m_next) );
            m_head = NO_TASK;
            m_tail = NO_TASK;
            memset( (void *)d_next, NO_TASK, sizeof(d_next) );
            d_head = NO_TASK;
            d_tail = NO_TASK;

            sim_scheduler_event_pending = FALSE;
            sim_scheduler_event_init(&sim_scheduler_event);
        }
    }

    command bool Scheduler.runNextTask()
    {
        uint8_t nextTask;
        dbg("Deadline", "runNextTask\n");
        atomic
        {
            nextTask = popDTask();
            dbg("Deadline", "popDTask: %i\n", (int)nextTask);
            if( nextTask == NO_TASK )
            {
                nextTask = popMTask();
                dbg("Deadline", "popMTask: %i\n", (int)nextTask);
                if (nextTask == NO_TASK) {
                    return FALSE;
                }
                dbg("Deadline", "Running basic task %i\n", (int)nextTask);
                signal TaskBasic.runTask[nextTask]();
                return TRUE;
            }
        }
        dbg("Deadline", "Running deadline task %i\n", (int)nextTask);
        signal TaskDeadline.runTask[nextTask]();
        return TRUE;
    }

    command void Scheduler.taskLoop()
    {
        dbg("Deadline", "Taskloop\n");
        call Leds.led0Toggle();
        for (;;)
        {
            uint8_t nextDTask = NO_TASK;
            uint8_t nextMTask = NO_TASK;

            atomic
            {
                while ((nextDTask = popDTask()) == NO_TASK &&
                        (nextMTask = popMTask()) == NO_TASK)
                {
                    call McuSleep.sleep();
                }
            }
            if (nextDTask != NO_TASK) {
                dbg("Deadline", "Running deadline task %i\n", (int)nextDTask);
                signal TaskDeadline.runTask[nextDTask]();
            }
            else if (nextMTask != NO_TASK) {
                dbg("Deadline", "Running basic task %i\n", (int)nextMTask);
                signal TaskBasic.runTask[nextMTask]();
            }
        }
    }

    /**
     * Return SUCCESS if the post succeeded, EBUSY if it was already posted.
     */

    async command error_t TaskBasic.postTask[uint8_t id]()
    {
        error_t result;

        dbg("Deadline", "postTaskBasic\n");
        atomic {
            result = pushMTask(id) ? SUCCESS : EBUSY;
        }
        if (result == SUCCESS)
            sim_scheduler_submit_event();

        return result;
        
    }

    default event void TaskBasic.runTask[uint8_t id]()
    {
    }



    async command error_t TaskDeadline.postTask[uint8_t id](uint32_t deadline)
    {
        error_t result;

        dbg("Deadline", "postTaskBasic\n");
        atomic {
            result = pushDTask(id, deadline) ? SUCCESS : EBUSY;
        }
        if (result == SUCCESS)
            sim_scheduler_submit_event();

        return result;
    }

    default event void TaskDeadline.runTask[uint8_t id]()
    {
    }



}

