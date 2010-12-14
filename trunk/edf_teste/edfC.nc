
/**
 * Implementa aplicativo de teste do Scheduler EDF
 **/


module edfC @safe()
{
    uses interface Boot;
    uses interface Leds;
}
implementation
{
    task void tarefa1()
    {
        //Faz qualquer coisa
        dbg("Deadline", "Tarefa 1");
        //call Leds.led0Toggle();
    }

    task void tarefa2()
    {
        //Faz qualquer coisa
        dbg("Deadline", "Tarefa 2");
        call Leds.led1Toggle();
    }

    event void Boot.booted()
    {
        dbg("Deadline", "Boot!\n");
        //Postar tarefas
        post tarefa1();
        dbg("Deadline", "Boot!\n");
        post tarefa2();
        dbg("Deadline", "Boot!\n");
        call Leds.led2Toggle();
    }

}
