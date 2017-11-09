# macros
AS = nasm -fbin


# pattern rules

.PHONY: clean test

# generate rules

# default target
vram: vram.s
	$(AS) $<

clean:
		rm -f *.o *.~ *.out


test:
		~y-takata/bochs
