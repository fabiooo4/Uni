# Esercitazione 5

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
  - [Esercizio 10](#esercizio-10)
  - [Esercizio 11](#esercizio-11)
  - [Esercizio 12](#esercizio-12)

Considerare la base di dati personale con tabelle importate dalla base di dati
`did2014small`.
Per importare la base di dati `did2014small` bisogna eseguire i seguenti comandi:

1. Creare un backup del database nel file `backupDid2014small.sql`

```
g_dump -xcO -h db-srv.di.univr.it -d did2014small -U <login GIA> -f backupDid2014small.sql
```

2. Importare il backup nella propria base di dati personale

```
psql -h db-srv.di.univr.it -d <login GIA> -U <login GIA> -f backupDid2014small.sql
```

Dopo aver eseguito il dump e il successivo restore di `did2014small`, eseguire i
seguenti esercizi.
La base di dati `did2014small` della base di dati `did2014` senza alcuna chiave
vincolo referenziale e indice:

- CorsoStudi(**id**, nome, codice, abbreviazione, durataAnni, sede, informativa,
  id_segreteria)
- Insegn(**id**, nomeins, codiceins)
- Discriminante(**id**, nome, descrizione)
- InsErogato(**id**, annoaccademico, id_insegn, id_corsostudi, id_discriminante,
  modulo, discriminantemodulo, nomemodulo, crediti, programma, id_facolta, hamoduli,
  id_inserogato_padre, nomeunità, annierogazione)

e le seguenti indicazioni:

- Nella tabella `InsErogato` gli insegnamenti che non hanno moduli hanno l'attributo
  `hamoduli = '0'`; nella medesima tabella le righe che descrivono un insegnamento nel
  suo complesso hanno l'attributo `modulo = 0`, mentre le righe che descrivono singoli
  moduli hanno `modulo > 0`.
- L'attributo `discriminante` distingue repliche dello stesso insegnamento (ad esempio,
  tale attributo può contenere valori come: `'matricole pari'`, `'matricole dispari'`).
- Alcuni insegnamenti sono divisi in unità logistiche (teoria, laboratorio,
  esercitazioni, ecc. . . ). Tali unità sono rappresentate come entità di `InsErogato`
  in cui: il loro nome è dato dall'attributo `nomeunita`, hanno un valore `modulo < 0` e
  sono legate al padre (insegnamento erogato con `modulo = 0`) da una relazione
  esplicita implementata dall'attributo `id_inserogato_padre`. L'attributo `haunita` ha
  per le unità lo stesso significato di `hamoduli` per i moduli.
- L'attributo `annierogazione` indica gli anni a cui è offerto l'insegnamento (1°,
  1° e 2°, 3° ecc. . . ). Esso viene rappresentato da un intero che va interpretato
  come stringa di bit: `2 = 000010` indica il secondo anno, `3 = 000011` indica la
  combinazione 1° e 2° anno, `4 = 000100` indica il 3° anno, ecc. . .

Scrivere in SQL le seguenti interrogazioni, creare gli opportuni indici e dimostrare il guadagno, in
termini di numero di pagine disco, che si ottiene con gli indici proposti (prima di ogni query, le
tabelle coinvolte NON devono avere indici). Quindi la risposta all'esercizio deve essere la
dichiarazione degli indici che sono necessari e sufficienti per migliorare le prestazioni della query
e di quanti accessi al disco diminuisce il costo della query con il contenuto attuale della base di
dati.

## Esercizi

### Esercizio 1

Visualizzare in nomi dei corsi di studio che finiscono con la stringa `'informatica'`
senza considerare maiuscole/minuscole.

```sql
explain analyze select corsostudi.nome
from corsostudi
where corsostudi.nome ilike '%informatica';

create index corsostudi_idx on corsostudi (nome);
analyze corsostudi; -- refresh table

explain analyze select corsostudi.nome
from corsostudi
where corsostudi.nome ilike '%informatica';

drop index corsostudi_idx;
analyze corsostudi;
```

```
                                              QUERY PLAN
------------------------------------------------------------------------------------------------------
 Seq Scan on corsostudi  (cost=0.00..98.94 rows=6 width=86) (actual time=0.082..5.758 rows=5 loops=1)
   Filter: ((nome)::text ~~* '%informatica'::text)
   Rows Removed by Filter: 630
 Planning Time: 1.782 ms
 Execution Time: 5.838 ms
(5 rows)

CREATE INDEX
ANALYZE
                                              QUERY PLAN
------------------------------------------------------------------------------------------------------
 Seq Scan on corsostudi  (cost=0.00..98.94 rows=6 width=86) (actual time=0.020..3.529 rows=5 loops=1)
   Filter: ((nome)::text ~~* '%informatica'::text)
   Rows Removed by Filter: 630
 Planning Time: 1.181 ms
 Execution Time: 3.556 ms
(5 rows)

DROP INDEX
ANALYZE
```

### Esercizio 2

Visualizzare in nomi degli insegnamenti che iniziano per `'Teoria...'`

```sql
explain analyze select insegn.nomeins
from insegn
where insegn.nomeins ilike 'Teoria%';

create index insegn_idx on insegn (nomeins);
analyze insegn;

explain analyze select insegn.nomeins
from insegn
where insegn.nomeins ilike 'Teoria%';

drop index insegn_idx;
analyze insegn;
```

```
                                              QUERY PLAN
------------------------------------------------------------------------------------------------------
 Seq Scan on insegn  (cost=0.00..200.11 rows=86 width=39) (actual time=0.199..15.557 rows=55 loops=1)
   Filter: ((nomeins)::text ~~* 'Teoria%'::text)
   Rows Removed by Filter: 8114
 Planning Time: 1.382 ms
 Execution Time: 15.638 ms
(5 rows)

CREATE INDEX
ANALYZE
                                             QUERY PLAN
-----------------------------------------------------------------------------------------------------
 Seq Scan on insegn  (cost=0.00..200.11 rows=86 width=39) (actual time=0.069..8.868 rows=55 loops=1)
   Filter: ((nomeins)::text ~~* 'Teoria%'::text)
   Rows Removed by Filter: 8114
 Planning Time: 0.393 ms
 Execution Time: 8.881 ms
(5 rows)

DROP INDEX
ANALYZE
```

### Esercizio 3

Trovare, per ogni insegnamento erogato dell'a.a. `2013/2014`, il suo `nome` e `id`
della facoltà che lo gestisce usando la relazione assorbita con facoltà.

```sql
explain analyze select distinct insegn.nomeins, inserogato.id_facolta
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
where inserogato.annoaccademico = '2013/2014';

create index inserogato_idx_1 on inserogato (annoaccademico);
create index inserogato_idx_2 on inserogato (id_insegn);
analyze inserogato;

explain analyze select distinct insegn.nomeins, inserogato.id_facolta
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
where inserogato.annoaccademico = '2013/2014';

drop index inserogato_idx_1;
drop index inserogato_idx_2;
analyze inserogato;
```

```

                                                        QUERY PLAN
---------------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=6343.63..6395.16 rows=5153 width=43) (actual time=36.380..36.607 rows=1863 loops=1)
   Group Key: insegn.nomeins, inserogato.id_facolta
   Batches: 1  Memory Usage: 465kB
   ->  Hash Join  (cost=281.80..6317.87 rows=5153 width=43) (actual time=6.709..34.699 rows=5155 loops=1)
         Hash Cond: (inserogato.id_insegn = insegn.id)
         ->  Seq Scan on inserogato  (cost=0.00..5965.21 rows=5153 width=8) (actual time=0.110..26.119 rows=5155 loops=1)
               Filter: ((annoaccademico)::text = '2013/2014'::text)
               Rows Removed by Filter: 62862
         ->  Hash  (cost=179.69..179.69 rows=8169 width=43) (actual time=6.487..6.488 rows=8169 loops=1)
               Buckets: 8192  Batches: 1  Memory Usage: 675kB
               ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.022..2.885 rows=8169 loops=1)
 Planning Time: 1.386 ms
 Execution Time: 37.195 ms
(13 rows)

CREATE INDEX
CREATE INDEX
ANALYZE
                                                                 QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=5798.51..5850.18 rows=5167 width=43) (actual time=16.687..16.979 rows=1863 loops=1)
   Group Key: insegn.nomeins, inserogato.id_facolta
   Batches: 1  Memory Usage: 465kB
   ->  Hash Join  (cost=342.14..5772.68 rows=5167 width=43) (actual time=7.831..14.338 rows=5155 loops=1)
         Hash Cond: (inserogato.id_insegn = insegn.id)
         ->  Bitmap Heap Scan on inserogato  (cost=60.34..5419.83 rows=5167 width=8) (actual time=1.314..4.901 rows=5155 loops=1)
               Recheck Cond: ((annoaccademico)::text = '2013/2014'::text)
               Heap Blocks: exact=1524
               ->  Bitmap Index Scan on inserogato_idx_1  (cost=0.00..59.04 rows=5167 width=0) (actual time=0.752..0.753 rows=5155 loops=1)
                     Index Cond: ((annoaccademico)::text = '2013/2014'::text)
         ->  Hash  (cost=179.69..179.69 rows=8169 width=43) (actual time=6.492..6.492 rows=8169 loops=1)
               Buckets: 8192  Batches: 1  Memory Usage: 675kB
               ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.012..3.029 rows=8169 loops=1)
 Planning Time: 0.656 ms
 Execution Time: 17.165 ms
(15 rows)

DROP INDEX
DROP INDEX
ANALYZE
```

### Esercizio 4

Visualizzare il `codice`, il `nome` e l'`abbreviazione` di tutti corsi di studio che
nel nome contengono la sottostringa `'lingue'` (eseguire un test
case-insensitive: usare `ILIKE` invece di `LIKE`).

```sql
explain analyze select corsostudi.codice, corsostudi.nome, corsostudi.abbreviazione
from corsostudi
where corsostudi.nome ilike '%lingue%';

create index corsostudi_idx on corsostudi (nome);
analyze corsostudi;

explain analyze select corsostudi.codice, corsostudi.nome, corsostudi.abbreviazione
from corsostudi
where corsostudi.nome ilike '%lingue%';

drop index corsostudi_idx;
analyze corsostudi;
```

```
                                               QUERY PLAN
--------------------------------------------------------------------------------------------------------
 Seq Scan on corsostudi  (cost=0.00..98.94 rows=19 width=98) (actual time=0.076..3.406 rows=16 loops=1)
   Filter: ((nome)::text ~~* '%lingue%'::text)
   Rows Removed by Filter: 619
 Planning Time: 1.572 ms
 Execution Time: 3.498 ms
(5 rows)

CREATE INDEX
ANALYZE
                                               QUERY PLAN
--------------------------------------------------------------------------------------------------------
 Seq Scan on corsostudi  (cost=0.00..98.94 rows=19 width=98) (actual time=0.025..1.336 rows=16 loops=1)
   Filter: ((nome)::text ~~* '%lingue%'::text)
   Rows Removed by Filter: 619
 Planning Time: 0.467 ms
 Execution Time: 1.350 ms
(5 rows)

DROP INDEX
ANALYZE
```

### Esercizio 5

Visualizzare identificatori e numero modulo dei moduli reali (`modulo > 0`) degli
insegnamenti erogati nel `2010/2011` associati alla facoltà con `id=7` tramite la
relazione diretta.

```sql
explain analyze select inserogato.id, inserogato.modulo
from inserogato
where inserogato.modulo > 0
  and inserogato.annoaccademico = '2010/2011'
  and inserogato.id_facolta = 7;

create index inserogato_idx_1 on inserogato (modulo, annoaccademico, id_facolta);
analyze inserogato;

explain analyze select inserogato.id, inserogato.modulo
from inserogato
where inserogato.modulo > 0
  and inserogato.annoaccademico = '2010/2011'
  and inserogato.id_facolta = 7;

drop index inserogato_idx_1;
analyze inserogato;
```

```
                                                 QUERY PLAN
-------------------------------------------------------------------------------------------------------------
 Seq Scan on inserogato  (cost=0.00..6305.30 rows=857 width=7) (actual time=0.065..36.281 rows=1299 loops=1)
   Filter: ((modulo > '0'::numeric) AND ((annoaccademico)::text = '2010/2011'::text) AND (id_facolta = 7))
   Rows Removed by Filter: 66718
 Planning Time: 0.884 ms
 Execution Time: 36.399 ms
(5 rows)

CREATE INDEX
ANALYZE
                                                           QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on inserogato  (cost=603.01..2846.58 rows=856 width=7) (actual time=6.125..14.841 rows=1299 loops=1)
   Recheck Cond: ((modulo > '0'::numeric) AND ((annoaccademico)::text = '2010/2011'::text) AND (id_facolta = 7))
   Heap Blocks: exact=766
   ->  Bitmap Index Scan on inserogato_idx_1  (cost=0.00..602.79 rows=856 width=0) (actual time=5.818..5.818 rows=1299 loops=1)
         Index Cond: ((modulo > '0'::numeric) AND ((annoaccademico)::text = '2010/2011'::text) AND (id_facolta = 7))
 Planning Time: 0.408 ms
 Execution Time: 15.013 ms
(7 rows)

DROP INDEX
ANALYZE
```

### Esercizio 6

Visualizzare il `nome` e il discriminante (attributo `descrizione` della tabella
`Discriminante`) degli insegnamenti erogati nel `2009/2010` che non sono moduli e
che hanno 3, 5 o 12 crediti.

```sql
explain analyze select insegn.nomeins, discriminante.descrizione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
where inserogato.annoaccademico = '2009/2010'
  and inserogato.modulo = 0
  and inserogato.crediti in (3, 5, 12);

create index inserogato_idx on inserogato (annoaccademico, modulo, crediti, id_discriminante, id_insegn);
analyze inserogato;

explain analyze select insegn.nomeins, discriminante.descrizione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
where inserogato.annoaccademico = '2009/2010'
  and inserogato.modulo = 0
  and inserogato.crediti in (3, 5, 12);

drop index inserogato_idx;
analyze inserogato;
```

```
                                                                  QUERY PLAN
----------------------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=286.86..6696.83 rows=661 width=60) (actual time=7.532..39.720 rows=1058 loops=1)
   Hash Cond: (inserogato.id_insegn = insegn.id)
   ->  Hash Join  (cost=5.06..6405.94 rows=661 width=25) (actual time=0.283..31.869 rows=1058 loops=1)
         Hash Cond: (inserogato.id_discriminante = discriminante.id)
         ->  Seq Scan on inserogato  (cost=0.00..6390.32 rows=1053 width=8) (actual time=0.059..31.189 rows=1058 loops=1)
               Filter: (((annoaccademico)::text = '2009/2010'::text) AND (modulo = '0'::numeric) AND (crediti = ANY ('{3,5,12}'::numeric[])))
               Rows Removed by Filter: 66959
         ->  Hash  (cost=3.36..3.36 rows=136 width=25) (actual time=0.170..0.172 rows=136 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 16kB
               ->  Seq Scan on discriminante  (cost=0.00..3.36 rows=136 width=25) (actual time=0.032..0.084 rows=136 loops=1)
   ->  Hash  (cost=179.69..179.69 rows=8169 width=43) (actual time=7.141..7.142 rows=8169 loops=1)
         Buckets: 8192  Batches: 1  Memory Usage: 675kB
         ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.020..3.189 rows=8169 loops=1)
 Planning Time: 2.134 ms
 Execution Time: 39.901 ms
(15 rows)

CREATE INDEX
ANALYZE
                                                                    QUERY PLAN
---------------------------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=287.28..371.27 rows=656 width=60) (actual time=6.795..9.216 rows=1058 loops=1)
   Hash Cond: (inserogato.id_insegn = insegn.id)
   ->  Hash Join  (cost=5.48..80.45 rows=656 width=25) (actual time=0.324..2.010 rows=1058 loops=1)
         Hash Cond: (inserogato.id_discriminante = discriminante.id)
         ->  Index Only Scan using inserogato_idx on inserogato  (cost=0.42..64.89 rows=1051 width=8) (actual time=0.170..1.265 rows=1058 loops=1)
               Index Cond: ((annoaccademico = '2009/2010'::text) AND (modulo = '0'::numeric) AND (crediti = ANY ('{3,5,12}'::numeric[])))
               Heap Fetches: 0
         ->  Hash  (cost=3.36..3.36 rows=136 width=25) (actual time=0.131..0.133 rows=136 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 16kB
               ->  Seq Scan on discriminante  (cost=0.00..3.36 rows=136 width=25) (actual time=0.015..0.066 rows=136 loops=1)
   ->  Hash  (cost=179.69..179.69 rows=8169 width=43) (actual time=6.454..6.455 rows=8169 loops=1)
         Buckets: 8192  Batches: 1  Memory Usage: 675kB
         ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.007..2.884 rows=8169 loops=1)
 Planning Time: 0.720 ms
 Execution Time: 9.395 ms
(15 rows)

DROP INDEX
ANALYZE
```

### Esercizio 7

Visualizzare il `nome` e il `discriminante` degli insegnamenti erogati nel `2008/2009`
senza moduli e con crediti maggiore di 9.

```sql
explain analyze select insegn.nomeins, discriminante.descrizione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
where inserogato.annoaccademico = '2008/2009'
  and inserogato.crediti > 9
  and inserogato.hamoduli = '0';

create index inserogato_idx on inserogato (annoaccademico, crediti, hamoduli, id_insegn, id_discriminante);
analyze inserogato;

explain analyze select insegn.nomeins, discriminante.descrizione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
where inserogato.annoaccademico = '2008/2009'
  and inserogato.crediti > 9
  and inserogato.hamoduli = '0';

drop index inserogato_idx;
analyze inserogato;
```

```
                                                           QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=286.86..6603.84 rows=393 width=60) (actual time=6.828..36.809 rows=1081 loops=1)
   Hash Cond: (inserogato.id_insegn = insegn.id)
   ->  Hash Join  (cost=5.06..6316.63 rows=393 width=25) (actual time=0.250..29.785 rows=1081 loops=1)
         Hash Cond: (inserogato.id_discriminante = discriminante.id)
         ->  Seq Scan on inserogato  (cost=0.00..6305.30 rows=625 width=8) (actual time=0.050..29.138 rows=1081 loops=1)
               Filter: ((crediti > '9'::numeric) AND ((annoaccademico)::text = '2008/2009'::text) AND (hamoduli = '0'::bpchar))
               Rows Removed by Filter: 66936
         ->  Hash  (cost=3.36..3.36 rows=136 width=25) (actual time=0.158..0.159 rows=136 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 16kB
               ->  Seq Scan on discriminante  (cost=0.00..3.36 rows=136 width=25) (actual time=0.026..0.086 rows=136 loops=1)
   ->  Hash  (cost=179.69..179.69 rows=8169 width=43) (actual time=6.488..6.489 rows=8169 loops=1)
         Buckets: 8192  Batches: 1  Memory Usage: 675kB
         ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.016..2.864 rows=8169 loops=1)
 Planning Time: 1.761 ms
 Execution Time: 36.981 ms
(15 rows)

CREATE INDEX
ANALYZE
                                                                    QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=287.28..337.51 rows=387 width=60) (actual time=6.819..8.282 rows=1081 loops=1)
   Hash Cond: (inserogato.id_insegn = insegn.id)
   ->  Hash Join  (cost=5.48..50.38 rows=387 width=25) (actual time=0.460..1.498 rows=1081 loops=1)
         Hash Cond: (inserogato.id_discriminante = discriminante.id)
         ->  Index Only Scan using inserogato_idx on inserogato  (cost=0.42..39.13 rows=618 width=8) (actual time=0.299..0.995 rows=1081 loops=1)
               Index Cond: ((annoaccademico = '2008/2009'::text) AND (crediti > '9'::numeric) AND (hamoduli = '0'::bpchar))
               Heap Fetches: 0
         ->  Hash  (cost=3.36..3.36 rows=136 width=25) (actual time=0.141..0.142 rows=136 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 16kB
               ->  Seq Scan on discriminante  (cost=0.00..3.36 rows=136 width=25) (actual time=0.017..0.076 rows=136 loops=1)
   ->  Hash  (cost=179.69..179.69 rows=8169 width=43) (actual time=6.343..6.343 rows=8169 loops=1)
         Buckets: 8192  Batches: 1  Memory Usage: 675kB
         ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.007..2.865 rows=8169 loops=1)
 Planning Time: 0.740 ms
 Execution Time: 8.406 ms
(15 rows)

DROP INDEX
ANALYZE
```

### Esercizio 8

Visualizzare in ordine alfabetico di nome degli insegnamenti (esclusi di moduli e le
unità logistiche) erogati nel `2013/2014` nel corso di `'Laurea in Informatica'`,
riportando il `nome`, il `discriminante`, i `crediti` e gli `anni di erogazione`.

```sql
explain analyze select
  insegn.nomeins,
  discriminante.descrizione,
  inserogato.crediti,
  inserogato.annierogazione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.modulo = 0
  and inserogato.annoaccademico = '2013/2014'
  and corsostudi.nome = 'Laurea in Informatica'
order by insegn.nomeins;

create index inserogato_idx on inserogato (modulo, annoaccademico, id_insegn, id_discriminante, id_corsostudi);
create index corsostudi_idx on corsostudi (nome);
analyze inserogato;
analyze corsostudi;

explain analyze select
  insegn.nomeins,
  discriminante.descrizione,
  inserogato.crediti,
  inserogato.annierogazione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.modulo = 0
  and inserogato.annoaccademico = '2013/2014'
  and corsostudi.nome = 'Laurea in Informatica'
order by insegn.nomeins;

drop index inserogato_idx;
drop index corsostudi_idx;
analyze inserogato;
analyze corsostudi;
```

```
                                                                 QUERY PLAN
---------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=6493.16..6493.17 rows=3 width=69) (actual time=38.784..38.789 rows=24 loops=1)
   Sort Key: insegn.nomeins
   Sort Method: quicksort  Memory: 26kB
   ->  Hash Join  (cost=6282.71..6493.14 rows=3 width=69) (actual time=37.358..38.692 rows=24 loops=1)
         Hash Cond: (inserogato.id_discriminante = discriminante.id)
         ->  Hash Join  (cost=6277.65..6488.03 rows=5 width=52) (actual time=37.095..38.423 rows=24 loops=1)
               Hash Cond: (insegn.id = inserogato.id_insegn)
               ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.013..0.652 rows=8169 loops=1)
               ->  Hash  (cost=6277.59..6277.59 rows=5 width=17) (actual time=36.872..36.873 rows=24 loops=1)
                     Buckets: 1024  Batches: 1  Memory Usage: 10kB
                     ->  Nested Loop  (cost=0.00..6277.59 rows=5 width=17) (actual time=3.626..36.833 rows=24 loops=1)
                           Join Filter: (inserogato.id_corsostudi = corsostudi.id)
                           Rows Removed by Join Filter: 2883
                           ->  Seq Scan on corsostudi  (cost=0.00..98.94 rows=1 width=4) (actual time=0.010..0.323 rows=1 loops=1)
                                 Filter: ((nome)::text = 'Laurea in Informatica'::text)
                                 Rows Removed by Filter: 634
                           ->  Seq Scan on inserogato  (cost=0.00..6135.26 rows=3472 width=21) (actual time=0.098..35.759 rows=2907 loops=1)
                                 Filter: ((modulo = '0'::numeric) AND ((annoaccademico)::text = '2013/2014'::text))
                                 Rows Removed by Filter: 65110
         ->  Hash  (cost=3.36..3.36 rows=136 width=25) (actual time=0.227..0.228 rows=136 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 16kB
               ->  Seq Scan on discriminante  (cost=0.00..3.36 rows=136 width=25) (actual time=0.041..0.135 rows=136 loops=1)
 Planning Time: 2.177 ms
 Execution Time: 38.973 ms
(24 rows)

CREATE INDEX
CREATE INDEX
ANALYZE
ANALYZE
                                                                         QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=389.26..389.27 rows=4 width=68) (actual time=2.575..2.581 rows=24 loops=1)
   Sort Key: insegn.nomeins
   Sort Method: quicksort  Memory: 26kB
   ->  Hash Join  (cost=178.85..389.22 rows=4 width=68) (actual time=0.908..2.538 rows=24 loops=1)
         Hash Cond: (insegn.id = inserogato.id_insegn)
         ->  Seq Scan on insegn  (cost=0.00..179.69 rows=8169 width=43) (actual time=0.006..0.793 rows=8169 loops=1)
         ->  Hash  (cost=178.80..178.80 rows=4 width=33) (actual time=0.719..0.722 rows=24 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 10kB
               ->  Hash Join  (cost=5.75..178.80 rows=4 width=33) (actual time=0.156..0.715 rows=24 loops=1)
                     Hash Cond: (inserogato.id_discriminante = discriminante.id)
                     ->  Nested Loop  (cost=0.69..173.68 rows=6 width=16) (actual time=0.094..0.645 rows=24 loops=1)
                           ->  Index Scan using corsostudi_idx on corsostudi  (cost=0.28..8.29 rows=1 width=4) (actual time=0.034..0.034 rows=1 loops=1)
                                 Index Cond: ((nome)::text = 'Laurea in Informatica'::text)
                           ->  Index Scan using inserogato_idx on inserogato  (cost=0.42..165.30 rows=9 width=20) (actual time=0.056..0.592 rows=24 loops=1)
                                 Index Cond: ((modulo = '0'::numeric) AND ((annoaccademico)::text = '2013/2014'::text) AND (id_corsostudi = corsostudi.id))
                     ->  Hash  (cost=3.36..3.36 rows=136 width=25) (actual time=0.057..0.058 rows=136 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 16kB
                           ->  Seq Scan on discriminante  (cost=0.00..3.36 rows=136 width=25) (actual time=0.006..0.029 rows=136 loops=1)
 Planning Time: 0.532 ms
 Execution Time: 2.627 ms
(20 rows)

DROP INDEX
DROP INDEX
ANALYZE
ANALYZE
```

### Esercizio 9

Trovare il massimo numero di crediti degli insegnamenti erogati dall'ateneo
nell'a.a. `2013/2014`.

```sql
explain analyze select max(inserogato.crediti)
from inserogato
where inserogato.annoaccademico = '2013/2014';

create index inserogato_idx on inserogato(annoaccademico, crediti);
analyze inserogato;

explain analyze select max(inserogato.crediti)
from inserogato
where inserogato.annoaccademico = '2013/2014';

drop index inserogato_idx;
analyze inserogato;
```

```
                                                     QUERY PLAN
--------------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=5978.24..5978.25 rows=1 width=32) (actual time=34.136..34.137 rows=1 loops=1)
   ->  Seq Scan on inserogato  (cost=0.00..5965.21 rows=5212 width=5) (actual time=0.112..32.246 rows=5155 loops=1)
         Filter: ((annoaccademico)::text = '2013/2014'::text)
         Rows Removed by Filter: 62862
 Planning Time: 0.829 ms
 Execution Time: 34.305 ms
(6 rows)

CREATE INDEX
ANALYZE
                                                                         QUERY PLAN
------------------------------------------------------------------------------------------------------------------------------------------------------------
 Result  (cost=0.46..0.47 rows=1 width=32) (actual time=0.053..0.054 rows=1 loops=1)
   InitPlan 1 (returns $0)
     ->  Limit  (cost=0.42..0.46 rows=1 width=4) (actual time=0.049..0.050 rows=1 loops=1)
           ->  Index Only Scan Backward using inserogato_idx on inserogato  (cost=0.42..207.88 rows=5385 width=4) (actual time=0.048..0.048 rows=1 loops=1)
                 Index Cond: ((annoaccademico = '2013/2014'::text) AND (crediti IS NOT NULL))
                 Heap Fetches: 0
 Planning Time: 0.205 ms
 Execution Time: 0.075 ms
(8 rows)

DROP INDEX
ANALYZE
```

### Esercizio 10

Trovare, per ogni anno accademico, il massimo e il minimo numero di crediti erogati
in un insegnamento.

```sql
explain analyze select
  inserogato.annoaccademico,
  min(inserogato.crediti) as mincrediti,
  max(inserogato.crediti) as maxcrediti
from inserogato
group by inserogato.annoaccademico;

create index inserogato_idx on inserogato (annoaccademico, crediti);
analyze inserogato;

explain analyze select
  inserogato.annoaccademico,
  min(inserogato.crediti) as mincrediti,
  max(inserogato.crediti) as maxcrediti
from inserogato
group by inserogato.annoaccademico;

drop index inserogato_idx;
analyze inserogato;
```

```
                                                      QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=6305.30..6305.46 rows=16 width=74) (actual time=54.301..54.305 rows=16 loops=1)
   Group Key: annoaccademico
   Batches: 1  Memory Usage: 24kB
   ->  Seq Scan on inserogato  (cost=0.00..5795.17 rows=68017 width=14) (actual time=0.042..25.658 rows=68017 loops=1)
 Planning Time: 0.708 ms
 Execution Time: 54.639 ms
(6 rows)

CREATE INDEX
ANALYZE
                                                                    QUERY PLAN
---------------------------------------------------------------------------------------------------------------------------------------------------
 GroupAggregate  (cost=0.42..2614.71 rows=16 width=74) (actual time=0.213..27.807 rows=16 loops=1)
   Group Key: annoaccademico
   ->  Index Only Scan using inserogato_idx on inserogato  (cost=0.42..2104.42 rows=68017 width=15) (actual time=0.082..11.115 rows=68017 loops=1)
         Heap Fetches: 0
 Planning Time: 0.292 ms
 Execution Time: 27.845 ms
(6 rows)

DROP INDEX
ANALYZE
```

### Esercizio 11

Trovare il nome dei corsi di studio che non hanno mai erogato insegnamenti che
contengono nel nome la stringa `'matematica'` (usare `ILIKE` invece di `LIKE` per
rendere il test non sensibile alle maiuscole/minuscole).

```sql
explain analyze select corsostudi.nome
from corsostudi
where not exists (
  select 1
  from inserogato
    join insegn on insegn.id = inserogato.id_insegn
  where inserogato.id_corsostudi = corsostudi.id
    and insegn.nomeins ilike '%matematica%'
);

create index inserogato_idx on inserogato (id_insegn, id_corsostudi);
analyze inserogato;

explain analyze select corsostudi.nome
from corsostudi
where not exists (
  select 1
  from inserogato
    join insegn on insegn.id = inserogato.id_insegn
  where inserogato.id_corsostudi = corsostudi.id
    and insegn.nomeins ilike '%matematica%'
);

drop index inserogato_idx;
analyze inserogato;
```

```
                                                         QUERY PLAN                                                         
----------------------------------------------------------------------------------------------------------------------------
 Hash Right Anti Join  (cost=305.49..6357.10 rows=577 width=86) (actual time=44.952..45.010 rows=572 loops=1)
   Hash Cond: (inserogato.id_corsostudi = corsostudi.id)
   ->  Hash Join  (cost=200.20..6251.01 rows=58 width=4) (actual time=13.836..43.739 rows=1044 loops=1)
         Hash Cond: (inserogato.id_insegn = insegn.id)
         ->  Seq Scan on inserogato  (cost=0.00..5795.17 rows=68017 width=8) (actual time=0.053..20.082 rows=68017 loops=1)
         ->  Hash  (cost=200.11..200.11 rows=7 width=4) (actual time=13.707..13.709 rows=59 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 11kB
               ->  Seq Scan on insegn  (cost=0.00..200.11 rows=7 width=4) (actual time=0.025..13.681 rows=59 loops=1)
                     Filter: ((nomeins)::text ~~* '%matematica%'::text)
                     Rows Removed by Filter: 8110
   ->  Hash  (cost=97.35..97.35 rows=635 width=90) (actual time=0.971..0.971 rows=635 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 85kB
         ->  Seq Scan on corsostudi  (cost=0.00..97.35 rows=635 width=90) (actual time=0.032..0.610 rows=635 loops=1)
 Planning Time: 2.494 ms
 Execution Time: 45.221 ms
(15 rows)

CREATE INDEX
ANALYZE
                                                                  QUERY PLAN                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------
 Hash Right Anti Join  (cost=105.58..342.36 rows=577 width=86) (actual time=17.289..17.341 rows=572 loops=1)
   Hash Cond: (inserogato.id_corsostudi = corsostudi.id)
   ->  Nested Loop  (cost=0.29..236.28 rows=58 width=4) (actual time=0.073..16.353 rows=1044 loops=1)
         ->  Seq Scan on insegn  (cost=0.00..200.11 rows=7 width=4) (actual time=0.030..15.586 rows=59 loops=1)
               Filter: ((nomeins)::text ~~* '%matematica%'::text)
               Rows Removed by Filter: 8110
         ->  Index Only Scan using inserogato_idx on inserogato  (cost=0.29..5.06 rows=11 width=8) (actual time=0.008..0.010 rows=18 loops=59)
               Index Cond: (id_insegn = insegn.id)
               Heap Fetches: 0
   ->  Hash  (cost=97.35..97.35 rows=635 width=90) (actual time=0.718..0.718 rows=635 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 85kB
         ->  Seq Scan on corsostudi  (cost=0.00..97.35 rows=635 width=90) (actual time=0.015..0.424 rows=635 loops=1)
 Planning Time: 1.358 ms
 Execution Time: 17.406 ms
(14 rows)

DROP INDEX
ANALYZE
```

### Esercizio 12

Trovare, per ogni anno accademico e per ogni corso di laurea, la somma dei crediti
erogati (esclusi i moduli e le unità logistiche: vedi nota sopra) e il massimo e
minimo numero di crediti degli insegnamenti erogati sempre escludendo i moduli e
le unità logistiche.

```sql
explain analyze select 
  inserogato.annoaccademico,
  corsostudi.nome,
  sum(inserogato.crediti) as sommacrediti,
  min(inserogato.crediti) as mincrediti,
  max(inserogato.crediti) as maxcrediti
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.modulo = 0
group by inserogato.annoaccademico, corsostudi.nome;

create index inserogato_idx on inserogato (modulo, id_corsostudi, crediti, annoaccademico);
analyze inserogato;

explain analyze select 
  inserogato.annoaccademico,
  corsostudi.nome,
  sum(inserogato.crediti) as sommacrediti,
  min(inserogato.crediti) as mincrediti,
  max(inserogato.crediti) as maxcrediti
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.modulo = 0
group by inserogato.annoaccademico, corsostudi.nome;

drop index inserogato_idx;
analyze inserogato;

```

```
                                                         QUERY PLAN                                                          
-----------------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=7270.91..7397.91 rows=10160 width=192) (actual time=71.015..71.610 rows=1587 loops=1)
   Group Key: inserogato.annoaccademico, corsostudi.nome
   Batches: 1  Memory Usage: 1425kB
   ->  Hash Join  (cost=105.29..6699.29 rows=45730 width=101) (actual time=1.191..47.067 rows=46001 loops=1)
         Hash Cond: (inserogato.id_corsostudi = corsostudi.id)
         ->  Seq Scan on inserogato  (cost=0.00..5965.21 rows=45730 width=19) (actual time=0.076..31.661 rows=46001 loops=1)
               Filter: (modulo = '0'::numeric)
               Rows Removed by Filter: 22016
         ->  Hash  (cost=97.35..97.35 rows=635 width=90) (actual time=1.074..1.075 rows=635 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 85kB
               ->  Seq Scan on corsostudi  (cost=0.00..97.35 rows=635 width=90) (actual time=0.015..0.739 rows=635 loops=1)
 Planning Time: 1.537 ms
 Execution Time: 72.387 ms
(13 rows)

CREATE INDEX
ANALYZE
                                                                       QUERY PLAN                                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=3092.71..3219.71 rows=10160 width=192) (actual time=55.936..56.627 rows=1587 loops=1)
   Group Key: inserogato.annoaccademico, corsostudi.nome
   Batches: 1  Memory Usage: 1425kB
   ->  Merge Join  (cost=127.33..2517.60 rows=46009 width=100) (actual time=0.980..23.046 rows=46001 loops=1)
         Merge Cond: (corsostudi.id = inserogato.id_corsostudi)
         ->  Sort  (cost=126.91..128.50 rows=635 width=90) (actual time=0.862..0.943 rows=635 loops=1)
               Sort Key: corsostudi.id
               Sort Method: quicksort  Memory: 98kB
               ->  Seq Scan on corsostudi  (cost=0.00..97.35 rows=635 width=90) (actual time=0.012..0.430 rows=635 loops=1)
         ->  Index Only Scan using inserogato_idx on inserogato  (cost=0.42..1812.40 rows=46009 width=18) (actual time=0.110..13.754 rows=46001 loops=1)
               Index Cond: (modulo = '0'::numeric)
               Heap Fetches: 0
 Planning Time: 0.302 ms
 Execution Time: 56.794 ms
(14 rows)

DROP INDEX
ANALYZE
```
