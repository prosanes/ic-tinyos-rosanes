
/**
 * Aplicativo de teste do Scheduler Earliest Deadline First
 *
 **/

configuration edfAppC
{
}
implementation
{
  components MainC, edfC, LedsC, TinySchedulerC;

  edfC -> MainC.Boot;
  edfC.Leds -> LedsC;
  edfC.tarefaEDF -> TinySchedulerC.TaskDeadline[unique("TinySchedulerC.TaskDeadline")]; 

}

