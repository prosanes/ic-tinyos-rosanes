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
  }
}

implementation {
    uint32_t t1;
    uint32_t * tempo;
    uint8_t buffer;

    async event void Timer.overflow()
    {}                                 

    event void Boot.booted() {
      buffer = 0;
      t1 = call Timer.get();

      call Produtor.start(NULL);
      call Consumidor.start(NULL);
    }

    event void SerialSender.run(void* arg)
    {
        message_t msg;

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
    }


    event void Produtor.run(void* arg) {
        uint16_t counter = 1;
        uint16_t num_prods, j;
        
        for (num_prods = 0; num_prods < 1000; num_prods++)
        {
            //Tempo simulado para criar um produto
            for (j = 0; j < 100; j++)
                counter *= 3;

            buffer = counter;

            call Produtor.yield();
        }
    }

    event void Consumidor.run(void* arg) {
        uint16_t num_prods, j;
        uint16_t counter = 0;

        for (num_prods = 0; num_prods < 1000; num_prods++)
        {
            counter = buffer;

            //Tempo simulado para consumir produto
            for (j = 0; j < 100; j++)
                counter *= 3;

            call Consumidor.yield();
        }
        call SerialSender.start(NULL);
    }

}
