/*------ Includes ----------------------------------------------------------------------------------------------------*/
#include "ble.h"
#include "esp_event.h"
#include "esp_log.h"
#include "esp_nimble_hci.h"
#include "freertos/FreeRTOS.h"
#include "freertos/event_groups.h"
#include "freertos/task.h"
#include "host/ble_hs.h"
#include "nimble/nimble_port.h"
#include "nimble/nimble_port_freertos.h"
#include "nvs_flash.h"
#include "sdkconfig.h"
#include "services/gap/ble_svc_gap.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/*------ Defines -----------------------------------------------------------------------------------------------------*/


/*------ Typedef and structures --------------------------------------------------------------------------------------*/


/*------ Global variables --------------------------------------------------------------------------------------------*/
static const char       *TAG                          = "NimBLE Client";
static const char       *Target                       = "NimBLE Server Coati";
static const ble_uuid_t *prvxBleReadChrUuid           = BLE_UUID16_DECLARE(0xDEAD);
static const ble_uuid_t *prvxBleWriteChrUuid          = BLE_UUID16_DECLARE(0xDEAF);

static const ble_uuid_t *prvxBleServiceUuid           = BLE_UUID16_DECLARE(0x6969);

static uint16_t                   prvusBleConnHandle  = BLE_HS_CONN_HANDLE_NONE;
static uint16_t                   prvusBleReadHandle  = 0;
static uint16_t                   prvusBleWriteHandle = 0;
static uint8_t                    prvucBleAddrType;
static bool                       prvbBleServiceDiscoveryInProgress = false;
static struct ble_gap_conn_params prvxBleConnParams;
static struct ble_hs_adv_fields   prvxBleConnFields;

static char prvucLedPattern[] = "000";

static uint8_t led_time[3];

/*------ Static functions prototypes ---------------------------------------------------------------------------------*/


/*------ Static functions --------------------------------------------------------------------------------------------*/
static int
prvvBleOnRead(uint16_t conn_handle, const struct ble_gatt_error *error, struct ble_gatt_attr *attr, void *arg)
{
    ESP_LOGI("GAP", "READ CALLBACK\n");
    if (error->status == 0)
    {
        uint16_t length = attr->om->om_len;
        uint8_t  data[length];

        ble_hs_mbuf_to_flat(attr->om, data, length, NULL);
        for (int i = 0; i < length; i++)
        {
            printf("%02X", data[i]);
        }
        printf("\n");
    }
    else
    {
        printf("Read characteristic error: %d\n", error->status);
    }
    return 0;
}

static int
prvvBleOnWrite(uint16_t conn_handle, const struct ble_gatt_error *error, struct ble_gatt_attr *attr, void *arg)
{
    ESP_LOGI("GAP", "WRITE CALLBACK\n");
    if (error->status == 0)
    {
        printf("Write characteristic success!\n");
    }
    else
    {
        printf("Write characteristic error: %d\n", error->status);
    }
    return 0;
}

static void prvvBleWritePatternTask(void *pvParameter)
{
    uint8_t  led      = 1;
    uint16_t interval = 0;
    while (1)
    {
        vTaskDelay((interval * 2) / portTICK_PERIOD_MS);
        /* int rc =
            ble_gattc_write_flat(prvusBleConnHandle, prvusBleWriteHandle, prvucLedPattern, 3, prvvBleOnWrite, NULL); */

        if (led == 1)
        {
            interval = 1000;
        }
        else if (led == 2)
        {
            interval = 2000;
        }
        else
        {
            interval = 3000;
        }

        led_time[0] = led;
        led_time[1] = interval >> 8;
        led_time[2] = interval & 0xFF;

        led++;

        if (led == 4)
        {
            led = 1;
        }

        int rc = ble_gattc_write_flat(
            prvusBleConnHandle,
            prvusBleWriteHandle,
            led_time,
            sizeof(uint8_t) * 3,
            prvvBleOnWrite,
            NULL);
        if (rc != 0)
        {
            printf("Failed to write characteristic (error: %d)\n", rc);
        }
    }
}

