create domain giornosettimana as varchar(10)
    check (value in ('lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica'));

create table Museo (
    nome char varying(30) default 'MuseoVeronese',
    città char varying(20) default 'Verona',
    indirizzo char varying(50),
    numeroTelefono char varying(20),
    giornoChiusura giornosettimana not null,
    prezzo decimal not null default 10,

    check(numeroTelefono ~ '^[+]?[0-9 ]+$'),
    check(prezzo >= 0),

    primary key (nome, città)
);

create table Mostra (
    titolo char varying(30),
    inizio date,
    fine date not null,
    museo char varying(30),
    città char varying(20),
    prezzo decimal,

    check(fine > inizio),
    check(prezzo >= 0),

    primary key (titolo, inizio),

    foreign key (museo, città)
        references Museo (nome, città)
        on update cascade
        on delete set null
);

create table Opera (
    nome char varying(30),
    cognomeAutore char varying(20),
    nomeAutore char varying(20),
    museo char varying(30),
    città char varying(20),
    epoca char varying(30),
    anno integer,

    primary key (nome, cognomeAutore, nomeAutore),

    foreign key (museo, città)
        references Museo (nome, città)
        on update cascade
        on delete set null
);

create table Orario (
    progressivo integer primary key,
    museo char varying(30) not null,
    città char varying(20) not null,
    giorno giornosettimana not null,
    orarioApertura time with time zone default '09:00 CET',
    orarioChiusura time with time zone default '19:00 CET',

    check(orarioChiusura > orarioApertura),

    foreign key (museo, città)
        references Museo (nome, città)
        on update cascade
        on delete cascade
);
