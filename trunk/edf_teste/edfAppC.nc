
/**
 * Aplicativo de teste do Scheduler Earliest Deadline First
 *
 **/

configuration edfAppC
{
}
implementation
{
  components MainC, edfC;


  edfC -> MainC.Boot;

}

