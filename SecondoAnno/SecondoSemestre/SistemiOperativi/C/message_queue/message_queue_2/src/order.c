#include <stdio.h>
#include "order.h"

void printOrder(struct order *order) {
    printf("==========================================\n");
    printf("New order:\n");
    printf("\tcode: %d\n", order->code);
    printf("\tdescription: %s\n", order->description);
    printf("\tquantity: %d\n", order->quantity);
    printf("\temail: %s\n", order->email);
    printf("==========================================\n");
}
