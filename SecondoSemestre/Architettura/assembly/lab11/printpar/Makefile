AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/printpar

bin/printpar: obj/printpar.o 
	ld $(LD_FLAGS)  obj/printpar.o -o bin/printpar

obj/printpar.o: src/printpar.s
	as $(AS_FLAGS) $(DEBUG) src/printpar.s -o obj/printpar.o


clean:
	rm -f obj/*.o bin/printpar