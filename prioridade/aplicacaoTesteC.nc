
/**
 * Implementa aplicativo de teste do Scheduler de prioridade 
 **/

#include "MsgSerial.h"

module aplicacaoTesteC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface Packet;
    uses interface AMSend;
    uses interface SplitControl as Control;
    uses interface TaskPrioridade as TarefaRadio_ComunicacaoPC;
    uses interface TaskPrioridade as Tarefa1;
    uses interface TaskPrioridade as Tarefa2;
    uses interface TaskPrioridade as Tarefa3;
    uses interface TaskPrioridade as Tarefa4;
    uses interface TaskPrioridade as Tarefa5;
    uses interface TaskPrioridade as Tarefa6;
    uses interface TaskPrioridade as Tarefa7;
    uses interface TaskPrioridade as Tarefa8;
    uses interface TaskPrioridade as Tarefa9;
    uses interface TaskPrioridade as Tarefa10;
    uses interface TaskPrioridade as Tarefa11;
    uses interface TaskPrioridade as Tarefa12;
    uses interface TaskPrioridade as Tarefa13;
    uses interface TaskPrioridade as Tarefa14;
    uses interface TaskPrioridade as Tarefa15;
    uses interface TaskPrioridade as Tarefa16;
    uses interface TaskPrioridade as Tarefa17;
    uses interface TaskPrioridade as Tarefa18;
    uses interface TaskPrioridade as Tarefa19;
    uses interface TaskPrioridade as Tarefa20;
}
implementation
{
    /* Variaveis */
    message_t pacotePC;

    /* Boot
    */
    event void Boot.booted()
    {
        //call Control.start();

        call Tarefa1.postTask(20);
        call Tarefa2.postTask(20);
        call Tarefa3.postTask(20);
        call Tarefa4.postTask(20);
        call Tarefa5.postTask(20);
        call Tarefa6.postTask(20);
        call Tarefa7.postTask(20);
        call Tarefa8.postTask(20);
        call Tarefa9.postTask(20);
        call Tarefa10.postTask(10);
        call Tarefa11.postTask(20);
        call Tarefa12.postTask(20);
        call Tarefa13.postTask(20);
        call Tarefa14.postTask(20);
        call Tarefa15.postTask(20);
        call Tarefa16.postTask(20);
        call Tarefa17.postTask(20);
        call Tarefa18.postTask(20);
        call Tarefa19.postTask(20);
        call Tarefa20.postTask(20);
    }

    /* Tarefas
    */
    event void TarefaRadio_ComunicacaoPC.runTask()
    {
        msgSerial_t* pacotePC_payload;
        call Leds.led1Toggle();

        //call comando de send para o PC
        pacotePC_payload = (msgSerial_t*) call Packet.getPayload(&pacotePC, sizeof(msgSerial_t));
        if (pacotePC_payload == NULL) 
            {return;}
        if (call Packet.maxPayloadLength() < sizeof(msgSerial_t)) 
            {return;}

        //pacotePC_payload->media = mediaLeitura;
        call AMSend.send(AM_BROADCAST_ADDR,&pacotePC,sizeof(msgSerial_t));
    }

    event void Tarefa1.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }

    }
    event void Tarefa2.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa3.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa4.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa5.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa6.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa7.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa8.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa9.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa10.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa11.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa12.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa13.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa14.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa15.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa16.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa17.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa18.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa19.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa20.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }

    /* Radio
    */
    event void AMSend.sendDone(message_t* bufPtr, error_t error) {}

    event void Control.startDone(error_t error)
    {
//        call TimerComunicacaoPC.startPeriodic(1000);
    }

    event void Control.stopDone(error_t error) {}
}
