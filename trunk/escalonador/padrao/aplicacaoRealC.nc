#include "Timer.h"
#include "printf.h"
#include "msg.h"

module aplicacaoRealC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli> as timerSensor;
    uses interface Read<uint16_t> as sensor;

    uses interface AMSend as senderPedido;
    uses interface Receive as receiverPedido;
    uses interface SplitControl as AMControl;
    uses interface Packet;
    uses interface Timer<TMilli> as timerPedido;

    uses interface AMSend as senderSerial;
    uses interface SplitControl as serialAMControl;
    uses interface Packet as serialPacket;
    uses interface Timer<TMilli> as timerSerial;
}
implementation
{
    message_t pedido;
    message_t medida;
    uint16_t mediaSensor;
    uint16_t numMedidasSensor;
    uint16_t ultimaMedidaSensor;

    task void calculaMediaSensor()
    {
        call Leds.led0Toggle();
        if (numMedidasSensor == 1)
            mediaSensor = ultimaMedidaSensor;
        else
            mediaSensor = (mediaSensor + ultimaMedidaSensor) / 2;
        printf("calculaMediaSensor: %u %u\n", numMedidasSensor, mediaSensor);
    }

    task void pedidoSensor()
    {
        printf("pedidoSensor: Task rodando\n");
        call sensor.read();
    }

    task void enviaSerial()
    {
        medida_msg_t* m = (medida_msg_t*)call Packet.getPayload(&medida,
                                                sizeof(medida_msg_t));
        call Leds.led1Toggle();
        m->mediaSensor = mediaSensor;
        m->numMedidasSensor = numMedidasSensor;
        printf("enviaSerial: %u %u\n", m->numMedidasSensor, m->mediaSensor);

        call senderPedido.send(AM_BROADCAST_ADDR,
                               &medida,
                               sizeof(medida_msg_t));
        printf("_____enviaSerial: enviado\n");
    }

    task void enviaPedido()
    {
        pedido_msg_t* p = (pedido_msg_t*)call Packet.getPayload(&pedido,
                                                sizeof(pedido_msg_t));
        p->pedido = 1;

        call senderPedido.send(AM_BROADCAST_ADDR,
                               &pedido,
                               sizeof(pedido_msg_t));
        printf("enviaPedido: enviado\n");
    }

    event void Boot.booted()
    {
        numMedidasSensor = 0;

        call AMControl.start();
        call serialAMControl.start();
        call timerSensor.startPeriodic(100);
    }

    event void timerSensor.fired()
    {
        call sensor.read();
    }

    event void sensor.readDone(error_t result, uint16_t data)
    {
        if (result == SUCCESS)
        {
            numMedidasSensor++;
            ultimaMedidaSensor = data;
            post calculaMediaSensor();
            printf("sensor.readDone: %u %u\n", numMedidasSensor, ultimaMedidaSensor);
        }
    }

    event void AMControl.startDone(error_t err)
    {
        if (err == SUCCESS)
            call timerPedido.startPeriodic(1000);
        else
            call AMControl.start();
    }

    event void serialAMControl.startDone(error_t err)
    {
        if (err == SUCCESS)
            call timerSerial.startPeriodic(10000);
        else
            call serialAMControl.start();
    }

    event void AMControl.stopDone(error_t err)
    {} //Nao faz nada
    event void serialAMControl.stopDone(error_t err)
    {}

    event void timerPedido.fired()
    {
        post enviaPedido();
    }

    event void timerSerial.fired()
    {
        post enviaSerial();
    }

    event message_t* receiverPedido.receive(message_t* bufPrt, 
                void* payload, uint8_t len)
    {
        call Leds.led2Toggle();
        if (len != sizeof(pedido_msg_t))
            return bufPrt;
        else
        {
            pedido_msg_t* p = (pedido_msg_t*)payload;
            printf("receiverPedido: %u\n", p->pedido);
            if (p->pedido == 1)
                post pedidoSensor(); 
            return bufPrt;
        }
    }

    event void senderPedido.sendDone(message_t* bufPtr, error_t err)
    {}
    event void senderSerial.sendDone(message_t* bufPtr, error_t err)
    {}
}
