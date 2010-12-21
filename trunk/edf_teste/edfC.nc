
/**
 * Implementa aplicativo de teste do Scheduler EDF
 **/


module edfC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface TaskDeadline<TMilli> as tarefaEDF; 
}
implementation
{
    //Tarefa simples 1
    task void tarefa1()
    {
        //Faz qualquer coisa
        dbg("Deadline", "Tarefa 1\n");
        //call Leds.led0Toggle();
    }

    //Tarefa simples 2
    task void tarefa2()
    {
        //Faz qualquer coisa
        dbg("Deadline", "Tarefa 2\n");
        call Leds.led1Toggle();
    }

    //Tarefa EDF. Run task eh equivalente as task void tarefa() { }
    event void tarefaEDF.runTask()
    {
        dbg("Deadline", "Tarefa EDF\n");
        call Leds.led2Toggle();
    }

    event void Boot.booted()
    {
        dbg("Deadline", "Boot!\n");
        //Postar tarefas
        post tarefa1();
        post tarefa2();
        call tarefaEDF.postTask(20);
        dbg("Deadline", "Todas tarefas postadas\n");
    }

}
