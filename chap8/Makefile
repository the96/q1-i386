# macros
AS = nasm -felf
LD = ld
LDFLAGS = -m elf_i386
OBJS_PRINT = print_eax_hex.o test_print_hex.o
OBJS_MUL = mul_eax_edx.o test_mul_eax.o print_eax.o

# pattern rules
%.o: %.s
		$(AS) $<

.PHONY: all clean test

# generate rules

# default target
all: test_print.out test_mul.out

test_print: $(OBJS_PRINT)
		$(LD) $(LDFLAGS) $+ -o $@

test_mul: $(OBJS_MUL)
		$(LD) $(LDFLAGS) $+ -o $@
		
clean:
		rm -f *.o *.~ *.out

test:all
		./test_print
		./test_mul
