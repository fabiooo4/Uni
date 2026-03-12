-- Esercizio 1
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

-- Esercizio 2
insert into Museo
values ('Arena', 'Verona', 'piazza Bra', '045 8003204', 'martedì', 20),
       ('CastelVecchio', 'Verona', 'Corso Castelvecchio', '045 594734', 'lunedì', 15);

-- Esercizio 3
insert into Opera
values ('L''Abbraccio', 'Domenico', 'Foschini', 'Arena', 'Verona', 'Rinascimento', 1500),
       ('Il Bacio', 'Giuseppe', 'Verdi', 'CastelVecchio', 'Verona', 'Barocco', 1600),
       ('La Danza', 'Leonardo', 'Da Vinci', 'Arena', 'Verona', 'Rinascimento', 1505);

insert into Mostra
values ('Rinascimento a Verona', '2026-01-01', '2026-06-30', 'Arena', 'Verona', 12),
       ('Barocco a Verona', '2026-02-01', '2026-07-31', 'CastelVecchio', 'Verona', 10),
       ('Arte Moderna a Verona', '2026-03-01', '2026-08-31', 'Arena', 'Verona', 15);

/* -- Esercizio 4
insert into Museo
values (
        'Violato',
        'Vincolo',
        'Catania',
        'nonnumero',
        'nongiorno',
        -5
    ),
    (
        'Violato',
        'Vincolo',
        'Catania',
        '333 3333333',
        'nongiorno',
        -5
    ),
    (
        'Violato',
        'Vincolo',
        'Catania',
        '333 3333333',
        'domenica',
        -5
    ); */

-- Esercizio 5
alter table Museo
    add column sitoInternet char varying(100);

update Museo
    set sitoInternet = 'www.arena.it'
    where nome = 'Arena' and città = 'Verona';

update Museo
    set sitoInternet = 'www.castelvecchio.it'
    where nome = 'CastelVecchio' and città = 'Verona';

-- Esercizio 6
alter table Mostra
    rename column prezzo to prezzoIntero;

alter table Mostra
    add column prezzoRidotto integer default 5
    check(prezzoRidotto >= 0);

-- Esercizio 7
update Museo
    set prezzo = prezzo + 1;

-- Esercizio 8
update Mostra
    set prezzoRidotto = prezzoRidotto + 1
    where prezzoIntero < 15;

-- Esercizio 9
insert into Orario
values (1, 'Arena', 'Verona', '2026-01-01', '09:00 CET', '19:00 CET'),
       (2, 'CastelVecchio', 'Verona', '2026-01-02', '09:00 CET', '19:00 CET'),
       (3, 'Arena', 'Verona', '2026-01-03', '09:00 CET', '19:00 CET');


select * from Museo;
select * from Mostra;

update Museo
  set nome = 'Arena di Verona'
  where nome = 'Arena';

select * from Museo;
select * from Mostra;
select * from Opera;
select * from Orario;

delete from Museo
  where nome = 'Arena di Verona';

select * from Museo;
select * from Mostra;
select * from Opera;
select * from Orario;
