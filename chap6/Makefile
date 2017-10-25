# macros
AS = nasm -felf
LD = ld
LDFLAGS = -m elf_i386
OBJS_SORT = 163.o sort.o print_eax.o
OBJS_TEST_SORT = test_sort.o sort.o print_eax.o
OBJS_PRIME = 10primes.o print_eax.o
OBJS_PRINT = 161.o print_eax.o
OBJS_DIC = test_sort_table.o sort_table.o print_eax.o print_mem.o

# pattern rules
%.o: %.s
		$(AS) $<

.PHONY: all clean test 

# generate rules

# default target
all: test_print.out 10primes.out test_sort.out test_sort2.out

sort_table: $(OBJS_DIC)
		$(LD) $(LDFLAGS) $+ -o $@

test_sort.out: $(OBJS_TEST_SORT)
		$(LD) $(LDFLAGS) $+ -o $@

test_sort2.out: $(OBJS_SORT)
		$(LD) $(LDFLAGS) $+ -o $@

10primes.out: $(OBJS_PRIME)
		$(LD) $(LDFLAGS) $+ -o $@

test_print.out: $(OBJS_PRINT)
		$(LD) $(LDFLAGS) $+ -o $@

clean:
		rm -f *.o *.~ *.out

test:all
		./test_print.out | diff - 161.ans
		./10primes.out | diff - 162.ans
		./test_sort.out | diff - test_sort_a
		./test_sort2.out | diff - 163.ans
