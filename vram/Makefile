# macros
AS = nasm -fbin

# pattern rules

.PHONY: test

# generate rules

# default target
test:vram
		~y-takata/bochs
		
vram: vram.s
	$(AS) $<


