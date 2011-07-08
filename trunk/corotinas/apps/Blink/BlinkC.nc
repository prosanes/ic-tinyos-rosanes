/*
 * Copyright (c) 2008 Stanford University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
/**
 * Blink is a simple application used to test the basic functionality of
 * TOSThreads.
 *
 * Upon a successful burn, you should see LED0 flashing with a period of every
 * 200ms, and LED1 and LED2 flashing in unison with a period of 1000ms.
 *
 * @author Kevin Klues (klueska@cs.stanford.edu)
 */


module BlinkC {
  uses {
    interface Boot;
    interface Thread as TinyThread0;
    interface Thread as TinyThread1;
    interface Leds;

    interface BlockingStdControl as AMControl;
    interface BlockingAMSend;
    interface Packet;

  }
}

implementation {
  event void Boot.booted() {
    call TinyThread0.start(NULL);
    call TinyThread1.start(NULL);
  }


  event void TinyThread0.run(void* arg) {
    uint16_t* var;
    message_t msg;
    uint32_t counter = 0;

    var = call Packet.getPayload(&msg, sizeof(uint16_t));
    while( call AMControl.start() != SUCCESS );

    for(;;){
      counter++;
      if (counter == 10000)
      {
        call Leds.led0Toggle();
        counter = 0;
        //call TinyThread0.yield();
        //printf("Antes do BlockingAMSend\n");
        while( call BlockingAMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(uint16_t)) != SUCCESS );
        //printf("Depois do BlockingAMSend\n");
        call Leds.led2Toggle();
      }
    }
  }

  event void TinyThread1.run(void* arg) {
    uint32_t counter = 0;
    for(;;){
      counter++;
      if (counter == 10000)
      {
        call Leds.led1Toggle();
        counter = 0;
        //printf("Thread Simples\n");
        //printfflush();
        call TinyThread1.yield();
      }
    }
  }

}
