#ifndef _ORDER_HH
#define _ORDER_HH

#include <stdlib.h>

// the structure defines a order sent by a
// client to a supplier.
struct order {
    long mtype;
    unsigned int code;
    char description [100];
    unsigned int quantity;
    char email [100];
};

// The method printOrder prints on standard output
// all the fields of the structure order
void printOrder(struct order *order);

#endif
