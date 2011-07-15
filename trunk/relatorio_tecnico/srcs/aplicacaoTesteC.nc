
/**
 * Implementa aplicativo de teste do Scheduler de prioridade 
 **/

#include "MsgSerial.h"
#include "Timer.h"
#include "printf.h"

module aplicacaoTesteC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface TaskPrioridade as Tarefa1;
    uses interface TaskPrioridade as Tarefa2;
    uses interface TaskPrioridade as Tarefa3;
    uses interface TaskPrioridade as Tarefa4;
    uses interface TaskPrioridade as Tarefa5;
    // ...
    uses interface TaskPrioridade as Tarefa98;
    uses interface TaskPrioridade as Tarefa99;

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

    /* Boot
    */
    event void Boot.booted()
    {
        over = FALSE;
        t1 = call Timer1.get();
        printf("tempo inicial: %u\n", t1);
        printfflush();
        
        call Tarefa1.postTask(20);

        call Tarefa2.postTask(10);
        call Tarefa3.postTask(10);
        // ...
        call Tarefa98.postTask(10);
        call Tarefa99.postTask(10);
    }

    /* Tarefas
    */
    event void Tarefa1.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
        // Calculo do tempo de execucao
        t1 = call Timer1.get();
        printf("tempo final: %u\n", t1);
        if (over == TRUE)
            printf("Ocorreu Overflow\n");
        printfflush();
    }
    event void Tarefa2.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }

    // ...

    event void Tarefa99.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
}
