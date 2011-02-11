#include "Timer.h"
#include "printf.h"
#include "msg.h"

configuration aplicacaoRealAppC
{
}
implementation
{
    components MainC, aplicacaoRealC;
    aplicacaoRealC -> MainC.Boot;

    components LedsC;
    aplicacaoRealC.Leds -> LedsC;

    components new TimerMilliC() as timerSensor;
    aplicacaoRealC.timerSensor -> timerSensor;

    components new DemoSensorC() as sensor;
    aplicacaoRealC.sensor -> sensor;

    components new AMSenderC(AM_PEDIDO_MSG) as senderPedido;
    components new AMReceiverC(AM_PEDIDO_MSG) as receiverPedido;
    components ActiveMessageC;
    aplicacaoRealC.receiverPedido -> receiverPedido;
    aplicacaoRealC.senderPedido -> senderPedido;
    aplicacaoRealC.AMControl -> ActiveMessageC;
    aplicacaoRealC.Packet -> senderPedido;

    components new TimerMilliC() as timerPedido;
    aplicacaoRealC.timerPedido -> timerPedido;

    components new SerialAMSenderC(1);
    components SerialActiveMessageC;
    aplicacaoRealC.senderSerial -> SerialAMSenderC;
    aplicacaoRealC.serialPacket -> SerialAMSenderC;
    aplicacaoRealC.serialAMControl -> SerialActiveMessageC;

    components new TimerMilliC() as timerSerial;
    aplicacaoRealC.timerSerial -> timerSerial;
}
