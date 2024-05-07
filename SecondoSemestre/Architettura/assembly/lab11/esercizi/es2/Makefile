AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/es1

bin/es1: obj/main.o obj/printStr.o obj/itoa.o obj/atoi.o
	ld $(LD_FLAGS) obj/main.o obj/printStr.o obj/itoa.o obj/atoi.o -o bin/es1

obj/main.o: src/main.s src/printStr.s
	as $(AS_FLAGS) $(DEBUG) src/main.s -o obj/main.o
obj/printStr.o:
	as $(AS_FLAGS) $(DEBUG) src/printStr.s -o obj/printStr.o
obj/itoa.o:
	as $(AS_FLAGS) $(DEBUG) src/itoa.s -o obj/itoa.o
obj/atoi.o:
	as $(AS_FLAGS) $(DEBUG) src/atoi.s -o obj/atoi.o

clean:
	rm -f obj/*.o bin/es1
