#include "Timer.h"
#include "printf.h"
#include <setjmp.h>

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
    static jmp_buf buf;

    async event void Timer1.overflow()
    {
        over = TRUE;
    }

   void second()
    {
        printf("second\n");
        printfflush();
        call Leds.led1Toggle();
        longjmp(buf, 1);
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
        over = FALSE;
        t1 = call Timer1.get();
        printf("tempo inicial: %u\n", t1);
        printfflush();

        call Leds.led0Toggle();

        if (!setjmp(buf))
            first();

        call Leds.led2Toggle();
    }

}