static void prvvBleLedPatternSwitchTask(void *pvParameter)
{
    static uint8_t ucCurrentLedPattern = 0;
    // Cycle between different LED patterns every 1 seconds
    while (1)
    {
        vTaskDelay(pdMS_TO_TICKS(1000));
        switch (ucCurrentLedPattern)
        {
            case 0:
                strncpy(prvucLedPattern, "000", sizeof("000"));
                break;
            case 1:
                strncpy(prvucLedPattern, "100", sizeof("100"));
                break;
            case 2:
                strncpy(prvucLedPattern, "010", sizeof("010"));
                break;
            case 3:
                strncpy(prvucLedPattern, "001", sizeof("001"));
                break;
            case 4:
                strncpy(prvucLedPattern, "110", sizeof("110"));
                break;
            case 5:
                strncpy(prvucLedPattern, "101", sizeof("101"));
                break;
            case 6:
                strncpy(prvucLedPattern, "011", sizeof("011"));
                break;
            case 7:
                strncpy(prvucLedPattern, "111", sizeof("111"));
                break;
            default:
                strncpy(prvucLedPattern, "000", sizeof("000"));
                break;
        }
        if (ucCurrentLedPattern < 7)
        {
            ucCurrentLedPattern++;
        }
        else
        {
            ucCurrentLedPattern = 0;
        }
    }
}

// Characteristic discovery callback
static int prvvBleOnCharacteristicDiscovery(
    uint16_t                     conn_handle,
    const struct ble_gatt_error *error,
    const struct ble_gatt_chr   *chr,
    void                        *arg)
{
    ESP_LOGI("GAP", "CHARACTERISTIC DISCOVERY CALLBACK\n");
    char buf[BLE_UUID_STR_LEN] = "";
    if (chr)
    {
        ble_uuid_to_str(&chr->uuid.u, buf);
    }

    switch (error->status)
    {
        case 0:
            ESP_LOGI(
                "GAP",
                "prvvBleOnCharacteristicDiscovery: conn_handle=%d uuid=%s error_status=%d",
                prvusBleConnHandle,
                buf,
                error->status);
            // If the discovered characteristic is the one we are looking for ("NimBLE Read"), read its value
            if (ble_uuid_cmp((const ble_uuid_t *) &chr->uuid, prvxBleReadChrUuid) == 0)
            {
                printf("Found NOICE read characteristic, reading...\n");

                prvusBleReadHandle = chr->val_handle;

                int rc             = ble_gattc_read(prvusBleConnHandle, chr->val_handle, prvvBleOnRead, NULL);
                if (rc != 0)
                {
                    printf("Failed to read characteristic (error: %d)\n", rc);
                }
            }
            // If the discovered characteristic is the one we are looking for ("NimBLE Write"), write to it
            else if (ble_uuid_cmp((const ble_uuid_t *) &chr->uuid, prvxBleWriteChrUuid) == 0)
            {
                printf("Found NOICE write characteristic, writing 000 to turn OFF all the LEDs...\n");

                prvusBleWriteHandle = chr->val_handle;


                /* int rc =
                    ble_gattc_write_flat(prvusBleConnHandle, chr->val_handle, prvucLedPattern, 3, prvvBleOnWrite, NULL);

                if (rc != 0)
                {
                    printf("Failed to write characteristic (error: %d)\n", rc);
                } */
            }
            break;

        case BLE_HS_EDONE:
            ESP_LOGI("GAP", "prvvBleOnCharacteristicDiscovery: characteristic discovery complete");
            // Start the LED pattern switch task
            // xTaskCreate(prvvBleLedPatternSwitchTask, "LED Pattern Switch Task", 2048, NULL, 5, NULL);
            // Start the LED pattern write task
            xTaskCreate(prvvBleWritePatternTask, "LED Pattern Write Task", 2048, NULL, 5, NULL);
            break;

        default:
            ESP_LOGE(
                "GAP",
                "prvvBleOnCharacteristicDiscovery: conn_handle=%d uuid=%s error_status=%d",
                prvusBleConnHandle,
                buf,
                error->status);
            break;
    }
    return 0;
}

