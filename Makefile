SRC ?= .
BLD ?= .
ARCH ?= tachy
TC ?=
QEMU_DIR ?=

CC := $(TC)gcc
LD := $(TC)ld

QEMU := $(QEMU_DIR)qemu-system-$(ARCH)
QEMU_PARAMS := -machine virt -nographic -serial mon:stdio

CXX_FILES := #tacos
ASM_FILES := arch/tachy/simple
OBJ_FILES := $(addprefix $(BLD)/, $(addsuffix .o, $(CXX_FILES) $(ASM_FILES)))

$(BLD)/tacos.elf: $(OBJ_FILES)
	$(LD) -T $(SRC)/arch/$(ARCH)/tacos.ld $^ -o $@

$(BLD)/%.o: $(SRC)/%.cpp
	$(CC) -c $< -o $@

$(BLD)/arch/tachy/%.o: $(SRC)/arch/tachy/%.S
	$(CC) -c $< -o $@

.PHONY: run
run:
	$(QEMU) $(QEMU_PARAMS) -kernel $(BLD)/tacos.elf

.PHONY: clean
clean:
	rm -f $(OBJ_FILES)
	rm -f $(BLD)/tacos.elf
