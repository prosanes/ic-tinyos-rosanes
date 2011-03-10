#include "Timer.h"

configuration TinySchedulerC {
    provides interface Scheduler;
    provides interface TaskBasic[uint8_t id];
}
implementation {
    components SchedulerPrioridadeFilaP as Sched;
    components McuSleepC as Sleep;

    Scheduler = Sched;
    TaskBasic = Sched;
    Sched.McuSleep -> Sleep;
}

