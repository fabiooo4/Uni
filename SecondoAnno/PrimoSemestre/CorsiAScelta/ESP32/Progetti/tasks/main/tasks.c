#include "freertos/FreeRTOS.h"
#include "freertos/projdefs.h"
#include "freertos/task.h"
#include "portmacro.h"

// Dynamic task
TaskHandle_t dynamic_task_handle;

// Task 1
#define TASK1_STACK_SIZE 2048
TaskHandle_t task1_handle;
StackType_t task1_stack[TASK1_STACK_SIZE];
StaticTask_t task1_tcb;

// Task 2
#define TASK2_STACK_SIZE 1048
TaskHandle_t task2_handle;
StackType_t task2_stack[TASK1_STACK_SIZE];
StaticTask_t task2_tcb;

void task1(void *pvParameter) {
  while (1) {
    if (pvParameter != NULL) {
      printf("Executing Task: %s\n", (char *)pvParameter);
    } else {
      printf("Executing Task\n");
    }

    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

void delete_task_1(void *pvParameter) {
  printf("Deleting task 1...\n");
  vTaskDelete(dynamic_task_handle);
  vTaskDelay(50 / portTICK_PERIOD_MS);
  vTaskDelete(task1_handle);

  vTaskDelay(1000 / portTICK_PERIOD_MS);

  printf("Deleting myself...\n");
  vTaskDelete(task2_handle);
}

void app_main(void) {
  printf("Main Task\n");

  /*
   Create a task
   Parameters:
   - `TaskFunction_t pxTaskCode (aka void (*)(void *))` The task function
   - `const char *const pcName` The name of the task
   - `const uint32_t usStackDepth (aka const unsigned int)` The stack size
   - `void *const pvParameters` The task parameters
   - `UBaseType_t uxPriority (aka unsigned int)` The task priority (0 is the
   highest priority)
   - `TaskHandle_t *const pxCreatedTask (aka struct tskTaskControlBlock
   **const)` The task handle
  */
  if (pdPASS != xTaskCreate(task1, "Task", 1024, NULL, 1, &dynamic_task_handle))
    fprintf(stderr, "Failed to create Task 1\n");

  /*
   The static variant of the task creation function is used to create a task
   with a statically allocated stack and TCB (Task Control Block). This is
   useful when the stack and TCB are allocated in a specific memory region.
   This is better for memory management.
  */
  task1_handle = xTaskCreateStatic(task1, "Static Task", TASK1_STACK_SIZE, "Static", 1,
                    task1_stack, &task1_tcb);

  task2_handle = xTaskCreateStatic(delete_task_1, "Delete Task 1", TASK2_STACK_SIZE, NULL, 1,
                    task2_stack, &task2_tcb);
}
