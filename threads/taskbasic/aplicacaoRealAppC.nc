#include "msg.h"
#include "printf.h"

configuration aplicacaoRealAppC
{
}
implementation
{
    components PrintfC;
    components MainC, aplicacaoRealC;
    aplicacaoRealC -> MainC.Boot;

    components LedsC;
    aplicacaoRealC.Leds -> LedsC;

    components new BlockingSineSensorC() as sensor;
    aplicacaoRealC.sensor -> sensor;

    components new BlockingAMSenderC(AM_PEDIDO_MSG) as senderPedido;
    components new BlockingAMReceiverC(AM_PEDIDO_MSG) as receiverPedido;
    components BlockingActiveMessageC;
    aplicacaoRealC.receiverPedido -> receiverPedido;
    aplicacaoRealC.senderPedido -> senderPedido;
    aplicacaoRealC.AMControl -> BlockingActiveMessageC;
    aplicacaoRealC.Packet -> senderPedido;

    components new ThreadC(200) as enviaPedido;
    components new ThreadC(200) as sensoria;
    components new ThreadC(200) as sensoriaPedido;
    aplicacaoRealC.enviaPedido -> enviaPedido;
    aplicacaoRealC.sensoria -> sensoria;
    aplicacaoRealC.sensoriaPedido -> sensoriaPedido;


//    components new SerialAMSenderC(1);
//    components SerialActiveMessageC;
//    aplicacaoRealC.senderSerial -> SerialAMSenderC;
//    aplicacaoRealC.serialPacket -> SerialAMSenderC;
//    aplicacaoRealC.serialAMControl -> SerialActiveMessageC;

}
