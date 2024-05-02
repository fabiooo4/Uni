AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/readfile

bin/readfile: obj/readfile.o 
	ld $(LD_FLAGS)  obj/readfile.o -o bin/readfile

obj/readfile.o: src/readfile.s
	as $(AS_FLAGS) $(DEBUG) src/readfile.s -o obj/readfile.o


clean:
	rm -f obj/*.o bin/readfile
