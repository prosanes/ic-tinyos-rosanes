
/**
 * Implementa aplicativo de teste do Scheduler de prioridade 
 **/

#include "Timer.h"
#include "printf.h"

module aplicacaoTesteC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface TaskSerial as TarefaSerial;
    uses interface TaskRadio as TarefaRadio;
    uses interface TaskSense as TarefaSense;

    uses interface Counter<TMicro, uint32_t> as Timer1;
}
implementation
{
    /* Variaveis */
    unsigned int t1;
    bool over;

    async event void Timer1.overflow()
    {
        over = TRUE;
    }

    /* Tarefas
    */
    task void TarefaBasic()
    {
        printf("tarefa Basic\n");
        printfflush();
    }

    event void TarefaSense.runTask()
    {
        printf("tarefa Sense\n");
        printfflush();
    }

    event void TarefaRadio.runTask()
    {
        printf("tarefa Radio\n");
        printfflush();
    }

    event void TarefaSerial.runTask()
    {
        printf("tarefa Serial\n");
        printfflush();
    }

    /* Boot
    */
    event void Boot.booted()
    {
        over = FALSE;
        t1 = call Timer1.get();
        printf("tempo inicial: %u\n", t1);
        printfflush();
        
        post TarefaBasic();
        call TarefaSense.postTask();
        call TarefaRadio.postTask();
        call TarefaSerial.postTask();

    }
}
