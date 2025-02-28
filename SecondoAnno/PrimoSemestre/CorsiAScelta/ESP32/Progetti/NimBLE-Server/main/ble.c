/*------ Includes ----------------------------------------------------------------------------------------------------*/
#include "ble.h"
#include "esp_event.h"
#include "esp_log.h"
#include "esp_nimble_hci.h"
#include "freertos/FreeRTOS.h"
#include "freertos/event_groups.h"
#include "freertos/task.h"
#include "host/ble_hs.h"
#include "led.h"
#include "nimble/nimble_port.h"
#include "nimble/nimble_port_freertos.h"
#include "nvs_flash.h"
#include "sdkconfig.h"
#include "services/gap/ble_svc_gap.h"
#include "services/gatt/ble_svc_gatt.h"
#include <stdint.h>
#include <stdio.h>

/*------ Defines -----------------------------------------------------------------------------------------------------*/


/*------ Typedef and structures --------------------------------------------------------------------------------------*/


/*------ Static functions prototypes ---------------------------------------------------------------------------------*/
// Write data to ESP32 defined as server
static int
prvucBleDeviceWrite(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg);
// Read data from ESP32 defined as server
static int prvucBleDeviceRead(uint16_t con_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg);
// BLE event handling
static int prvucBleGapEvent(struct ble_gap_event *event, void *arg);

static void prvvBleAppAdvertise(void);

static void prvvBleAppOnSync(void);

static void prvvBleHostTask(void *param);

/*------ Global variables --------------------------------------------------------------------------------------------*/
const char *TAG = "Fabibo BLE Server";
uint8_t     prvucBleAddrType;

// Array of pointers to other service definitions
// UUID - Universal Unique Identifier
static const struct ble_gatt_svc_def gatt_svcs[] = {
    {
     .type = BLE_GATT_SVC_TYPE_PRIMARY,
     .uuid = BLE_UUID16_DECLARE(0x6969), // Define UUID for device type
        .characteristics =
            (struct ble_gatt_chr_def[]){
                {.uuid      = BLE_UUID16_DECLARE(0xDEAD), // Define UUID for reading
                 .flags     = BLE_GATT_CHR_F_READ,
                 .access_cb = prvucBleDeviceRead},
                {.uuid      = BLE_UUID16_DECLARE(0xDEAF), // Define UUID for writing
                 .flags     = BLE_GATT_CHR_F_WRITE,
                 .access_cb = prvucBleDeviceWrite},
                {0},
            }, },
    {0},
};

/*------ Static functions --------------------------------------------------------------------------------------------*/
static int prvucBleDeviceWrite(uint16_t conn_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    uint8_t  led      = ctxt->om->om_data[0];
    uint16_t interval = ctxt->om->om_data[1] << 8 | ctxt->om->om_data[2];

    printf("Led: %d, Interval: %d\n", led, interval);


    /*     // Write data from the client to the LEDs
    printf("Data from the client: %.*s\n", ctxt->om->om_len, ctxt->om->om_data);

    // The data from the client is in the form of a string of 3 characters, each of which is a number from 0 to 1
    // The first character is the state of the yellow LED, the second character is the state of the green LED, and the third character is the state of the red LED

    // Yellow LED
    if (ctxt->om->om_data[0] == '0')
    {
        vLedSet(LED_YELLOW, false);
    }
    else if (ctxt->om->om_data[0] == '1')
    {
        vLedSet(LED_YELLOW, true);
    }

    // Green LED
    if (ctxt->om->om_data[1] == '0')
    {
        vLedSet(LED_GREEN, false);
    }
    else if (ctxt->om->om_data[1] == '1')
    {
        vLedSet(LED_GREEN, true);
    }

    // Red LED
    if (ctxt->om->om_data[2] == '0')
    {
        vLedSet(LED_RED, false);
    }
    else if (ctxt->om->om_data[2] == '1')
    {
        vLedSet(LED_RED, true);
    }
    return 0; */
}

