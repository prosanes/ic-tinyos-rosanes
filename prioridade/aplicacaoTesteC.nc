
/**
 * Implementa aplicativo de teste do Scheduler de prioridade 
 **/

#include "MsgSerial.h"

module aplicacaoTesteC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli> as TimerDoSensor;
    uses interface Timer<TMilli> as TimerComunicacaoPC;
    uses interface Read<uint16_t> as Sensor;
    uses interface Packet;
    uses interface AMSend;
    uses interface SplitControl as Control;
    uses interface TaskPrioridade as TarefaTimer_PedeSensoreamento;
    uses interface TaskPrioridade as TarefaRadio_ComunicacaoPC;
    uses interface TaskPrioridade as TarefaSensor_CalculaMedia;
}
implementation
{
    /* Variaveis */
    uint16_t ultimaLeitura;
    uint16_t mediaLeitura;
    uint8_t  numLeitura;
    message_t pacotePC;

    /* Boot
    */
    event void Boot.booted()
    {
        numLeitura = 0;

        call Control.start();
        
        call TimerDoSensor.startPeriodic(1000);
    }

    /* Timers
    */
    event void TimerDoSensor.fired()
    {
        call TarefaTimer_PedeSensoreamento.postTask(0);
    }

    event void TimerComunicacaoPC.fired()
    {
        call TarefaRadio_ComunicacaoPC.postTask(0);
    }

    /* Tarefas
    */
    event void TarefaTimer_PedeSensoreamento.runTask()
    {
        call Sensor.read();
    }

    event void TarefaRadio_ComunicacaoPC.runTask()
    {
        //call comando de send para o PC
        msgSerial_t* pacotePC_payload = (msgSerial_t*) call Packet.getPayload(&pacotePC, sizeof(msgSerial_t));
        if (pacotePC_payload == NULL) 
            {return;}
        if (call Packet.maxPayloadLength() < sizeof(msgSerial_t)) 
            {return;}

        pacotePC_payload->media = mediaLeitura;
        call AMSend.send(AM_BROADCAST_ADDR,&pacotePC,sizeof(msgSerial_t));
    }

    event void TarefaSensor_CalculaMedia.runTask()
    {
        numLeitura++;
        if (numLeitura > 1)
            mediaLeitura = (mediaLeitura + ultimaLeitura)/2;
        else
            mediaLeitura = ultimaLeitura;
    }

    /* Sensoreamento
    */
    event void Sensor.readDone(error_t result, uint16_t data)
    {
        ultimaLeitura = data;
        call TarefaSensor_CalculaMedia.postTask(0);
    }

    /* Radio
    */
    event void AMSend.sendDone(message_t* bufPtr, error_t error) {}

    event void Control.startDone(error_t error)
    {
        call TimerComunicacaoPC.startPeriodic(30000);
    }

    event void Control.stopDone(error_t error) {}
}
