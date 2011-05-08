#include "Timer.h"
#include "printf.h"

#include "chip_thread.h"

module aplicacaoTesteC @safe()
{
    uses interface Boot;
    uses interface Leds;
    uses interface Counter<TMicro, uint32_t> as Timer1;
}
implementation
{
    /* Variaveis */
    unsigned int t1;
    bool over;

    async event void Timer1.overflow()
    {
        atomic over = TRUE;
    }

    void first()
    {
        printf("first 1\n");
        printfflush();
        second();
        printf("first 2\n");
        printfflush();
    }

    /* Boot
    */
    event void Boot.booted()
    {
//        over = FALSE;
//        t1 = call Timer1.get();
//        printf("tempo inicial: %u\n", t1);
//        printfflush();
       coro_regs_t main, side; 

        call Leds.led0Toggle();


        call Leds.led2Toggle();
    }

}
