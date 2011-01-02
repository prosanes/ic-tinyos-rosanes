
/**
 * Implementa aplicativo de teste do Scheduler EDF
 **/


module edfC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface TaskDeadline<TMilli> as tarefaEDF; 
    uses interface TaskDeadline<TMilli> as tarefaEDF2;
    uses interface TaskDeadline<TMilli> as tarefaEDF3;
    uses interface TaskDeadline<TMilli> as tarefaEDF4;
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
        dbg("Deadline", "Tarefa EDF1\n");
        call Leds.led2Toggle();
    }

    //Tarefa EDF. Run task eh equivalente as task void tarefa() { }
    event void tarefaEDF2.runTask()
    {
        dbg("Deadline", "Tarefa EDF2\n");
        call Leds.led2Toggle();
    }
    //Tarefa EDF. Run task eh equivalente as task void tarefa() { }
    event void tarefaEDF3.runTask()
    {
        dbg("Deadline", "Tarefa EDF3\n");
        call Leds.led2Toggle();
    }
    //Tarefa EDF. Run task eh equivalente as task void tarefa() { }
    event void tarefaEDF4.runTask()
    {
        dbg("Deadline", "Tarefa EDF4\n");
        call Leds.led2Toggle();
    }

    event void Boot.booted()
    {
        dbg("Deadline", "Boot!\n");
        //Postar tarefas
        post tarefa1();
        post tarefa2();
        call tarefaEDF.postTask(20);
        call tarefaEDF2.postTask(1);
        call tarefaEDF2.postTask(1);
        call tarefaEDF2.postTask(1);
        call tarefaEDF3.postTask(0);
        call tarefaEDF4.postTask(18);
        dbg("Deadline", "Todas tarefas postadas\n");
    }

}
