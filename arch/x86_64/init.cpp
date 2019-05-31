

extern "C"
void x86_init()
{
    char s[] = {'I', 'n', 'i', 't', ' ', 'x', '8', '6', '.', '.', '.', '\r', '\n'};
    ///*static*/ const char s[21] = "Initializing x86...\n";
    for (unsigned int i = 0; i < sizeof(s); ++i) {
        __asm__ (
            "int $0x10" : : "a" ((0x0e << 8) | s[i])
        );
    }

}
