#include <cstdint>

#include "hw/tachy/qemu_virt/defines.h"

int test()
{
    return 0;
}

extern "C"
int _startOS(void)
{
    volatile uint64_t* uart = reinterpret_cast<uint64_t*>(UART_ADDR);
    *(uart) = 0x21;
    *(uart) = 0xa;

    return 0;
}
