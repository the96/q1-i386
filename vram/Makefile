# macros
AS = nasm -fbin

# pattern rules

.PHONY: test

# generate rules

# default target
vram: vram.s
	$(AS) $<

test:vram
		~y-takata/bochs
	

