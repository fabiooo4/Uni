#include "freertos/FreeRTOS.h"
#include "freertos/idf_additions.h"
#include "freertos/projdefs.h"
#include "freertos/task.h"
#include "portmacro.h"
#include <stdint.h>
#include <stdio.h>

// Task 1
#define TASK1_STACK_SIZE 2048
TaskHandle_t producer_handle;
StackType_t producer_stack[TASK1_STACK_SIZE];
StaticTask_t producer_tcb;

// Task 2
#define TASK2_STACK_SIZE 2048
TaskHandle_t consumer_handle;
StackType_t consumer_stack[TASK1_STACK_SIZE];
StaticTask_t consumer_tcb;

// Queue item
typedef struct QueueItem_t {
  uint32_t id;
  uint32_t value;
} QueueItem_t;

// Queue
#define QUEUE_LEN 10
QueueItem_t queue_items[QUEUE_LEN];
StaticQueue_t queue;
QueueHandle_t queue_handle;

void producer(void *pvParameter) {
  uint32_t current_id = 0;
  uint32_t value = 0;

  while (1) {
    QueueItem_t item = {
        .id = current_id,
        .value = value,
    };

    printf("Produced:\n ID: %u  value: %u\n\n", (unsigned int)item.id,
           (unsigned int)item.value);
    xQueueSend(queue_handle, &item, portMAX_DELAY);

    current_id++;
    value = current_id * QUEUE_LEN;

    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

void consumer(void *pvParameter) {
  while (true) {
    QueueItem_t recieved_item;

    if (xQueueReceive(queue_handle, &recieved_item, portMAX_DELAY)) {
      printf("Consumer recieved:\n ID: %u  value: %u\n\n",
             (unsigned int)recieved_item.id, (unsigned int)recieved_item.value);
    }
  }
}

void app_main(void) {
  queue_handle = xQueueCreateStatic(QUEUE_LEN, sizeof(QueueItem_t),
                                    (uint8_t *)queue_items, &queue);

  producer_handle = xTaskCreateStatic(producer, "Producer", TASK1_STACK_SIZE,
                                      NULL, 1, producer_stack, &producer_tcb);

  consumer_handle = xTaskCreateStatic(consumer, "Consumer", TASK2_STACK_SIZE,
                                      NULL, 1, consumer_stack, &consumer_tcb);
}
