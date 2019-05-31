QEMU_PARAMS := -machine virt -nographic -serial mon:stdio -d in_asm -D qemu.log -kernel $(BLD)/tacos.elf

#ASM_FILES +=

CXX_FILES += $(addprefix arch/tachy/, init)