static int prvucBleDeviceRead(uint16_t con_handle, uint16_t attr_handle, struct ble_gatt_access_ctxt *ctxt, void *arg)
{
    // Write state of LEDs to the client
    bool bYellowLedState = bLedGet(LED_YELLOW);
    bool bGreenLedState  = bLedGet(LED_GREEN);
    bool bRedLedState    = bLedGet(LED_RED);
    char cLedState[4]    = {0};

    sprintf(cLedState, "%d%d%d", bYellowLedState, bGreenLedState, bRedLedState);
    os_mbuf_append(ctxt->om, cLedState, strlen(cLedState));
    return 0;
}

static int prvucBleGapEvent(struct ble_gap_event *event, void *arg)
{
    switch (event->type)
    {
        // Advertise if connected
        case BLE_GAP_EVENT_CONNECT:
            ESP_LOGI("GAP", "BLE GAP EVENT CONNECT %s", event->connect.status == 0 ? "OK!" : "FAILED!");
            if (event->connect.status != 0)
            {
                prvvBleAppAdvertise();
            }
            break;
        // Advertise again after completion of the event
        case BLE_GAP_EVENT_ADV_COMPLETE:
            ESP_LOGI("GAP", "BLE GAP EVENT");
            prvvBleAppAdvertise();
            break;
        case BLE_GAP_EVENT_DISCONNECT:
            ESP_LOGI("GAP", "BLE GAP EVENT DISCONNECT");
            prvvBleAppAdvertise();
            break;
        default:
            break;
    }
    return 0;
}

// Define the BLE connection
static void prvvBleAppAdvertise(void)
{
    // GAP - device name definition
    struct ble_hs_adv_fields fields;
    const char              *device_name;
    memset(&fields, 0, sizeof(fields));
    device_name             = ble_svc_gap_device_name(); // Read the BLE device name
    fields.name             = (uint8_t *) device_name;
    fields.name_len         = strlen(device_name);
    fields.name_is_complete = 1;
    ble_gap_adv_set_fields(&fields);

    // GAP - device connectivity definition
    struct ble_gap_adv_params adv_params;
    memset(&adv_params, 0, sizeof(adv_params));
    adv_params.conn_mode = BLE_GAP_CONN_MODE_UND; // connectable or non-connectable
    adv_params.disc_mode = BLE_GAP_DISC_MODE_GEN; // discoverable or non-discoverable
    ble_gap_adv_start(prvucBleAddrType, NULL, BLE_HS_FOREVER, &adv_params, prvucBleGapEvent, NULL);
}

// The application
static void prvvBleAppOnSync(void)
{
    ble_hs_id_infer_auto(0, &prvucBleAddrType); // Determines the best address type automatically
    prvvBleAppAdvertise();                      // Define the BLE connection
}

// The infinite task
static void prvvBleHostTask(void *param)
{
    nimble_port_run(); // This function will return only when nimble_port_stop() is executed
}

/*------ Public functions --------------------------------------------------------------------------------------------*/
void vBleInit()
{
    // Initialize NVS flash using
    nvs_flash_init();

    // Initialize the host stack
    nimble_port_init();
    // Initialize NimBLE configuration - server name
    ble_svc_gap_device_name_set(TAG);
    // Initialize NimBLE configuration - gap service
    ble_svc_gap_init();
    // Initialize NimBLE configuration - gatt service
    ble_svc_gatt_init();
    // Initialize NimBLE configuration - config gatt services
    ble_gatts_count_cfg(gatt_svcs);
    // Initialize NimBLE configuration - queues gatt services.
    ble_gatts_add_svcs(gatt_svcs);
    // Initialize application
    ble_hs_cfg.sync_cb = prvvBleAppOnSync;
    // Run the thread
    nimble_port_freertos_init(prvvBleHostTask);
}

/*------ END OF FILE -------------------------------------------------------------------------------------------------*/
