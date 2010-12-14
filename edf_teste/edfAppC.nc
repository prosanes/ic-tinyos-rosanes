
/**
 * Aplicativo de teste do Scheduler Earliest Deadline First
 *
 **/

configuration edfAppC
{
}
implementation
{
  components MainC, edfC, LedsC;

  edfC -> MainC.Boot;
  edfC.Leds -> LedsC;
  

}

