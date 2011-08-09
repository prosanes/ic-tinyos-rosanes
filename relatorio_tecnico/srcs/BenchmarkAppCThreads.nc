configuration BenchmarkAppC{
}
implementation {
  components MainC, BenchmarkC,  LedsC;
  components new ThreadC(800) as Produtor;
  components new ThreadC(800) as Consumidor;
  components new ThreadC(800) as SerialSender;

  components CounterMicro32C as Timer; 
  BenchmarkC.Timer -> Timer;


  components BlockingSerialActiveMessageC;
  components new BlockingSerialAMSenderC(228);
  BenchmarkC.AMControl -> BlockingSerialActiveMessageC;
  BenchmarkC.BlockingAMSend -> BlockingSerialAMSenderC;
  BenchmarkC.Packet -> BlockingSerialAMSenderC;

  MainC.Boot <- BenchmarkC;

  BenchmarkC.Produtor -> Produtor;
  BenchmarkC.Consumidor -> Consumidor; 
  BenchmarkC.SerialSender -> SerialSender;

  BenchmarkC.Leds -> LedsC;

  components MutexC;
  BenchmarkC.Mutex -> MutexC;

  components SemaphoreC;
  BenchmarkC.Semaphore -> SemaphoreC;
}

