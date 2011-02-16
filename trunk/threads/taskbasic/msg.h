#ifndef ___MSG_H_
#define ___MSG_H_

typedef nx_struct pedido_msg {
    nx_uint8_t pedido;
} pedido_msg_t;

typedef nx_struct medida_msg {
    nx_uint16_t mediaSensor;
    nx_uint16_t numMedidasSensor;
} medida_msg_t;

enum {
    AM_PEDIDO_MSG = 6
};

#endif
