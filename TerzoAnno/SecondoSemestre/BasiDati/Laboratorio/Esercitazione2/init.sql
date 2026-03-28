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
values (1, 'Arena', 'Verona', 'lunedì', '13:00 CET', '19:00 CET'),
       (2, 'CastelVecchio', 'Verona', 'venerdì', '09:00 CET', '19:00 CET'),
       (3, 'Arena', 'Verona', 'mercoledì', '09:00 CET', '19:00 CET');


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

insert into Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo, sitoInternet)
values
('Uffizi', 'Firenze', 'Piazzale degli Uffizi 6', '055 2388651', 'lunedì', 25, 'www.uffizi.it'),
('Musei Vaticani', 'Roma', 'Viale Vaticano', '06 69884676', 'domenica', 17, 'www.museivaticani.va'),
('Egizio', 'Torino', 'Via Accademia delle Scienze 6', '011 5617776', 'lunedì', 15, 'www.museoegizio.it'),
('Brera', 'Milano', 'Via Brera 28', '02 722631', 'lunedì', 15, 'pinacotecabrera.org'),
('MANN', 'Napoli', 'Piazza Museo 19', '081 4422149', 'martedì', 18, 'www.mannapoli.it'),
('Guggenheim', 'Venezia', 'Dorsoduro 701', '041 2405411', 'martedì', 16, 'www.guggenheim-venice.it'),
('Reale', 'Torino', 'Piazzetta Reale 1', '011 4361455', 'lunedì', 15, 'www.museireali.beniculturali.it'),
('Borghese', 'Roma', 'Piazzale Scipione Borghese 5', '06 8413979', 'lunedì', 13, 'galleriaborghese.beniculturali.it'),
('Capodimonte', 'Napoli', 'Via Miano 2', '081 7499111', 'mercoledì', 12, 'www.museocapodimonte.beniculturali.it'),
('MAMbo', 'Bologna', 'Via Don Giovanni Minzoni 14', '051 6496611', 'lunedì', 6, 'www.mambo-bologna.org');

insert into Opera (nome, cognomeAutore, nomeAutore, museo, città, epoca, anno)
values
('Nascita di Venere', 'Botticelli', 'Sandro', 'Uffizi', 'Firenze', 'Rinascimento', 1485),
('Primavera', 'Botticelli', 'Sandro', 'Uffizi', 'Firenze', 'Rinascimento', 1482),
('Scuola di Atene', 'Sanzio', 'Raffaello', 'Musei Vaticani', 'Roma', 'Rinascimento', 1511),
('Giudizio Universale', 'Buonarroti', 'Michelangelo', 'Musei Vaticani', 'Roma', 'Rinascimento', 1541),
('Statua di Ramesse II', 'Sconosciuto', 'Egizio', 'Egizio', 'Torino', 'Antico Egitto', -1279),
('Sposalizio della Vergine', 'Sanzio', 'Raffaello', 'Brera', 'Milano', 'Rinascimento', 1504),
('Cristo Velato', 'Sanmartino', 'Giuseppe', 'Capodimonte', 'Napoli', 'Barocco', 1753),
('Apollo e Dafne', 'Bernini', 'Gian Lorenzo', 'Borghese', 'Roma', 'Barocco', 1625),
('L''Impero dei Lumi', 'Magritte', 'René', 'Guggenheim', 'Venezia', 'Surrealismo', 1954),
('Toro Farnese', 'Sconosciuto', 'Ellenismo', 'MANN', 'Napoli', 'Classica', -200);

insert into Mostra (titolo, inizio, fine, museo, città, prezzoIntero, prezzoRidotto)
values
('Leonardo e il Disegno', '2026-03-01', '2026-06-01', 'Uffizi', 'Firenze', 18, 10),
('Egitto Invisibile', '2026-04-15', '2026-10-15', 'Egizio', 'Torino', 20, 12),
('Raffaello a Milano', '2026-01-10', '2026-05-10', 'Brera', 'Milano', 15, 8),
('Pompei ed Ercolano', '2026-05-20', '2026-12-20', 'MANN', 'Napoli', 14, null),
('Futurismo Veneziano', '2026-02-01', '2026-04-30', 'Guggenheim', 'Venezia', 12, 6),
('Caravaggio e i suoi', '2026-09-01', '2026-12-31', 'Borghese', 'Roma', 16, 9),
('Pop Art Italiana', '2026-06-15', '2026-09-15', 'MAMbo', 'Bologna', 10, 5),
('I Tesori dei Papi', '2026-03-10', '2026-07-10', 'Musei Vaticani', 'Roma', 22, null),
('Napoli Sotto i Borbone', '2026-01-20', '2026-04-20', 'Capodimonte', 'Napoli', 13, 7),
('Savoia Re d''Italia', '2026-05-01', '2026-08-31', 'Reale', 'Torino', 15, 8);

insert into Orario (progressivo, museo, città, giorno, orarioApertura, orarioChiusura)
values
(4, 'Uffizi', 'Firenze', 'lunedì', '08:15 CET', '18:30 CET'),
(5, 'Musei Vaticani', 'Roma', 'martedì', '09:00 CET', '18:00 CET'),
(6, 'Egizio', 'Torino', 'mercoledì', '09:00 CET', '18:30 CET'),
(7, 'Brera', 'Milano', 'giovedì', '08:30 CET', '19:15 CET'),
(8, 'MANN', 'Napoli', 'venerdì', '09:00 CET', '19:30 CET'),
(9, 'Guggenheim', 'Venezia', 'sabato', '10:00 CET', '18:00 CET'),
(10, 'Borghese', 'Roma', 'domenica', '09:00 CET', '19:00 CET'),
(11, 'MAMbo', 'Bologna', 'lunedì', '10:00 CET', '20:00 CET'),
(12, 'Capodimonte', 'Napoli', 'martedì', '08:30 CET', '19:30 CET'),
(13, 'Reale', 'Torino', 'mercoledì', '09:00 CET', '19:00 CET');
