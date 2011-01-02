
/**
 * Implementa aplicativo de teste do Scheduler de prioridade 
 **/


module prioridadeC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface TaskPrioridade as tarefaPR; 
    uses interface TaskPrioridade as tarefaPR2;
    uses interface TaskPrioridade as tarefaPR3;
    uses interface TaskPrioridade as tarefaPR4;
}
implementation
{
    //Tarefa simples 1
    task void tarefa1()
    {
        //Faz qualquer coisa
        dbg("Prioridade", "Tarefa 1\n");
        //call Leds.led0Toggle();
    }

    //Tarefa simples 2
    task void tarefa2()
    {
        //Faz qualquer coisa
        dbg("Prioridade", "Tarefa 2\n");
        call Leds.led1Toggle();
    }

    //Tarefa PR. Run task eh equivalente as task void tarefa() { }
    event void tarefaPR.runTask()
    {
        dbg("Prioridade", "Tarefa PR1\n");
        call Leds.led2Toggle();
    }

    //Tarefa PR. Run task eh equivalente as task void tarefa() { }
    event void tarefaPR2.runTask()
    {
        dbg("Prioridade", "Tarefa PR2\n");
        call Leds.led2Toggle();
    }
    //Tarefa PR. Run task eh equivalente as task void tarefa() { }
    event void tarefaPR3.runTask()
    {
        dbg("Prioridade", "Tarefa PR3\n");
        call Leds.led2Toggle();
    }
    //Tarefa PR. Run task eh equivalente as task void tarefa() { }
    event void tarefaPR4.runTask()
    {
        dbg("Prioridade", "Tarefa PR4\n");
        call Leds.led2Toggle();
    }

    event void Boot.booted()
    {
        dbg("Prioridade", "Boot!\n");
        //Postar tarefas
        post tarefa1();
        post tarefa2();
        call tarefaPR.postTask(20);
        call tarefaPR2.postTask(1);
        call tarefaPR2.postTask(1);
        call tarefaPR2.postTask(1);
        call tarefaPR3.postTask(0);
        call tarefaPR4.postTask(18);
        dbg("Prioridade", "Todas tarefas postadas\n");
    }

}
