/**
 * Aplicativo de teste do Scheduler de prioridade 
 *
 **/

#include "MsgSerial.h"
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

  aplicacaoTesteC.Tarefa1->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa2->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa3->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa4->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa5->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];

// ...

  aplicacaoTesteC.Tarefa98->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa99->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
}

