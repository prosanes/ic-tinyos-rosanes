
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
    uses interface TaskPrioridade as Tarefa6;
    uses interface TaskPrioridade as Tarefa7;
    uses interface TaskPrioridade as Tarefa8;
    uses interface TaskPrioridade as Tarefa9;
    uses interface TaskPrioridade as Tarefa10;
    uses interface TaskPrioridade as Tarefa11;
    uses interface TaskPrioridade as Tarefa12;
    uses interface TaskPrioridade as Tarefa13;
    uses interface TaskPrioridade as Tarefa14;
    uses interface TaskPrioridade as Tarefa15;
    uses interface TaskPrioridade as Tarefa16;
    uses interface TaskPrioridade as Tarefa17;
    uses interface TaskPrioridade as Tarefa18;
    uses interface TaskPrioridade as Tarefa19;
    uses interface TaskPrioridade as Tarefa20;
    uses interface TaskPrioridade as Tarefa21;
    uses interface TaskPrioridade as Tarefa22;
    uses interface TaskPrioridade as Tarefa23;
    uses interface TaskPrioridade as Tarefa24;
    uses interface TaskPrioridade as Tarefa25;
    uses interface TaskPrioridade as Tarefa26;
    uses interface TaskPrioridade as Tarefa27;
    uses interface TaskPrioridade as Tarefa28;
    uses interface TaskPrioridade as Tarefa29;
    uses interface TaskPrioridade as Tarefa30;
    uses interface TaskPrioridade as Tarefa31;
    uses interface TaskPrioridade as Tarefa32;
    uses interface TaskPrioridade as Tarefa33;
    uses interface TaskPrioridade as Tarefa34;
    uses interface TaskPrioridade as Tarefa35;
    uses interface TaskPrioridade as Tarefa36;
    uses interface TaskPrioridade as Tarefa37;
    uses interface TaskPrioridade as Tarefa38;
    uses interface TaskPrioridade as Tarefa39;
    uses interface TaskPrioridade as Tarefa40;
    uses interface TaskPrioridade as Tarefa41;
    uses interface TaskPrioridade as Tarefa42;
    uses interface TaskPrioridade as Tarefa43;
    uses interface TaskPrioridade as Tarefa44;
    uses interface TaskPrioridade as Tarefa45;
    uses interface TaskPrioridade as Tarefa46;
    uses interface TaskPrioridade as Tarefa47;
    uses interface TaskPrioridade as Tarefa48;
    uses interface TaskPrioridade as Tarefa49;
    uses interface TaskPrioridade as Tarefa50;
    uses interface TaskPrioridade as Tarefa51;
    uses interface TaskPrioridade as Tarefa52;
    uses interface TaskPrioridade as Tarefa53;
    uses interface TaskPrioridade as Tarefa54;
    uses interface TaskPrioridade as Tarefa55;
    uses interface TaskPrioridade as Tarefa56;
    uses interface TaskPrioridade as Tarefa57;
    uses interface TaskPrioridade as Tarefa58;
    uses interface TaskPrioridade as Tarefa59;
    uses interface TaskPrioridade as Tarefa60;
    uses interface TaskPrioridade as Tarefa61;
    uses interface TaskPrioridade as Tarefa62;
    uses interface TaskPrioridade as Tarefa63;
    uses interface TaskPrioridade as Tarefa64;
    uses interface TaskPrioridade as Tarefa65;
    uses interface TaskPrioridade as Tarefa66;
    uses interface TaskPrioridade as Tarefa67;
    uses interface TaskPrioridade as Tarefa68;
    uses interface TaskPrioridade as Tarefa69;
    uses interface TaskPrioridade as Tarefa70;
    uses interface TaskPrioridade as Tarefa71;
    uses interface TaskPrioridade as Tarefa72;
    uses interface TaskPrioridade as Tarefa73;
    uses interface TaskPrioridade as Tarefa74;
    uses interface TaskPrioridade as Tarefa75;
    uses interface TaskPrioridade as Tarefa76;
    uses interface TaskPrioridade as Tarefa77;
    uses interface TaskPrioridade as Tarefa78;
    uses interface TaskPrioridade as Tarefa79;
    uses interface TaskPrioridade as Tarefa80;
    uses interface TaskPrioridade as Tarefa81;
    uses interface TaskPrioridade as Tarefa82;
    uses interface TaskPrioridade as Tarefa83;
    uses interface TaskPrioridade as Tarefa84;
    uses interface TaskPrioridade as Tarefa85;
    uses interface TaskPrioridade as Tarefa86;
    uses interface TaskPrioridade as Tarefa87;
    uses interface TaskPrioridade as Tarefa88;
    uses interface TaskPrioridade as Tarefa89;
    uses interface TaskPrioridade as Tarefa90;
    uses interface TaskPrioridade as Tarefa91;
    uses interface TaskPrioridade as Tarefa92;
    uses interface TaskPrioridade as Tarefa93;
    uses interface TaskPrioridade as Tarefa94;
    uses interface TaskPrioridade as Tarefa95;
    uses interface TaskPrioridade as Tarefa96;
    uses interface TaskPrioridade as Tarefa97;
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
        call Tarefa4.postTask(10);
        call Tarefa5.postTask(10);
        call Tarefa6.postTask(10);
        call Tarefa7.postTask(10);
        call Tarefa8.postTask(10);
        call Tarefa9.postTask(10);
        call Tarefa10.postTask(10);
        call Tarefa11.postTask(10);
        call Tarefa12.postTask(10);
        call Tarefa13.postTask(10);
        call Tarefa14.postTask(10);
        call Tarefa15.postTask(10);
        call Tarefa16.postTask(10);
        call Tarefa17.postTask(10);
        call Tarefa18.postTask(10);
        call Tarefa19.postTask(10);
        call Tarefa20.postTask(10);
        call Tarefa21.postTask(10);
        call Tarefa22.postTask(10);
        call Tarefa23.postTask(10);
        call Tarefa24.postTask(10);
        call Tarefa25.postTask(10);
        call Tarefa26.postTask(10);
        call Tarefa27.postTask(10);
        call Tarefa28.postTask(10);
        call Tarefa29.postTask(10);
        call Tarefa30.postTask(10);
        call Tarefa31.postTask(10);
        call Tarefa32.postTask(10);
        call Tarefa33.postTask(10);
        call Tarefa34.postTask(10);
        call Tarefa35.postTask(10);
        call Tarefa36.postTask(10);
        call Tarefa37.postTask(10);
        call Tarefa38.postTask(10);
        call Tarefa39.postTask(10);
        call Tarefa40.postTask(10);
        call Tarefa41.postTask(10);
        call Tarefa42.postTask(10);
        call Tarefa43.postTask(10);
        call Tarefa44.postTask(10);
        call Tarefa45.postTask(10);
        call Tarefa46.postTask(10);
        call Tarefa47.postTask(10);
        call Tarefa48.postTask(10);
        call Tarefa49.postTask(10);
        call Tarefa50.postTask(10);
        call Tarefa51.postTask(10);
        call Tarefa52.postTask(10);
        call Tarefa53.postTask(10);
        call Tarefa54.postTask(10);
        call Tarefa55.postTask(10);
        call Tarefa56.postTask(10);
        call Tarefa57.postTask(10);
        call Tarefa58.postTask(10);
        call Tarefa59.postTask(10);
        call Tarefa60.postTask(10);
        call Tarefa61.postTask(10);
        call Tarefa62.postTask(10);
        call Tarefa63.postTask(10);
        call Tarefa64.postTask(10);
        call Tarefa65.postTask(10);
        call Tarefa66.postTask(10);
        call Tarefa67.postTask(10);
        call Tarefa68.postTask(10);
        call Tarefa69.postTask(10);
        call Tarefa70.postTask(10);
        call Tarefa71.postTask(10);
        call Tarefa72.postTask(10);
        call Tarefa73.postTask(10);
        call Tarefa74.postTask(10);
        call Tarefa75.postTask(10);
        call Tarefa76.postTask(10);
        call Tarefa77.postTask(10);
        call Tarefa78.postTask(10);
        call Tarefa79.postTask(10);
        call Tarefa80.postTask(10);
        call Tarefa81.postTask(10);
        call Tarefa82.postTask(10);
        call Tarefa83.postTask(10);
        call Tarefa84.postTask(10);
        call Tarefa85.postTask(10);
        call Tarefa86.postTask(10);
        call Tarefa87.postTask(10);
        call Tarefa88.postTask(10);
        call Tarefa89.postTask(10);
        call Tarefa90.postTask(10);
        call Tarefa91.postTask(10);
        call Tarefa92.postTask(10);
        call Tarefa93.postTask(10);
        call Tarefa94.postTask(10);
        call Tarefa95.postTask(10);
        call Tarefa96.postTask(10);
        call Tarefa97.postTask(10);
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
        t1 = call Timer1.get();
        printf("tempo final: %u\n", t1);
        if (over == TRUE)
            printf("OVERFLOW!!\n");
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
    event void Tarefa3.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa4.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa5.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa6.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa7.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa8.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa9.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa10.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa11.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa12.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa13.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa14.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa15.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa16.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa17.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa18.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa19.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa20.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa21.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa22.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa23.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa24.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa25.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa26.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa27.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa28.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa29.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa30.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa31.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa32.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa33.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa34.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa35.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa36.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa37.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa38.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa39.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa40.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa41.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa42.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa43.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa44.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa45.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa46.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa47.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa48.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa49.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa50.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa51.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa52.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa53.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa54.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa55.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa56.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa57.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa58.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa59.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa60.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa61.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa62.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa63.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa64.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa65.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa66.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa67.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa68.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa69.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa70.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa71.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa72.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa73.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa74.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa75.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa76.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa77.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa78.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa79.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa80.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa81.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa82.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa83.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa84.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa85.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa86.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa87.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa88.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa89.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa90.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa91.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa92.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa93.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa94.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa95.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa96.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa97.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
    event void Tarefa98.runTask()
    {
        uint16_t i = 0;
        uint16_t k = 1;
        for (i = 0; i < 65000; i++)
        {
            k = k * 2;
        }
    }
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
