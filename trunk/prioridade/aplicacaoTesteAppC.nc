
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
  components new PhotoC();
  components new TimerMilliC() as Timer1;
  components new TimerMilliC() as Timer2;
  components SerialActiveMessageC as SerialAM;

  aplicacaoTesteC-> MainC.Boot;
  aplicacaoTesteC.Sensor -> PhotoC;
  aplicacaoTesteC.Leds -> LedsC;
  aplicacaoTesteC.TimerDoSensor -> Timer1;
  aplicacaoTesteC.TimerComunicacaoPC -> Timer2;

  aplicacaoTesteC.Packet -> SerialAM;
  aplicacaoTesteC.AMSend -> SerialAM.AMSend[AM_SERIAL_MSG];
  aplicacaoTesteC.Control -> SerialAM;

  aplicacaoTesteC.TarefaTimer_PedeSensoreamento-> 
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 
    
  aplicacaoTesteC.TarefaRadio_ComunicacaoPC-> 
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 

  aplicacaoTesteC.TarefaSensor_CalculaMedia-> 
  TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 
}

