#include "freertos/FreeRTOS.h"
#include "freertos/projdefs.h"
#include "freertos/task.h"
#include "portmacro.h"
#include <stdint.h>
#include <stdio.h>

// Task 1
#define TASK1_STACK_SIZE 2048
TaskHandle_t task1_handle;
StackType_t task1_stack[TASK1_STACK_SIZE];
StaticTask_t task1_tcb;

// Task 2
#define TASK2_STACK_SIZE 2048
TaskHandle_t task2_handle;
StackType_t task2_stack[TASK1_STACK_SIZE];
StaticTask_t task2_tcb;

void task1(void *pvParameter) {
  while (1) {
    uint32_t notificationValue;

    // portMAX_DELAY will block the task until a notification is received
    if (pdTRUE == xTaskNotifyWait(0, 0, &notificationValue, portMAX_DELAY)) {
      printf("Task 1 received: %u\n", (unsigned int)notificationValue);
    } else {
      printf("No notification");
    }

    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

void task2(void *pvParameter) {
  uint32_t count = 0;
  while (true) {
    printf("Task 2: %u\n", (unsigned int)count);

    // This task notifies task1 with its count value
    if (count == 3)
      xTaskNotify(task1_handle, count, eSetValueWithOverwrite);

    count++;

    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

void app_main(void) {
  task1_handle = xTaskCreateStatic(task1, "Task 1", TASK1_STACK_SIZE, NULL, 1,
                                   task1_stack, &task1_tcb);

  task2_handle = xTaskCreateStatic(task2, "Task 2", TASK2_STACK_SIZE, NULL, 1,
                                   task2_stack, &task2_tcb);
}
