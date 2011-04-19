//Define on platform specific basis for inclusion in
// the thread control block
typedef struct coro_regs {
  uint8_t status;
  uint8_t r0;
  uint8_t r1;
  uint8_t r2;
  uint8_t r3;
  uint8_t r4;
  uint8_t r5;
  uint8_t r6;
  uint8_t r7;
  uint8_t r8;
  uint8_t r9;
  uint8_t r10;
  uint8_t r11;
  uint8_t r12;
  uint8_t r13;
  uint8_t r14;
  uint8_t r15;
  uint8_t r16;
  uint8_t r17;
  uint8_t r18;
  uint8_t r19;
  uint8_t r20;
  uint8_t r21;
  uint8_t r22;
  uint8_t r23;
  uint8_t r24;
  uint8_t r25;
  uint8_t r26;
  uint8_t r27;
  uint8_t r28;
  uint8_t r29;
  uint8_t r30;
  uint8_t r31;
} coro_regs_t;

typedef uint16_t* stack_ptr_t;
  
#define STACK_TOP(stack, size)    \
  (&(((uint8_t*)stack)[size - sizeof(stack_ptr_t)]))
  
//Save stack pointer
#define SAVE_STACK_PTR(c)            		  		\
  __asm__("in %A0, __SP_L__\n\t"					\
          "in %B0, __SP_H__\n\t"					\
          :"=r"((c)->stack_ptr) : );

//Save status register
#define SAVE_STATUS(c)                   	  		\
  __asm__("in %0,__SREG__ \n\t" : "=r" ((c)->regs.status) : );
  
//Save General Purpose Registers
#define SAVE_GPR(c)                        			    \
  __asm__("mov %0,r0 \n\t" : "=r" ((c)->regs.r0) : );   \
  __asm__("mov %0,r1 \n\t" : "=r" ((c)->regs.r1) : );   \
  __asm__("mov %0,r2 \n\t" : "=r" ((c)->regs.r2) : );   \
  __asm__("mov %0,r3 \n\t" : "=r" ((c)->regs.r3) : );   \
  __asm__("mov %0,r4 \n\t" : "=r" ((c)->regs.r4) : );   \
  __asm__("mov %0,r5 \n\t" : "=r" ((c)->regs.r5) : );   \
  __asm__("mov %0,r6 \n\t" : "=r" ((c)->regs.r6) : );   \
  __asm__("mov %0,r7 \n\t" : "=r" ((c)->regs.r7) : );   \
  __asm__("mov %0,r8 \n\t" : "=r" ((c)->regs.r8) : );   \
  __asm__("mov %0,r9 \n\t" : "=r" ((c)->regs.r9) : );   \
  __asm__("mov %0,r10 \n\t" : "=r" ((c)->regs.r10) : );   \
  __asm__("mov %0,r11 \n\t" : "=r" ((c)->regs.r11) : );   \
  __asm__("mov %0,r12 \n\t" : "=r" ((c)->regs.r12) : );   \
  __asm__("mov %0,r13 \n\t" : "=r" ((c)->regs.r13) : );   \
  __asm__("mov %0,r14 \n\t" : "=r" ((c)->regs.r14) : );   \
  __asm__("mov %0,r15 \n\t" : "=r" ((c)->regs.r15) : );   \
  __asm__("mov %0,r16 \n\t" : "=r" ((c)->regs.r16) : );   \
  __asm__("mov %0,r17 \n\t" : "=r" ((c)->regs.r17) : );   \
  __asm__("mov %0,r18 \n\t" : "=r" ((c)->regs.r18) : );   \
  __asm__("mov %0,r19 \n\t" : "=r" ((c)->regs.r19) : );   \
  __asm__("mov %0,r20 \n\t" : "=r" ((c)->regs.r20) : );   \
  __asm__("mov %0,r21 \n\t" : "=r" ((c)->regs.r21) : );   \
  __asm__("mov %0,r22 \n\t" : "=r" ((c)->regs.r22) : );   \
  __asm__("mov %0,r23 \n\t" : "=r" ((c)->regs.r23) : );   \
  __asm__("mov %0,r24 \n\t" : "=r" ((c)->regs.r24) : );   \
  __asm__("mov %0,r25 \n\t" : "=r" ((c)->regs.r25) : );   \
  __asm__("mov %0,r26 \n\t" : "=r" ((c)->regs.r26) : );   \
  __asm__("mov %0,r27 \n\t" : "=r" ((c)->regs.r27) : );   \
  __asm__("mov %0,r28 \n\t" : "=r" ((c)->regs.r28) : );   \
  __asm__("mov %0,r29 \n\t" : "=r" ((c)->regs.r29) : );   \
  __asm__("mov %0,r30 \n\t" : "=r" ((c)->regs.r30) : );   \
  __asm__("mov %0,r31 \n\t" : "=r" ((c)->regs.r31) : );
  
