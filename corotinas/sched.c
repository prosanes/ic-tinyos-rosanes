/* sched.c, December 02, 2005 */

/** A new TinyOS scheduler to handle tasks and coroutines
  * @author Silvana Rossetto (silvana@inf.puc-rio.br)
  * @author DI/PUC-Rio
  * @author DEI/Politecnico di Milano
**/

#include <setjmp.h>

//------------------------------------------------------- Task definition!!
void TOSH_wait(void);
void TOSH_sleep(void);

// task data structure
typedef struct {
  void (*tp) ();
} TOSH_sched_entry_T;

enum {
#ifdef TOSH_MAX_TASKS_LOG2
#if TOSH_MAX_TASKS_LOG2 > 8
#error "Maximum of 256 tasks, TOSH_MAX_TASKS_LOG2 must be <= 8"
#endif
  TOSH_MAX_TASKS = 1 << TOSH_MAX_TASKS_LOG2,
#else
  TOSH_MAX_TASKS = 8,
#endif
  TOSH_TASK_BITMASK = (TOSH_MAX_TASKS - 1)
};

volatile TOSH_sched_entry_T TOSH_queue[TOSH_MAX_TASKS];
uint8_t TOSH_sched_full;
volatile uint8_t TOSH_sched_free;


//------------------------------------------------------- Coroutine definition!!
/* these values must be power of two (N^2) */
int AVR_CO_MIN_SIZE=256;
int AVR_STK_ALIGN=64, AVR_STK_COROSIZE=64;

/* jmp_buf pointers */
enum {
 AVR_SP = 18, // stack pointer 
 AVR_PC = 21, // program counter 
};

/* function pointer type */
typedef void (*procedure_t)();
/* coroutine type */
typedef void *coroutine_t;

/* coroutine struct */
typedef struct s_coroutine {
 jmp_buf ctx;
 uint16_t size;
 procedure_t proc;
 struct s_coroutine *caller;
} coroutine;

/* coroutine complete type */
typedef struct {
  coroutine_t coro; 
  uint8_t status; //SUSPENDED, READY, DEAD
} coroutine_T;

/* coroutine status */
enum {SUSPENDED=1, READY=2, DEAD=3};

/* max number of coroutines */
enum {MAX_CORO=5, CORO_BITMASK=(MAX_CORO - 1)};

volatile coroutine_T coro_queue[MAX_CORO]; //coroutine queue
uint8_t coro_sched_full; //index of first used slot (head of list)
uint8_t coro_sched_current; //index of current coroutine
volatile uint8_t coro_sched_free; //index of first free slot (after tail of list)

//---------------------------------------------------- Coroutine implementation!!
static coroutine g_coMain;              // main coroutine
static coroutine *g_coCurr = &g_coMain; // current coroutine

static void _setContext
  (jmp_buf *ctx, procedure_t proc, char *stkbase, int16_t stksize) {
  uint16_t p = (uint16_t *) proc;
  char *stack = stkbase + stksize - sizeof(int16_t);
  uint16_t s = (uint16_t *) stack;
  setjmp(*ctx);
  ctx[0]->_jb[AVR_PC] = (char) p & 0xff;
  ctx[0]->_jb[AVR_PC+1] = (char) (p >> 8) & 0xff;
  ctx[0]->_jb[AVR_SP] =  (char) s & 0xff;
  ctx[0]->_jb[AVR_SP+1] = (char) (s >> 8) & 0xff;
}

static void _switchContext(jmp_buf *octx, jmp_buf *nctx) {
  if (!setjmp(*octx)) longjmp(*nctx, 1);
}

void _runner() __attribute__((spontaneous)) {
//  __nesc_atomic_t fInterruptFlags;
  procedure_t p;
  coroutine *co;
//  fInterruptFlags = __nesc_atomic_start();
  co = g_coCurr;
  p = co->proc;
//  __nesc_atomic_end(fInterruptFlags);
  p();
//  fInterruptFlags = __nesc_atomic_start();
  co->proc = NULL;
  g_coCurr = co->caller;
//  __nesc_atomic_end(fInterruptFlags);
  _switchContext(&co->ctx, &g_coCurr->ctx);
}

static coroutine_t create(int16_t size) {
  coroutine * co;
  if ((size &= ~(sizeof(uint16_t) - 1)) < AVR_CO_MIN_SIZE) 
    return NULL;
  size = (size + sizeof(coroutine) + AVR_STK_ALIGN-1) & ~(AVR_STK_ALIGN-1);
  co = malloc(size);
  if (!co) 
    return NULL;
  co->size = size;
  co->proc = NULL;
  return (coroutine_t) co;
}

static uint8_t setProcedure(coroutine_t coro, procedure_t proc) {
  coroutine *co = (coroutine *) coro;
  char *stack;
  if (co->proc == NULL) {
   stack = (char *) co;
   co->proc = proc;
   _setContext(&co->ctx, _runner, stack, co->size);
  } else return 0;
  return 1;
}

void resume(coroutine_t coro)  __attribute__((spontaneous)) {
//  __nesc_atomic_t fInterruptFlags;
  coroutine *co, *oldco; 
//  fInterruptFlags = __nesc_atomic_start();
  co = (coroutine *) coro; 
  oldco = g_coCurr;
  co->caller = g_coCurr;
  g_coCurr = co;
//  __nesc_atomic_end(fInterruptFlags);
  _switchContext(&oldco->ctx, &co->ctx);
}

