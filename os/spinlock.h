/**
 *
 * https://gcc.gnu.org/wiki/Atomic/GCCMM/AtomicSync
 */
#pragma once

namespace os
{

struct Spinlock {
    bool flag;
};

static inline
void lock(os::Spinlock* lock)
{
    while (__atomic_test_and_set(&lock->flag, __ATOMIC_SEQ_CST)) {
        //pause;
    }
}

static inline
void unlock(os::Spinlock* lock) {
    __atomic_clear(&lock->flag, __ATOMIC_SEQ_CST);
}

} // end namespace os
