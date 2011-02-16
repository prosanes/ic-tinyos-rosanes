#include "msg.h"

module aplicacaoRealC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface BlockingRead<uint16_t> as sensor;

    uses interface BlockingAMSend as senderPedido;
    uses interface BlockingReceive as receiverPedido;
    uses interface BlockingStdControl as AMControl;
    uses interface Packet;

    uses interface Thread as enviaPedido;
    uses interface Thread as sensoria;
    uses interface Thread as sensoriaPedido;

//    uses interface AMSend as senderSerial;
//    uses interface SplitControl as serialAMControl;
//    uses interface Packet as serialPacket;
//    uses interface Timer<TMilli> as timerSerial;
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
        if (numMedidasSensor == 1)
            mediaSensor = ultimaMedidaSensor;
        else
            mediaSensor = (mediaSensor + ultimaMedidaSensor) / 2;
//        printf("calculaMediaSensor: %u %u\n", numMedidasSensor, mediaSensor);
    }

    task void calculaMediaSensor2()
    {
        if (numMedidasSensor == 1)
            mediaSensor = ultimaMedidaSensor;
        else
            mediaSensor = (mediaSensor + ultimaMedidaSensor) / 2;
//        printf("calculaMediaSensor: %u %u\n", numMedidasSensor, mediaSensor);
    }

/*    task void enviaSerial()
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
    }*/

/*
    RECEBE MEDIDA
*/
    event void Boot.booted()
    {
        numMedidasSensor = 0;

        call AMControl.start();
        call enviaPedido.start(NULL);
        call sensoria.start(NULL);
        call sensoriaPedido.start(NULL);
    }

    event void enviaPedido.run(void *arg)
    {
        while(1)
        {
            printf("enviaPedido\n");
            printfflush();

            call senderPedido.send(AM_BROADCAST_ADDR,
                                   &pedido,
                                   0);
                                   
//            printf("enviaPedido: enviado\n");
            call enviaPedido.sleep(200);
        }
    }

    event void sensoria.run(void *arg)
    {
        while(1)
        {
            printf("sensoria\n");
            printfflush();
            if (call sensor.read(&ultimaMedidaSensor) == SUCCESS)
            {
                //inserir mutex
                numMedidasSensor++;
                post calculaMediaSensor();
            }
            call sensoria.sleep(200);
        }
    }

    event void sensoriaPedido.run(void *arg)
    {
        while(1)
        {
            printf("sensoriaPedido\n");
            printfflush();
            if (call receiverPedido.receive(&medida, 5000) == SUCCESS)
            {
                if (call sensor.read(&ultimaMedidaSensor) == SUCCESS)
                {
                    //inserir mutex
                    numMedidasSensor++;
                    post calculaMediaSensor2();
                }
            }
            call sensoriaPedido.sleep(200);
        }
    }

}
