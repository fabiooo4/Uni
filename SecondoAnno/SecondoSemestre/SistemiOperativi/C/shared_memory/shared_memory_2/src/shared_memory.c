#include <sys/shm.h>
#include <sys/stat.h>

#include "errExit.h"
#include "shared_memory.h"

 int alloc_shared_memory(key_t shmKey, size_t size) {
    // get, or create, a shared memory segment
    // ...

    return //...
}

void *get_shared_memory(int shmid, int shmflg) {
    // attach the shared memory
    // ...

    return //...
}

void free_shared_memory(void *ptr_sh) {
    // detach the shared memory segments
    // ...
}

void remove_shared_memory(int shmid) {
    // delete the shared memory segment
    // ...
}
