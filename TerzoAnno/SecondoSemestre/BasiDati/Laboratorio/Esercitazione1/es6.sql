alter table Mostra
    rename column prezzo to prezzoIntero;

alter table Mostra
    add column prezzoRidotto integer default 5
    check(prezzoRidotto >= 0);