//Restore stack pointer
#define RESTORE_STACK_PTR(c)           			 	 \
  __asm__("out __SP_H__,%B0 \n\t"                    \
          "out __SP_L__,%A0 \n\t"                    \
          ::"r" ((c)->stack_ptr))

//Restore status register
#define RESTORE_STATUS(c)                 			\
  __asm__("out __SREG__,%0 \n\t" :: "r" ((c)->regs.status) ); 

//Restore the general purpose registers
#define RESTORE_GPR(c)           	         		     \
  __asm__("mov r0,%0 \n\t" :: "r" ((c)->regs.r0) );  \
  __asm__("mov r1,%0 \n\t" :: "r" ((c)->regs.r1) );  \
  __asm__("mov r2,%0 \n\t" :: "r" ((c)->regs.r2) );  \
  __asm__("mov r3,%0 \n\t" :: "r" ((c)->regs.r3) );  \
  __asm__("mov r4,%0 \n\t" :: "r" ((c)->regs.r4) );  \
  __asm__("mov r5,%0 \n\t" :: "r" ((c)->regs.r5) );  \
  __asm__("mov r6,%0 \n\t" :: "r" ((c)->regs.r6) );  \
  __asm__("mov r7,%0 \n\t" :: "r" ((c)->regs.r7) );  \
  __asm__("mov r8,%0 \n\t" :: "r" ((c)->regs.r8) );  \
  __asm__("mov r9,%0 \n\t" :: "r" ((c)->regs.r9) );  \
  __asm__("mov r10,%0 \n\t" :: "r" ((c)->regs.r10) );  \
  __asm__("mov r11,%0 \n\t" :: "r" ((c)->regs.r11) );  \
  __asm__("mov r12,%0 \n\t" :: "r" ((c)->regs.r12) );  \
  __asm__("mov r13,%0 \n\t" :: "r" ((c)->regs.r13) );  \
  __asm__("mov r14,%0 \n\t" :: "r" ((c)->regs.r14) );  \
  __asm__("mov r15,%0 \n\t" :: "r" ((c)->regs.r15) );  \
  __asm__("mov r16,%0 \n\t" :: "r" ((c)->regs.r16) );  \
  __asm__("mov r17,%0 \n\t" :: "r" ((c)->regs.r17) );  \
  __asm__("mov r18,%0 \n\t" :: "r" ((c)->regs.r18) );  \
  __asm__("mov r19,%0 \n\t" :: "r" ((c)->regs.r19) );  \
  __asm__("mov r20,%0 \n\t" :: "r" ((c)->regs.r20) );  \
  __asm__("mov r21,%0 \n\t" :: "r" ((c)->regs.r21) );  \
  __asm__("mov r22,%0 \n\t" :: "r" ((c)->regs.r22) );  \
  __asm__("mov r23,%0 \n\t" :: "r" ((c)->regs.r23) );  \
  __asm__("mov r24,%0 \n\t" :: "r" ((c)->regs.r24) );  \
  __asm__("mov r25,%0 \n\t" :: "r" ((c)->regs.r25) );  \
  __asm__("mov r26,%0 \n\t" :: "r" ((c)->regs.r26) );  \
  __asm__("mov r27,%0 \n\t" :: "r" ((c)->regs.r27) );  \
  __asm__("mov r28,%0 \n\t" :: "r" ((c)->regs.r28) );  \
  __asm__("mov r29,%0 \n\t" :: "r" ((c)->regs.r29) );  \
  __asm__("mov r30,%0 \n\t" :: "r" ((c)->regs.r30) );  \
  __asm__("mov r31,%0 \n\t" :: "r" ((c)->regs.r31) );
  
#define SAVE_TCB(c) \
  SAVE_GPR(c);	 	\
  SAVE_STATUS(c);	\
  SAVE_STACK_PTR(c) 
  
#define RESTORE_TCB(c)  \
  RESTORE_STACK_PTR(c); \
  RESTORE_STATUS(c);    \
  RESTORE_GPR(c)
  
#define SWITCH_CONTEXTS(from, to) \
  SAVE_TCB(from);				  \
  RESTORE_TCB(to)

#define SWAP_STACK_PTR(OLD, NEW) \
  __asm__("in %A0, __SP_L__\n\t in %B0, __SP_H__":"=r"(OLD):);\
  __asm__("out __SP_H__,%B0\n\t out __SP_L__,%A0"::"r"(NEW))
 
#define PREPARE_CORO(c, coro_ptr)		               \
  {  uint16_t temp;							               \
     SWAP_STACK_PTR(temp, (c)->stack_ptr);                 \
     __asm__("push %A0\n push %B0"::"r"(&(coro_ptr)));   \
     SWAP_STACK_PTR((c)->stack_ptr, temp);                 \
     SAVE_STATUS(c)							               \
  }
  
