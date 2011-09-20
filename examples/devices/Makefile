all: crunch vbd fat

clean:
	$(RM) vbd.img fat.img crunch.img filesystem_static.ml
	mir-build -clean

.PHONY: all clean

# targets
crunch: crunch.mir kv_ro.ml crunch.img
	mir-build unix-direct/crunch.bin

vbd: vbd.mir kv_ro.ml vbd.img
	mir-build unix-direct/vbd.bin

fat: fat.ml fat.img
	mir-build unix-direct/fat.bin

# disk images
vbd.img: rootdir
	mir-fs-create rootdir vbd.img

fat.img: rootdir
	mir-fat-create rootdir fat.img

crunch.img: rootdir filesystem_static.ml
	touch crunch.img
filesystem_static.ml: rootdir
	mir-crunch -name "crunch.img" rootdir > filesystem_static.ml

