
/**
 * Aplicativo de teste do Scheduler de prioridade 
 *
 **/

configuration prioridadeAppC 
{
}
implementation
{
  components MainC, prioridadeC, LedsC, TinySchedulerC;

  prioridadeC-> MainC.Boot;
  prioridadeC.Leds -> LedsC;
  prioridadeC.tarefaPR-> TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 
  prioridadeC.tarefaPR2 -> TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 
  prioridadeC.tarefaPR3 -> TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 
  prioridadeC.tarefaPR4 -> TinySchedulerC.TaskPrioridade[unique("TinySchedulerC.TaskPrioridade")]; 
}

