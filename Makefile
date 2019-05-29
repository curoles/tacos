SRC ?= .
BLD ?= .

CC := gcc
LD := ld

QEMU := qemu-system-x86_64

FILES := tacos test
OBJ_FILES := $(addprefix $(BLD)/, $(addsuffix .o, $(FILES)))

$(BLD)/tacos.elf: $(OBJ_FILES)
	$(LD) -T $(SRC)/tacos.ld $^ -o $@

$(BLD)/tacos_test: $(OBJ_FILES)
	$(CC) $^ -o $@

$(BLD)/%.o: $(SRC)/%.cpp
	$(CC) -c $< -o $@

.PHONY: run
run:
	$(QEMU) -kernel $(BLD)/tacos.elf

.PHONY: clean
clean:
	rm $(OBJ_FILES)
	rm $(BLD)/tacos.elf
	rm $(BLD)/tacos_test
