#ifndef MSG_SERIAL_H_
#define MSG_SERIAL_H_

typedef nx_struct msgSerial
{
    nx_uint16_t media;
} msgSerial_t;

enum {
    AM_SERIAL_MSG = 0x89,
};

#endif
