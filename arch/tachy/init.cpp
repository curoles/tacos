#include <cstdint>

#include "hw/tachy/qemu_virt/defines.h"

__attribute__ ((noinline))
void putc(uint8_t c)
{
    volatile uint64_t* uart = reinterpret_cast<uint64_t*>(UART_ADDR);

    *(uart) = c;
}

extern "C"
void tachy_init()
{
    char s[] = {'I', 'n', 'i', 't', ' ', 't', 'a', 'c', 'h', 'y', '.', '.', '.', '\r', '\n'};
    ///*static*/ const char s[21] = "Initializing tachy...\n";
    for (unsigned int i = 0; i < sizeof(s); ++i) {
        putc(s[i]);
    }

}
