
/**
 * Aplicativo de teste do Scheduler de prioridade 
 *
 **/

#include "MsgSerial.h"

configuration aplicacaoTesteAppC 
{
}
implementation
{
  components MainC, aplicacaoTesteC, LedsC, TinySchedulerC;
  components SerialActiveMessageC as SerialAM;

  aplicacaoTesteC-> MainC.Boot;
  aplicacaoTesteC.Leds -> LedsC;
  aplicacaoTesteC.Packet -> SerialAM;
  aplicacaoTesteC.AMSend -> SerialAM.AMSend[AM_SERIAL_MSG];
  aplicacaoTesteC.Control -> SerialAM;

  aplicacaoTesteC.TarefaRadio_ComunicacaoPC-> 
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 
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
  aplicacaoTesteC.Tarefa6->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa7->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa8->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa9->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa10->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa11->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa12->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa13->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa14->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa15->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa16->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa17->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa18->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa19->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
  aplicacaoTesteC.Tarefa20->
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")];
}

