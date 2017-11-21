# macros
AS = nasm -felf
LD = ld
LDFLAGS = -m elf_i386
CC = gcc
CFLAGS = -m32 -W -Wall
OBJS_PRIME = isPrime.o test_prime.o print_eax.o

# pattern rules
%.o: %.s
		$(AS) $<
%.o: $.c
		$(CC) $<

.PHONY: clean test

# generate rules

# default target
test_prime: $(OBJS_PRIME)
		$(CC) $(CFLAGS) -o $@ $+
		
clean:
		rm -f *.o *.~ *.out

test:test_prime
		./test_prime
