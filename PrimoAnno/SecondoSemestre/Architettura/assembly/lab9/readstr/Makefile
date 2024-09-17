EXE=readstr
AS= as --32
LD= ld -m elf_i386
FLAGS=	-gstabs
OBJ=readstr.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

readstr.o: readstr.s
	$(AS) $(FLAGS) -o readstr.o readstr.s

clean:
	rm -f *.o $(EXE) core
