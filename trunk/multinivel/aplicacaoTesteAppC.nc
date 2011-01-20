
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
  components MainC, aplicacaoTesteC, LedsC, TinySchedulerC;
  components CounterMicro32C as Timer1;

  aplicacaoTesteC.Timer1 -> Timer1;

  aplicacaoTesteC-> MainC.Boot;
  aplicacaoTesteC.Leds -> LedsC;

  aplicacaoTesteC.TarefaSense->
  TinySchedulerC.TaskSense[unique("TinySchedulerC.TaskSense")];
  aplicacaoTesteC.TarefaRadio->
  TinySchedulerC.TaskRadio[unique("TinySchedulerC.TaskRadio")];
  aplicacaoTesteC.TarefaSerial->
  TinySchedulerC.TaskSerial[unique("TinySchedulerC.TaskSerial")];
}

