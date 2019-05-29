SRC ?= .
BLD ?= .
ARCH ?= tachy
TC ?=
QEMU_DIR ?=

CC := $(TC)gcc
LD := $(TC)ld

QEMU := $(QEMU_DIR)qemu-system-$(ARCH)
QEMU_PARAMS := -machine virt -nographic -serial mon:stdio -d in_asm -D qemu.log


DEBUG ?= 0
ifeq ($(DEBUG), 1)
  CFLAGS := -g -O2
else
  CFLAGS := -O3
endif

CFLAGS += -Wall -Werror -I$(SRC)
LDFLAGS := -nostdlib -nolibc

CXX_FILES := tacos
ASM_FILES := arch/tachy/start

OBJ_FILES := $(addprefix $(BLD)/, $(addsuffix .o, $(CXX_FILES) $(ASM_FILES)))

$(BLD)/tacos.elf: $(OBJ_FILES)
	$(LD) $(LDFLAGS) -T $(SRC)/arch/$(ARCH)/tacos.ld $^ -o $@

$(BLD)/%.o: $(SRC)/%.cpp
	$(CC) $(CFLAGS) -c $< -o $@

$(BLD)/arch/$(ARCH)/%.o: $(SRC)/arch/$(ARCH)/%.S
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: run
run:
	$(QEMU) $(QEMU_PARAMS) -kernel $(BLD)/tacos.elf

.PHONY: clean
clean:
	rm -f $(OBJ_FILES)
	rm -f $(BLD)/tacos.elf