// Service discovery callback
static int prvvBleOnServiceDiscovery(
    uint16_t                     conn_handle,
    const struct ble_gatt_error *error,
    const struct ble_gatt_svc   *service,
    void                        *arg)
{
    ESP_LOGI("GAP", "SERVICE DISCOVERY CALLBACK\n");
    /*     if (error == NULL)
    {
        if (service != NULL)
        {
            int rc = ble_gattc_disc_all_chrs(
                conn_handle,
                service->start_handle,
                service->end_handle,
                prvvBleOnCharacteristicDiscovery,
                NULL);
            if (rc != 0)
            {
                printf("Failed to discover characteristics for service (error: %d)\n", rc);
            }
            else
            {
                printf("Discovered a service!\n");
                ble_gap_disc_cancel();
            }
        }
    }
    else
    {
        printf("Service discovery error: %d\n", error->status);
    }
    prvbBleServiceDiscoveryInProgress = false; */

    char buf[BLE_UUID_STR_LEN] = "";
    if (service)
    {
        ble_uuid_to_str(&service->uuid.u, buf);
    }

    switch (error->status)
    {
        case 0:
            ESP_LOGI(
                "GAP",
                "prvvBleOnServiceDiscovery: conn_handle=%d uuid=%s error_status=%d",
                prvusBleConnHandle,
                buf,
                error->status);
            // If the discovered service is the one we are looking for ("NimBLE Service"), discover its characteristics
            if (ble_uuid_cmp((const ble_uuid_t *) &service->uuid, prvxBleServiceUuid) == 0)
            {
                printf("Found NOICE service, discovering characteristics...\n");
                int rc = ble_gattc_disc_all_chrs(
                    prvusBleConnHandle,
                    service->start_handle,
                    service->end_handle,
                    prvvBleOnCharacteristicDiscovery,
                    NULL);
                if (rc != 0)
                {
                    printf("Failed to discover characteristics for service (error: %d)\n", rc);
                }
                else
                {
                    ble_gap_disc_cancel();
                }
            }
            break;

        case BLE_HS_EDONE:
            ESP_LOGI("GAP", "prvvBleOnServiceDiscovery: service discovery complete");
            prvbBleServiceDiscoveryInProgress = false;
            break;

        default:
            ESP_LOGE(
                "GAP",
                "prvvBleOnServiceDiscovery: conn_handle=%d uuid=%s error_status=%d",
                prvusBleConnHandle,
                buf,
                error->status);
            prvbBleServiceDiscoveryInProgress = false;
            break;
    }
    return error->status;
}

// BLE connection event handling callback
static int prvvBleGapConnect(struct ble_gap_event *event, void *arg)
{
    int rc = 0;
    switch (event->type)
    {
        case BLE_GAP_EVENT_CONNECT:
            ESP_LOGI("GAP", "GAP EVENT CONNECTED");
            prvusBleConnHandle = event->connect.conn_handle;
            printf("Connected with %.*s\n", prvxBleConnFields.name_len, prvxBleConnFields.name);

            vTaskDelay(pdMS_TO_TICKS(1000));

            if (!prvbBleServiceDiscoveryInProgress)
            {
                prvbBleServiceDiscoveryInProgress = true;
                rc = ble_gattc_disc_all_svcs(prvusBleConnHandle, prvvBleOnServiceDiscovery, NULL);
                if (rc != 0)
                {
                    printf("Failed to initiate service discovery (error: %d)\n", rc);
                    prvbBleServiceDiscoveryInProgress = false;
                }
            }
            else
            {
                printf("Service discovery already in progress, skipping.\n");
            }
            break;
        case BLE_GAP_EVENT_DISCONNECT:
            ESP_LOGI("GAP", "GAP EVENT DISCONNECTED");
            prvusBleConnHandle                = BLE_HS_CONN_HANDLE_NONE;
            prvbBleServiceDiscoveryInProgress = false;
            break;
        default:
            break;
    }
    return 0;
}

