#include "Timer.h"

configuration TinySchedulerC {
    provides interface TaskScheduler;
    provides interface TaskBasic[uint8_t id];
    provides interface TaskPrioridade[uint8_t id];
    uses interface ThreadScheduler;
}
implementation {
    components SchedulerPrioridadeFilaP as Sched;

    TaskScheduler = Sched;
    TaskBasic = Sched;
    TaskPrioridade = Sched;
    Sched.ThreadScheduler = ThreadScheduler;
}

