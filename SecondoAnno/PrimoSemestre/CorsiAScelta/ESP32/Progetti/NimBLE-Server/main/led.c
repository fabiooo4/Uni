/*------ Includes ----------------------------------------------------------------------------------------------------*/
#include "led.h"
#include "driver/gpio.h"
#include "freertos/FreeRTOS.h"
#include "freertos/idf_additions.h"
#include "freertos/projdefs.h"
#include "freertos/task.h"
#include "portmacro.h"
#include <stdint.h>

/*------ Defines -----------------------------------------------------------------------------------------------------*/


/*------ Typedef and structures --------------------------------------------------------------------------------------*/
typedef struct led_blink_t
{
    uint8_t  led;
    uint16_t interval;
} led_blink_t;

/*------ Global variables --------------------------------------------------------------------------------------------*/
static bool prvbYellowLedEnabled = false;
static bool prvbGreenLedEnabled  = false;
static bool prvbRedLedEnabled    = false;

static QueueHandle_t xLedQueue;

/*------ Static functions prototypes ---------------------------------------------------------------------------------*/
static void prvvLedTask(void *pvParameters);

/*------ Static functions --------------------------------------------------------------------------------------------*/
static void prvvLedTask(void *pvParameters)
{
    led_blink_t current_blink = {.led = LED_RED, .interval = 1000};
    bool        led_state     = false;
    while (1)
    {
        led_blink_t received;
        if (pdTRUE == xQueueReceive(xLedQueue, &received, 0))
        {
            current_blink = received;
        }

        printf("Led: %d, State: %d\n", current_blink.led, led_state);

        vTaskDelay(current_blink.interval / portTICK_PERIOD_MS);
        led_state = !led_state;
    }


    /* // Current LED to be checked
    static Led_t eLed = LED_YELLOW;

    while (1)
    {
        // Toggle LED state if it is set
        switch (eLed)
        {
            case LED_YELLOW:
                gpio_set_level(LED_YELLOW, prvbYellowLedEnabled);
                break;
            case LED_GREEN:
                gpio_set_level(LED_GREEN, prvbGreenLedEnabled);
                break;
            case LED_RED:
                gpio_set_level(LED_RED, prvbRedLedEnabled);
                break;
        }

        // Set next LED to be checked
        if (eLed == LED_RED)
        {
            eLed = LED_YELLOW;
        }
        else
        {
            eLed++;
        }

        // 100ms delay
        vTaskDelay(100 / portTICK_PERIOD_MS);
    } */
}

/*------ Public functions --------------------------------------------------------------------------------------------*/
void vLedInit()
{
    gpio_set_direction(LED_RED, GPIO_MODE_OUTPUT);
    gpio_set_direction(LED_GREEN, GPIO_MODE_OUTPUT);
    gpio_set_direction(LED_YELLOW, GPIO_MODE_OUTPUT);

    gpio_set_level(LED_RED, 0);
    gpio_set_level(LED_GREEN, 0);
    gpio_set_level(LED_YELLOW, 0);

    xLedQueue = xQueueCreate(10, sizeof(led_blink_t));
    xTaskCreate(prvvLedTask, "prvvLedTask", 2048, NULL, 5, NULL);
}

bool bLedGet(Led_t eLed)
{
    bool bState = false;

    switch (eLed)
    {
        case LED_RED:
            bState = prvbRedLedEnabled;
            break;
        case LED_GREEN:
            bState = prvbGreenLedEnabled;
            break;
        case LED_YELLOW:
            bState = prvbYellowLedEnabled;
            break;
        default:
            break;
    }

    return bState;
}

void vLedSet(Led_t eLed, bool bState)
{
    switch (eLed)
    {
        case LED_RED:
            prvbRedLedEnabled = bState;
            break;
        case LED_GREEN:
            prvbGreenLedEnabled = bState;
            break;
        case LED_YELLOW:
            prvbYellowLedEnabled = bState;
            break;
        default:
            break;
    }
}

void vLedSetBlink(Led_t eLed, uint16_t interval)
{
    struct led_blink_t xLedBlink = {.led = eLed, .interval = 1000};

    xQueueSend(xLedQueue, &xLedBlink, portMAX_DELAY);
}


/*------ END OF FILE -------------------------------------------------------------------------------------------------*/