static int prvucBleGapEvent(struct ble_gap_event *event, void *arg)
{
    memset(&prvxBleConnParams, 0, sizeof(prvxBleConnParams));
    int rc = 0;

    switch (event->type)
    {
        // NimBLE event discovery
        case BLE_GAP_EVENT_DISC:
            ESP_LOGI("GAP", "GAP EVENT DISCOVERY");

            ble_hs_adv_parse_fields(&prvxBleConnFields, event->disc.data, event->disc.length_data);
            if (prvxBleConnFields.name_len > 0)
            {
                printf("Name: %.*s\n", prvxBleConnFields.name_len, prvxBleConnFields.name);
            }

            // If the discovered device is the one we are looking for ("NimBLE Server"), connect to it
            if (prvxBleConnFields.name_len == strlen(Target) &&
                memcmp(prvxBleConnFields.name, Target, strlen(Target)) == 0)
            {
                printf("Found NimBLE Server, connecting...\n");
                ble_gap_disc_cancel();

                // Setting up connection parameters
                prvxBleConnParams.scan_itvl           = BLE_GAP_SCAN_FAST_INTERVAL_MAX;
                prvxBleConnParams.scan_window         = BLE_GAP_SCAN_FAST_WINDOW;
                prvxBleConnParams.itvl_min            = BLE_GAP_INITIAL_CONN_ITVL_MIN;
                prvxBleConnParams.itvl_max            = BLE_GAP_INITIAL_CONN_ITVL_MAX;
                prvxBleConnParams.latency             = BLE_GAP_INITIAL_CONN_LATENCY;
                prvxBleConnParams.supervision_timeout = BLE_GAP_INITIAL_SUPERVISION_TIMEOUT;
                prvxBleConnParams.min_ce_len          = BLE_GAP_INITIAL_CONN_MIN_CE_LEN;
                prvxBleConnParams.max_ce_len          = BLE_GAP_INITIAL_CONN_MAX_CE_LEN;

                // Try to perform the connection
                rc                                    = ble_gap_connect(
                    BLE_OWN_ADDR_PUBLIC,
                    &event->disc.addr,
                    BLE_HS_FOREVER,
                    &prvxBleConnParams,
                    prvvBleGapConnect,
                    NULL);
                vTaskDelay(pdMS_TO_TICKS(400));
                if (rc != 0)
                {
                    printf("Failed to initiate connection (error: %d)\n", rc);
                }
            }

            break;
        default:
            break;
    }
    return 0;
}

// BLE scanning
static void prvvBleAppDiscover(void)
{
    printf("Start scanning ...\n");

    struct ble_gap_disc_params disc_params;
    disc_params.filter_duplicates = 1;
    disc_params.passive           = 0;
    disc_params.itvl              = 0;
    disc_params.window            = 0;
    disc_params.filter_policy     = 0;
    disc_params.limited           = 0;

    ble_gap_disc(prvucBleAddrType, BLE_HS_FOREVER, &disc_params, prvucBleGapEvent, NULL);
}

// The application
static void prvvBleAppOnSync(void)
{
    ble_hs_id_infer_auto(0, &prvucBleAddrType); // Determines the best address type automatically
    prvvBleAppDiscover();                       // Start scanning
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
    // Initialize application
    ble_hs_cfg.sync_cb = prvvBleAppOnSync;
    // Run the thread
    nimble_port_freertos_init(prvvBleHostTask);
}

/*------ END OF FILE -------------------------------------------------------------------------------------------------*/
