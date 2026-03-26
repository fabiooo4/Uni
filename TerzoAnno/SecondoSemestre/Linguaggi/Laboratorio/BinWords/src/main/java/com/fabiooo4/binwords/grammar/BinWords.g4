grammar BinWords;

main: bin EOF; // Entrypoint
bin: | '0' | '1' bin;
