#include "Timer.h"

configuration TinySchedulerC {
    provides interface Scheduler;
    provides interface TaskBasic[uint8_t id];
    provides interface TaskRadio[uint8_t id];
    provides interface TaskSerial[uint8_t id];
    provides interface TaskSense[uint8_t id];
}
implementation {
    components SchedulerMultinivelP as Sched;
    components McuSleepC as Sleep;

    Scheduler = Sched;
    TaskBasic = Sched;
    TaskRadio = Sched;
    TaskSerial = Sched;
    TaskSense = Sched;
    Sched.McuSleep -> Sleep;
}

