#include "mutex.h"
#include "semaphore.h"

module BenchmarkC {
  uses {
    interface Boot;
    interface Thread as Produtor;
    interface Thread as Consumidor;
    interface Thread as SerialSender;
    interface Leds;

    interface BlockingStdControl as AMControl;
    interface BlockingAMSend;
    interface Packet;

    interface Counter<TMicro, uint32_t> as Timer;

    interface Mutex;
    interface Semaphore;
  }
}

implementation {
    uint32_t t1;
    uint32_t * tempo;
    uint8_t buffer;
    mutex_t mutex_buffer;
    semaphore_t sem_produto, sem_termino, sem_buffer_cheio;

    async event void Timer.overflow()
    {}                                 

    event void Boot.booted() {
      buffer = 0;
      t1 = call Timer.get();

      call Mutex.init(&mutex_buffer);
      call Semaphore.reset(&sem_produto, 0);
      call Semaphore.reset(&sem_buffer_cheio, 1);
      call Semaphore.reset(&sem_termino, 0);

      call Produtor.start(NULL);
      call Consumidor.start(NULL);
      call SerialSender.start(NULL);
    }

    event void SerialSender.run(void* arg)
    {
        message_t msg;

        call Semaphore.acquire(&sem_termino);

        t1 = call Timer.get() - t1;
        
        while( call AMControl.start() != SUCCESS );

        tempo = call Packet.getPayload(&msg, sizeof(uint32_t));
        (*tempo) = t1;

        while( call BlockingAMSend.send(AM_BROADCAST_ADDR, 
                        &msg, sizeof(uint32_t)) != SUCCESS );

        //Para conferir a corretude da execucao
        (*tempo) = buffer;
        while( call BlockingAMSend.send(AM_BROADCAST_ADDR, 
                        &msg, sizeof(uint32_t)) != SUCCESS );

        call Leds.led1Toggle();
    }


    event void Produtor.run(void* arg) {
        uint16_t counter = 1;
        uint16_t num_prods, j;
        
        for (num_prods = 0; num_prods < 1000; num_prods++)
        {
            call Semaphore.acquire(&sem_buffer_cheio);

            //Tempo simulado para criar um produto
            for (j = 0; j < 100; j++)
                counter *= 3;

            call Mutex.lock(&mutex_buffer);
                buffer = counter;
            call Mutex.unlock(&mutex_buffer);

            call Semaphore.release(&sem_produto);
        }
    }

    event void Consumidor.run(void* arg) {
        uint16_t num_prods, j;
        uint16_t counter = 0;

        for (num_prods = 0; num_prods < 1000; num_prods++)
        {
            call Semaphore.acquire(&sem_produto); 

            call Mutex.lock(&mutex_buffer);
                counter = buffer;
            call Mutex.unlock(&mutex_buffer);

            //Tempo simulado para consumir produto
            for (j = 0; j < 100; j++)
                counter *= 3;

            call Semaphore.release(&sem_buffer_cheio);
        }
        call Semaphore.release(&sem_termino); 
    }

}
