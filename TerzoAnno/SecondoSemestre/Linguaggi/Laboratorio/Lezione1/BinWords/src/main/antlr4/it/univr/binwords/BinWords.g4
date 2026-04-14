grammar BinWords;

main: bin EOF; // Entrypoint
bin: | '0' bin | '1' bin;