void yield()  __attribute__((spontaneous)) {
//  __nesc_atomic_t fInterruptFlags;
  coroutine *co;
//  fInterruptFlags = __nesc_atomic_start();
  co = g_coCurr;
  g_coCurr = co->caller;
//  __nesc_atomic_end(fInterruptFlags);
  _switchContext(&co->ctx, &g_coCurr->ctx);
}

static uint8_t isDead(coroutine_t coro) {
  coroutine *co = (coroutine *) coro; 
  if (co->proc) return 0; else return 1;
}

//------------------------------------------ Coroutine scheduler!!
static void coro_changeStatus(uint8_t poscoro, uint8_t status) {
 coro_queue[poscoro].status = status;
}

static uint8_t coro_current() {
 return coro_sched_current;
}

// (based on task functions)
// post a new coroutine execution
bool TOS_post_coro(void (* proc)()) __attribute__((spontaneous)) {
//  __nesc_atomic_t fInterruptFlags;
  uint8_t tmp, aux;
//  fInterruptFlags = __nesc_atomic_start();
  tmp = coro_sched_free;
  do {
   if (coro_queue[tmp].status == DEAD) {
     coro_sched_free = (tmp + 1) & CORO_BITMASK;
     setProcedure(coro_queue[tmp].coro, proc);
     coro_queue[tmp].status = READY;
//     __nesc_atomic_end(fInterruptFlags);
     return TRUE;
   } 
   aux = (tmp + 1) & CORO_BITMASK;
   tmp = aux;
  } while (aux != coro_sched_free);
//  __nesc_atomic_end(fInterruptFlags);
  return FALSE;
}

// resume the next coroutine
void TOSH_run_next_coro() __attribute__((spontaneous)) {
//  __nesc_atomic_t fInterruptFlags;
  uint8_t old_full;
  uint8_t tmp = MAX_CORO;
  
//  fInterruptFlags = __nesc_atomic_start();
  while(tmp) {
   old_full = coro_sched_full;
   if (coro_queue[old_full].status == READY) {
    coro_sched_current = old_full;
//    __nesc_atomic_end(fInterruptFlags);
    resume(coro_queue[old_full].coro);
//    fInterruptFlags = __nesc_atomic_start();
    if (isDead(coro_queue[old_full].coro))
      coro_queue[old_full].status = DEAD;
    else
      coro_queue[old_full].status = SUSPENDED;
   }
   tmp--;
   coro_sched_full = (old_full + 1) & CORO_BITMASK;
  }
//  __nesc_atomic_end(fInterruptFlags);
}

// initialize the coroutine queue
void TOSH_coro_sched_init(void) {
  int i;
  coro_sched_free = 0;
  coro_sched_full = 0;
  for (i=0; i<MAX_CORO; i++) {
    coro_queue[i].coro = create(AVR_CO_MIN_SIZE);
    coro_queue[i].status = DEAD;
  }
}

//------------------------------------------------- Task scheduler!!
// initialize all
void TOSH_sched_init(void)
{
  int i;
  TOSH_sched_free = 0;
  TOSH_sched_full = 0;
  for (i = 0; i < TOSH_MAX_TASKS; i++)
    TOSH_queue[i].tp = NULL;
  TOSH_coro_sched_init();
}

// post task
bool TOS_post(void (*tp) ()) __attribute__((spontaneous)) {
//  __nesc_atomic_t fInterruptFlags;
  uint8_t tmp;
//  fInterruptFlags = __nesc_atomic_start();
  tmp = TOSH_sched_free;
  if (TOSH_queue[tmp].tp == NULL) {
    TOSH_sched_free = (tmp + 1) & TOSH_TASK_BITMASK;
    TOSH_queue[tmp].tp = tp;
//    __nesc_atomic_end(fInterruptFlags);
    return TRUE;
  }
  else {
//    __nesc_atomic_end(fInterruptFlags);
    return FALSE;
  }
}

// run the next task
bool TOSH_run_next_task () {
  __nesc_atomic_t fInterruptFlags;
  uint8_t old_full;
  void (*func)(void);
  fInterruptFlags = __nesc_atomic_start();
  old_full = TOSH_sched_full;
  func = TOSH_queue[old_full].tp;
  if (func == NULL)
    {
      __nesc_atomic_end(fInterruptFlags);
      return 0;
    }
  TOSH_queue[old_full].tp = NULL;
  TOSH_sched_full = (old_full + 1) & TOSH_TASK_BITMASK;
  __nesc_atomic_end(fInterruptFlags);
  func();
  return 1;
}

// main loop
void TOSH_run_task() {
  while (TOSH_run_next_task())
   ;
  TOSH_run_next_coro(); 
  TOSH_sleep();
  TOSH_wait();
}

//---------------------------------------- public interface for the coroutine scheduler!!
void RESTORE(uint8_t poscoro) __attribute__((spontaneous)) {
// __nesc_atomic_t fInterruptFlags;
// fInterruptFlags = __nesc_atomic_start();
 coro_changeStatus(poscoro, READY);
// __nesc_atomic_end(fInterruptFlags);
}

void SUSPEND() {yield();}

uint8_t GETID() __attribute__((spontaneous)) {
// __nesc_atomic_t fInterruptFlags;
// fInterruptFlags = __nesc_atomic_start();
 return coro_current();
// __nesc_atomic_end(fInterruptFlags);
}

bool POST(void (*proc)()) __attribute__((spontaneous)) {
 return TOS_post_coro(proc);
}
