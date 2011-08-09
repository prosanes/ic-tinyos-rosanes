#include "Timer.h"

module BlinkC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Timer<TMilli> as Timer2;
  uses interface Leds;
  uses interface Boot;
}
implementation
{
  event void Boot.booted()
  {
    call Timer0.startPeriodic( 250 );
    call Timer1.startPeriodic( 500 );
    call Timer2.startPeriodic( 1000 );

    post tarefa();
  }

  event void Timer0.fired()
  {
    call Leds.led0Toggle();
  }
  
  event void Timer1.fired()
  {
    call Leds.led1Toggle();
  }
  
  event void Timer2.fired()
  {
    call Leds.led2Toggle();
  }

  task void tarefa()
  {
      dbg("BlinkC", "tarefa\n");
  }
}
