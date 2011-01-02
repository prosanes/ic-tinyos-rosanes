#include "Timer.h"

configuration TinySchedulerC {
    provides interface Scheduler;
    provides interface TaskBasic[uint8_t id];
    provides interface TaskPrioridade[uint8_t id];
}
implementation {
    components SchedulerPrioridadeFilaP as Sched;
    components McuSleepC as Sleep;
    components LedsC;


    Scheduler = Sched;
    TaskBasic = Sched;
    TaskPrioridade = Sched;
    Sched.McuSleep -> Sleep;
    Sched.Leds -> LedsC;
}

