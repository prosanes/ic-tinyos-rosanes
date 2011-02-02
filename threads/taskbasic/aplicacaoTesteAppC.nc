
/**
 * Aplicativo de teste do Scheduler de prioridade 
 *
 **/

#include "Timer.h"
#include "printf.h"

configuration aplicacaoTesteAppC 
{
}
implementation
{
  components MainC, aplicacaoTesteC;
  aplicacaoTesteC-> MainC.Boot;

  components CounterMicro32C as Timer1;
  aplicacaoTesteC.Timer1 -> Timer1;

  components LedsC;
  aplicacaoTesteC.Leds -> LedsC;

  components new ThreadC(100) as thread1;
  aplicacaoTesteC.thread1 -> thread1;

  components PrintfC;
}

