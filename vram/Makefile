# macros
AS = nasm -fbin

# pattern rules

.PHONY: clean test

# generate rules

# default target
test:2nd
		~y-takata/bochs
2nd: 2nd.s
	$(AS) $<

vram: vram.s
	$(AS) $<

clean:
		rm -f *.o *.~ *.out


