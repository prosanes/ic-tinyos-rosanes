#include "TinyError.h"

interface TaskRadio {

  /**
   *
   * @return SUCCESS if task was successfuly
   * posted; the semantics of a non-SUCCESS return value depend on the
   * implementation of this interface (the class of task).
   */
  
  async command error_t postTask();

  /**
   * Event from the scheduler to run this task. Following the TinyOS
   * concurrency model, the codes invoked from <tt>run()</tt> signals
   * execute atomically with respect to one another, but can be
   * preempted by async commands/events.
   id runTask();
   */
  event void runTask();
}
