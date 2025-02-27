#include "driver/gpio.h"
#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#define LED 2

void app_main(void) {
  const char *tag = "blink";
  ESP_LOGI(tag, "Starting blink!\n");

  const uint32_t hi = 1, lo = 0;
  const TickType_t duration = 500 / portTICK_PERIOD_MS;
  gpio_reset_pin(LED);
  gpio_set_direction(LED, GPIO_MODE_OUTPUT);

  while (true) {
    gpio_set_level(LED, hi);
    vTaskDelay(duration);
    gpio_set_level(LED, lo);
    vTaskDelay(duration);
  }
}
