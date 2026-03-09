#`Museo` Esercitazione 1

- [Schema base di dati](#schema-base-di-dati)
  - [Esercizi](#esercizi)
    - [Esercizio 1](#esercizio-1)
    - [Esercizio 2](#esercizio-2)
    - [Esercizio 3](#esercizio-3)
    - [Esercizio 4](#esercizio-4)
    - [Esercizio 5](#esercizio-5)
    - [Esercizio 6](#esercizio-6)
    - [Esercizio 7](#esercizio-7)
    - [Esercizio 8](#esercizio-8)
    - [Esercizio 9](#esercizio-9)

Si vuole progettare il sistema informativo per la gestione dei musei del Veneto. Una
possibile traccia dello schema relazionale è data nella seguente sezione.

## Schema base di dati

Le entità di seguito specificate conterranno le informazioni relative ai musei e alle
opere ritenute significative.

```sql
Museo (
    _nome_: stringa (30 car.),
    _città_: stringa (20 car.),
    indirizzo: ...,
    numeroTelefono: ...,
    giornoChiusura: ...,
    prezzo: ...,
)

Mostra (
    _titolo_: stringa (30 car.),
    _inizio_: DATE,
    fine: DATE,
    museo: ...,
    città: ...,
    prezzo: ...,
)

Opera (
    _nome_: stringa (30 car.),
    _cognomeAutore_: stringa (20 car.),
    _nomeAutore_: stringa (20 car.),
    museo: ...,
    città: ...,
    epoca: ...,
    anno: ...
)

Orario (
    _progressivo_: intero,
    museo: ...,
    città: ...,
    giorno: ..., -- proporre un dominio
    orarioApertura: TIME WITH TIME ZONE,
    orarioChiusura: TIME WITH TIME ZONE
)
```

- Gli attributi chiave primaria sono sottolineati (`_nome_`)
- Gli attributi `museo` e `città` nelle entità `Opera`, `Mostra`, e `Orario` sono chiave esportata
- Attributi diversi da null: `Museo.giornoChiusura`, `Museo.prezzo`, `Mostra.fine`,
  `Orario.museo`, `Orario.città`, `Orario.giorno`.
- Valori di default: `Museo.città` ha come valore di default `"Verona"`. `Museo.nome`
  ha come valore di default `"MuseoVeronese"`. `Museo.prezzo` ha come valore di
  default `10`. `Orario.orarioApertura` ha come valore di default `"09:00 CET"`.
  `Orario.orarioChiusura` ha come valore di default `"19:00 CET"`.

Per l’implementazione delle chiavi esterne si considerino le seguenti politiche di
reazione alla cancellazione e alla modifica.

```sql
REFERENCES reftable [ ( refcolumn ) ]
[ ON DELETE referential_action ]
[ ON UPDATE referential_action ] (column constraint)

FOREIGN KEY ( column_name [, ... ] )
REFERENCES reftable [ ( refcolumn [, ... ] ) ]
[ ON DELETE referential_action ]
[ ON UPDATE referential_action ] (table constraint)
```

La clausola `ON DELETE` specifica l’azione da eseguire quando il valore referenziato
nella tabella master viene cancellato. In modo simile, la clausola `ON UPDATE` specifica
l’azione da eseguire quando il valore referenziato nella tabella master viene aggiornato
con un nuovo valore.

Le azioni possibili sono:

- `NO ACTION`:
  (Default) Produce un errore indicante che l’aggiornamento o la cancellazione
  violano il vincolo di chiave esportata.
- `CASCADE`:
  Cancella tutte le righe della tabella slave che fanno riferimento alla riga
  cancellata nella tabella master, o modifica il valore contenuto nella tabella
  slave con il nuovo valore inserito nella tabella master.
- `SET NULL [ ( column_name [, ... ] ) ]`:
  Imposta a `NULL` tutti i valori contenuti nella tabella slave che fanno riferimento
  ai valori aggiornati nella tabella master. Viene ritornato un errore se tali
  colonne devono essere diversi da `NULL`!
- `SET DEFAULT [ ( column_name [, ... ] ) ]`:
  Imposta al loro valore di default tutti i valori contenuti nella tabella slave che
  fanno riferimento ai valori aggiornati nella tabella master. à viene ritornato un
  errore se tali colonne non hanno un valore di default e non possono essere
  `NULL`!

## Esercizi

### Esercizio 1

Scrivere il codice PostgreSQL che generi tutte le tabelle. Per gli attributi di cui non
è stato specificato il tipo, scegliere quello opportuno. Specificare tutti i vincoli
possibili, sia intra- sia inter-relazionali.

```sql
create table Museo (
    nome char varying(30) default 'MuseoVeronese',
    città char varying(20) default 'Verona',
    indirizzo char varying(50),
    numeroTelefono char varying(20),
    giornoChiusura char varying(10) not null,
    prezzo decimal not null default 10,

    check(numeroTelefono ~ '^[+]?[0-9 ]+$'),
    check(giornoChiusura in ('lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica')),
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
    giorno date not null,
    orarioApertura time with time zone default '09:00 CET',
    orarioChiusura time with time zone default '19:00 CET',

    check(orarioChiusura > orarioApertura),

    foreign key (museo, città)
        references Museo (nome, città)
        on update cascade
        on delete cascade
);
```

### Esercizio 2

Inserire nell’entità `Museo` le seguenti tuple:

```
(Arena, Verona, piazza Bra, 045 8003204, martedì, 20),
(CastelVecchio, Verona, Corso Castelvecchio, 045 594734, lunedì, 15);
```

```sql
insert into Museo
values ('Arena', 'Verona', 'piazza Bra', '045 8003204', 'martedì', 20),
       ('CastelVecchio', 'Verona', 'Corso Castelvecchio', '045 594734', 'lunedì', 15);
```

### Esercizio 3

Popolare le tabelle `Opera` e `Mostra` con almeno altre tre tuple ciascuna.

```sql
insert into Opera
values ('L''Abbraccio', 'Domenico', 'Foschini', 'Arena', 'Verona', 'Rinascimento', 1500),
       ('Il Bacio', 'Giuseppe', 'Verdi', 'CastelVecchio', 'Verona', 'Barocco', 1600),
       ('La Danza', 'Leonardo', 'Da Vinci', 'Arena', 'Verona', 'Rinascimento', 1505);

insert into Mostra
values ('Rinascimento a Verona', '2026-01-01', '2026-06-30', 'Arena', 'Verona', 12),
       ('Barocco a Verona', '2026-02-01', '2026-07-31', 'CastelVecchio', 'Verona', 10),
       ('Arte Moderna a Verona', '2026-03-01', '2026-08-31', 'Arena', 'Verona', 15);
```

### Esercizio 4

Provare ad inserire nella relazione `Museo` tuple che violino i vincoli specificati.

```sql
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
    );
```

### Esercizio 5

Nell’entità `Museo`, aggiungere l’attributo `sitoInternet` e inserire gli opportuni
valori.

```sql
alter table Museo
    add column sitoInternet char varying(100);

update Museo
    set sitoInternet = 'www.arena.it'
    where nome = 'Arena' and città = 'Verona';

update Museo
    set sitoInternet = 'www.castelvecchio.it'
    where nome = 'CastelVecchio' and città = 'Verona';
```

### Esercizio 6

Nell’entità `Mostra` modificare l’attributo `prezzo` in `prezzoIntero` ed aggiungere
l’attributo `prezzoRidotto` con valore di default `5`. Aggiungere il vincolo (di tabella o
di attributo?) che garantisca che `Mostra.prezzoRidotto` sia minore di
`Mostra.prezzoIntero`.

```sql
alter table Mostra
    rename column prezzo to prezzoIntero;

alter table Mostra
    add column prezzoRidotto integer default 5
    check(prezzoRidotto >= 0);
```

### Esercizio 7

Nell’entità `Museo` aggiornare il `prezzo` aggiungendo `1 Euro` alle tuple esistenti.

```sql
update Museo
    set prezzo = prezzo + 1;
```

### Esercizio 8

Nell’entità `Mostra` aggiornare il `prezzoRidotto` aumentandolo di `1 Euro` per quelle
mostre che hanno `prezzoIntero` inferiore a `15 Euro`.

```sql
update Mostra
    set prezzoRidotto = prezzoRidotto + 1
    where prezzoIntero < 15;
```

### Esercizio 9

Si assume che in ciascuna tabella della base di dati ci siano almeno 3 righe inserite.
Implementare le chiavi esportate per ciascuna delle 4 politiche di reazione presentate
nella pagina precedente (usare il comando `DROP CONTRAINTS` e `ADD CONSTRAINTS`
per effettuare il cambio di politica). Provare ad eseguire una cancellazione ed un
aggiornamento dei valori riferiti (e dei valori non riferiti) per verificare il diverso
comportamento del DBMS.

```sql
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
```
