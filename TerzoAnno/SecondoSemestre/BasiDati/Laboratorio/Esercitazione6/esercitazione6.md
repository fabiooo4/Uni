# Esercitazione 6

- [Esercizi](#esercizi)
  - [Esercizio 1](#esercizio-1)
  - [Esercizio 2](#esercizio-2)
  - [Esercizio 3](#esercizio-3)
  - [Esercizio 4](#esercizio-4)
  - [Esercizio 5](#esercizio-5)

Si considerino le tabelle create nell’[esercitazione 2](../Esercitazione2/init.sql).
Per ogni esercizio scrivere il dettaglio delle transazioni richieste e commentare il
livello d’isolamento scelto per garantire che le operazioni nelle transazioni siano
eseguite in modo corretto.

## Esercizi

### Esercizio 1

Si assume che la tabella `Museo` possa essere aggiornata da applicazioni diverse, non
sincronizzate fra loro. Scrivere una transazione che aggiunga un museo e dimostrare
cosa succede se due applicazioni aggiungono lo stesso museo nello stesso istante usando
lo schema della transazione proposta.

```sql
begin;
insert into Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo, sitoInternet)
values
('Reggia di Caserta', 'Caserta', 'Viale Douhet 2', '0823 236811', 'martedì', 10, 'www.reggiadicaserta.beniculturali.it');
commit;
```

|     | Transazione 1                                                                                                                                                                                                                                             | Transazione 2                                                                                                                                                                                                                                                             |     |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| 1   | `begin;`                                                                                                                                                                                                                                                  | `begin;`                                                                                                                                                                                                                                                                  | 1   |
| 2   | `insert into Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo, sitoInternet) values ('Reggia di Caserta', 'Caserta', 'Viale Douhet 2', '0823 236811', 'martedì', 10, 'www.reggiadicaserta.beniculturali.it');`</br></br>`INSERT 0 1` |                                                                                                                                                                                                                                                                           | 2   |
| 3   |                                                                                                                                                                                                                                                           | `insert into Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo, sitoInternet) values ('Reggia di Caserta', 'Caserta', 'Viale Douhet 2', '0823 236811', 'martedì', 10, 'www.reggiadicaserta.beniculturali.it');`</br></br> `-- Insert in attesa di T1` | 3   |
| 4   | `commit;`                                                                                                                                                                                                                                                 | `ERROR:  duplicate key value violates unique constraint "museo_pkey"`</br>`DETAIL:  Key (nome, "città")=(Reggia di Caserta, Caserta) already exists.`                                                                                                                     | 4   |
| 5   |                                                                                                                                                                                                                                                           | `commit;`</br>`ROLLBACK`                                                                                                                                                                                                                                                  | 5   |

Si utilizza il livello di isolamento "Read Committed" perchè così
l'inserimento della transazione 2 aspetta che venga completato quello della
transazione 1. Una volta che la transazione 1 fa il commit, la transazione 2 si sblocca
e prova ad eseguire l'inserimento, fallendo perchè è già stato effettuato dalla
transazione 1.

### Esercizio 2

Si assuma che una transazione deve visualizzare i prezzi dei musei di `Verona` che
hanno parte decimale diversa da 0 e, poi, aggiornare tali prezzi del 10% arrotondando
alla seconda cifra decimale. L’altra transazione (concorrente) deve aggiornare il
prezzo dei musei di `Verona` aumentandoli del 10% e arrotondando alla seconda cifra
decimale.

Non ci sono musei di Verona con prezzo con parte decimale diversa da 0, quindi
li inseriamo per poter testare le transazioni.

```sql
insert into Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo, sitoInternet)
values
('Museo di Storia Naturale', 'Verona', 'Via San Francesco 22', '045 8007158', 'lunedì', 12.30, 'www.museodistorianaturaleverona.it'),
('Museo di Palazzo Forti', 'Verona', 'Via Forti 1', '045 8007158', 'lunedì', 10.20, 'www.museodipalazzoforti.it');
```

- Transazione 1

```sql
begin transaction isolation level repeatable read;
create temp view prezzi_decimali as
select museo.prezzo
from museo
where museo.città = 'Verona'
  and abs(museo.prezzo) - floor(abs(museo.prezzo)) != 0;

select *
from prezzi_decimali;

update museo
set prezzo = round(prezzo * 1.1, 2)
where prezzo = any (select * from prezzi_decimali);
commit;
```

- Transazione 2

```sql
begin;
update museo
set prezzo = round(prezzo * 1.1, 2)
where città = 'Verona';
commit;
```

|     | Transazione 1                                                                                                                                            | Transazione 2                                                                                  |     |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | --- |
| 1   | `begin transaction isolation level repeatable read;`                                                                                                     | `begin;`                                                                                       | 1   |
| 2   | `create temp view prezzi_decimali as select museo.prezzo from museo where museo.città = 'Verona' and abs(museo.prezzo) - floor(abs(museo.prezzo)) != 0;` |                                                                                                | 2   |
| 3   | `select * from prezzi_decimali;`</br></br>`prezzo`</br>`--------`</br>`12.30`</br>`10.20 `</br>`(2 rows)`                                                |                                                                                                | 3   |
| 4   |                                                                                                                                                          | `update museo set prezzo = round(prezzo * 1.1, 2) where città = 'Verona';`</br></br>`UPDATE 3` | 4   |
| 5   | `update museo set prezzo = round(prezzo * 1.1, 2) where prezzo = any (select * from prezzi_decimali);`</br></br>`-- Update in attesa di T2`              |                                                                                                | 5   |
| 6   | `ERROR:  could not serialize access due to concurrent update`                                                                                            | `commit;`                                                                                      | 6   |
| 7   | `commit;`</br>`ROLLBACK`                                                                                                                                 |                                                                                                | 7   |

Si utilizza il livello di isolamento "Repeatable Read" per assicurare che la
transazione 1 veda sempre gli stessi dati da quando inizia a quando finisce,
ciò impedisce alla transazione 1 di essere eseguita se nel mentre viene eseguita
un'altra transazione che modifica i dati, come in questo caso con la transazione 2.

### Esercizio 3

In una transazione si deve inserire una nuova mostra al museo di
`Castelvecchio di Verona` con prezzo d’ingresso a 40 euro e prezzo ridotto a 20.
Nell’altra transazione (concorrente) si deve calcolare il prezzo medio delle mostre di
`Verona` prima considerando solo i prezzi ordinari e, in un’interrogazione separata,
considerando solo i prezzi ridotti.

- Transazione 1

```sql
begin;
insert into Mostra (titolo, inizio, fine, museo, città, prezzoIntero, prezzoRidotto)
values ('Bella mostra', '2026-02-01', '2026-07-31', 'CastelVecchio', 'Verona', 40, 20);
commit;
```

- Transazione 2

```sql
begin transaction isolation level repeatable read;
select avg(mostra.prezzointero) as mediaintero
from mostra
where mostra.città = 'Verona';

select avg(mostra.prezzoridotto) as mediaridotto
from mostra
where mostra.città = 'Verona';
commit;
```

|     | Transazione 1                                                                                                                                                                                          | Transazione 2                                                                                                                                                                                 |     |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| 1   | `begin;`                                                                                                                                                                                               | `begin transaction isolation level repeatable read;`                                                                                                                                          | 1   |
| 2   |                                                                                                                                                                                                        | `select avg(mostra.prezzointero) as mediaintero from mostra where mostra.città = 'Verona';`</br></br>`mediaintero` </br> `---------------------` </br> `10.0000000000000000` </br> `(1 row)`  | 2   |
| 3   | `insert into Mostra (titolo, inizio, fine, museo, città, prezzoIntero, prezzoRidotto) values ('Bella mostra', '2026-02-01', '2026-07-31', 'CastelVecchio', 'Verona', 40, 20);` </br></br> `INSERT 0 1` |                                                                                                                                                                                               | 3   |
| 4   |                                                                                                                                                                                                        | `select avg(mostra.prezzoridotto) as mediaridotto from mostra where mostra.città = 'Verona';`</br></br>`mediaridotto` </br> `--------------------` </br> `6.0000000000000000` </br> `(1 row)` | 4   |
| 5   | `commit;`                                                                                                                                                                                              |                                                                                                                                                                                               | 5   |
| 6   |                                                                                                                                                                                                        | `commit;`                                                                                                                                                                                     | 6   |

Si utilizza il livello di isolamento "Repeatable Read" per far si che la transazione 2
legga i valori da un'istantanea del database che non può essere modificata.

### Esercizio 4

In una transazione si deve aumentare il prezzo intero di tutte le mostre di `Verona`
del 10% mentre, nell’altra, si devono ridurre i prezzi ridotti di tutte le mostre del
5%. In entrambi i casi, l’importo finale si deve arrotondare alla seconda cifra
decimale.

- Transazione 1

```sql
begin;
update mostra
set prezzointero = round(prezzointero * 1.1, 2)
where città = 'Verona';
commit;
```

- Transazione 2

```sql
begin;
update mostra
set prezzoridotto = round(prezzoridotto * 0.95, 2);
commit;
```

|     | Transazione 1                                                                                                      | Transazione 2                                                                                              |     |
| --- | ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- | --- |
| 1   | `begin;`                                                                                                           | `begin;`                                                                                                   | 1   |
| 2   | `update mostra set prezzointero = round(prezzointero * 1.1, 2) where città = 'Verona'; rollback;` </br> `UPDATE 2` |                                                                                                            | 2   |
| 3   |                                                                                                                    | `update mostra set prezzoridotto = round(prezzoridotto * 0.95, 2);` </br></br> `-- Update in attesa di T1` | 3   |
| 4   | `commit;`                                                                                                          | `UPDATE 14`                                                                                                | 4   |
| 5   |                                                                                                                    | `commit;`                                                                                                  | 5   |

Si utilizza il livello di isolamento "Read Committed" perchè gli attributi modificati
dalle transazioni sono attributi diversi della stessa tupla, quindi non ci sono
anomalie.

### Esercizio 5

In una transazione, calcolare la media dei prezzi dei musei di `Vicenza` ed aggiungere
un nuovo museo a `Verona` (`’Museo moderno’`) con prezzo uguale alla media calcolata.
In un’altra transazione calcolare la media dei prezzi dei musei di `Verona` e
aggiungere un nuovo museo a `Vicenza` con prezzo uguale alla media calcolata sui musei
di `Verona`.

Si segnala che:

1. Con `SELECT` si possono anche creare colonne con valori costanti.
   Esempio: `SELECT ’Museo Moderno’, ’Verona’, ecc FROM ...`
2. `INSERT` accetta di inserire anche risultati ottenuti da `SELECT` interne.
   Esempio: `INSERT INTO Museo (nome, citta, ...) SELECT ’Museo Moderno’, ’Verona’, ... FROM...`

Siccome non ci sono musei di Vicenza, li inseriamo per poter testare le transazioni.

```sql
insert into museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo, sitoInternet)
values
('Museo di Palazzo Chiericati', 'Vicenza', 'Piazza Matteotti 1', '0444 222248', 'lunedì', 6, 'www.museochiericati.beniculturali.it'),
('Museo del Gioiello', 'Vicenza', 'Piazza dei Signori 8', '0444 222248', 'lunedì', 5, 'www.museodelgioiello.beniculturali.it');
```

- Transazione 1

```sql
begin transaction isolation level serializable;
select avg(museo.prezzo)
from museo
where museo.città = 'Vicenza';

insert into museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, sitoInternet, prezzo)
select 'Museo Moderno', 'Verona', 'Via Moderno 1', '0451234567', 'lunedì', 'www.museomoderno.it',
    (select avg(museo.prezzo)
    from museo
    where museo.città = 'Vicenza');
commit;
```

- Transazione 2

```sql
begin transaction isolation level serializable;
select avg(museo.prezzo)
from museo
where museo.città = 'Verona';

insert into museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, sitoInternet, prezzo)
select 'Museo Contemporaneo', 'Vicenza', 'Via Contemporaneo 1', '0441234567', 'martedì', 'www.museocontemporaneo.it',
    (select avg(museo.prezzo)
    from museo
    where museo.città = 'Verona');
commit;
```

|     | Transazione 1                                                                                                                                                                                                                                                                              | Transazione 2                                                                                                                                                                                                                                                                                                 |     |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| 1   | `begin transaction isolation level serializable;`                                                                                                                                                                                                                                          | `begin transaction isolation level serializable;`                                                                                                                                                                                                                                                             | 1   |
| 2   | `select avg(museo.prezzo) from museo where museo.città = 'Vicenza';`</br></br> `avg`</br> `--------------------`</br> `5.5000000000000000`</br> `(1 row)`                                                                                                                                  |                                                                                                                                                                                                                                                                                                               | 2   |
| 3   |                                                                                                                                                                                                                                                                                            | `select avg(museo.prezzo) from museo where museo.città = 'Verona';`</br></br> `avg`</br> `---------------------`</br> `14.1166666666666667` (1 row)                                                                                                                                                           | 3   |
| 4   | `insert into museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, sitoInternet, prezzo) select 'Museo Moderno', 'Verona', 'Via Moderno 1', '0451234567', 'lunedì', 'www.museomoderno.it', (select avg(museo.prezzo) from museo where museo.città = 'Vicenza');`</br>`INSERT 0 1` |                                                                                                                                                                                                                                                                                                               | 4   |
| 5   |                                                                                                                                                                                                                                                                                            | `insert into museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, sitoInternet, prezzo) select 'Museo Contemporaneo', 'Vicenza', 'Via Contemporaneo 1', '0441234567', 'martedì', 'www.museocontemporaneo.it', (select avg(museo.prezzo) from museo where museo.città = 'Verona');`</br>`INSERT 0 1` | 5   |
| 6   | `commit;`                                                                                                                                                                                                                                                                                  |                                                                                                                                                                                                                                                                                                               | 6   |
| 7   |                                                                                                                                                                                                                                                                                            | `commit;` </br></br> `ERROR:  could not serialize access due to read/write dependencies among transactions DETAIL:  Reason code: Canceled on identification as a pivot, during commit attempt. HINT:  The transaction might succeed if retried.`                                                              | 7   |

Si utilizza il livello di isolamento "Serializable" per far si che le transazioni siano
serializzabili, siccome l'inserimento di una transazione dipende dai dati letti dall'altra
transazione. In questo caso, una delle due transazioni fallisce perchè è stata eseguita
un'altra transazione che ha modificato i dati letti, quindi è necessario eseguirla
di nuovo senza transazioni concorrenti.
