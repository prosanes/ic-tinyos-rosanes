
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
  edfC.tarefaEDF2 -> TinySchedulerC.TaskDeadline[unique("TinySchedulerC.TaskDeadline")]; 
  edfC.tarefaEDF3 -> TinySchedulerC.TaskDeadline[unique("TinySchedulerC.TaskDeadline")]; 
  edfC.tarefaEDF4 -> TinySchedulerC.TaskDeadline[unique("TinySchedulerC.TaskDeadline")]; 
}

