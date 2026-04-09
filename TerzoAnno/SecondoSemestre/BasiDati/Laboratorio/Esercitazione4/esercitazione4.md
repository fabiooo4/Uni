# Esercitazione 4

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

Eseguire i seguenti esercizi usando la base di dati did2014, disponibile sul server
PostgreSQL dbserver.scienze.univr.it

- CorsoStudi(**id**, nome, codice, abbreviazione, durataAnni, sede, informativa,
  id_segreteria)
- Facolta(**id**, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria)
- Insegn(**id**, nomeins, codiceins)
- Discriminante(**id**, nome, descrizione)
- InsErogato(**id**, annoaccademico, id_insegn, id_corsostudi, id_discriminante,
  modulo, discriminantemodulo, nomemodulo, crediti, programma, id_facolta, hamoduli,
  id_inserogato_padre, nomeunità, annierogazione)
- CorsoInFacolta(**id**, id_corsostudi, id_facolta)
- Persona(**id**, cognome, nome, sesso, telefono, email)
- Docenza(**id**, id_inserogato, id_persona, id_settore, creditilez, orelez)
- InsInPeriodo(**id**, id_inserogato, id_periodolez)
- PeriodoLez(**id**, abbreviazione)
- PeriodoDid(**id**, annoaccademico, descrizione, discriminante, inizio, fine)
- Lezione(**id**, id_periodolez, id_inserogato, giorno, orainizio, datainizio, orafine,
  datafine)
- StrutturaServizio(**id**, nomestruttura, orarioapertura, telefono1, telefono2, fax,
  email, compiti)

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
  - Le tabelle `PeriodoLez` e `PeriodoDid` fanno parte di una gerarchia (`PeriodoDid`
    è padre di `PeriodoLez`) dove il padre è la tabella `PeriodoDid`, mentre la tabella
    `PeriodoLez` permete di specificare un ulteriore attributo (`abbreviazione`). Il join
    tra le due tabelle viene fatto per uguaglianza rispetto all'attributo `id`.

## Esercizi

### Esercizio 1

Trovare `identificatore`, `cognome` e `nome` dei docenti che, nell'anno accademico
`2010/2011`, hanno tenuto un insegnamento (l'attributo da confrontare è `nomeins`) che
non hanno tenuto nell'anno accademico precedente. Ordinare la soluzione per
`identificatore`.

La soluzione ha 1031 righe. Le 5 a partire dalla 20° riga sono:

| id  | cognome    | nome        |
| --- | ---------- | ----------- |
| 140 | Ferrarini  | Roberto     |
| 142 | Combi      | Carlo       |
| 168 | Rossignoli | Cecilia     |
| 173 | Manca      | Vincenzo    |
| 184 | Bonacina   | Maria Paola |

```sql
select distinct persona.id, persona.cognome, persona.nome
from persona
  join docenza on persona.id = docenza.id_persona
  join inserogato on docenza.id_inserogato = inserogato.id
  join insegn on inserogato.id_insegn = insegn.id
where inserogato.annoaccademico = '2010/2011'
  -- Se non esiste un insegnamento dello stesso nome tenuto
  -- dalla stessa persona nell'anno precedente
  and not exists (
    select 1
    from persona as persona_in
      join docenza as docenza_in on persona_in.id = docenza_in.id_persona
      join inserogato as inserogato_in on docenza_in.id_inserogato = inserogato_in.id
      join insegn as insegn_in on inserogato_in.id_insegn = insegn_in.id
    where inserogato_in.annoaccademico = '2009/2010'
    and persona_in.id = persona.id
    and insegn_in.nomeins = insegn.nomeins
  )
order by persona.id;
```

### Esercizio 2

Trovare i corsi di studio che non sono gestiti dalla facoltà di `'Medicina e Chirurgia'`
e che hanno insegnamenti erogati con moduli nel `2010/2011`. Si visualizzi il `nome` del
corso e il numero di insegnamenti erogati con moduli nel `2010/2011`.

Soluzione: ci sono 33 righe. Le prime 5 ordinate rispetto al nome sono:

| nome                     | numinsegn |
| ------------------------ | --------- |
| Laurea IN Beni culturali | 5         |
| Laurea IN Bioinformatica | 4         |
| Laurea IN Biotecnologie  | 12        |
| Laurea IN Filosofia      | 8         |
| Laurea IN Informatica    | 2         |

```sql
select corsostudi.nome, count(distinct inserogato.id) as numinsegn
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.annoaccademico = '2010/2011'
  and inserogato.hamoduli = '1'
  and inserogato.modulo = 0
  -- Corsi di studio che non sono tra quelli gestiti dalla facoltà di medicina e chirurgia
  and corsostudi.id not in (
    select corsostudi_in.id
    from inserogato as inserogato_in
      join corsostudi as corsostudi_in on inserogato_in.id_corsostudi = corsostudi_in.id
      join corsoinfacolta as corsoinfacolta_in on corsostudi_in.id = corsoinfacolta_in.id_corsostudi
      join facolta as facolta_in on corsoinfacolta_in.id_facolta = facolta_in.id
    where facolta_in.nome = 'Medicina e Chirurgia'
  )
group by corsostudi.nome
order by corsostudi.nome;
```

### Esercizio 3

Trovare gli insegnamenti del corso di studi con `id = 4` che non sono mai stati offerti
al secondo quadrimestre. Per selezionare il secondo quadrimestre usare la condizione
`abbreviazione LIKE '2%'`.

La soluzione ha 14 righe.

```sql
-- Tutti gli insegnamenti
select insegn.nomeins
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
  join insegn on inserogato.id_insegn = insegn.id
where corsostudi.id = 4
except
-- Insegnamenti erogati al secondo semestre
select distinct insegn.nomeins
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
  join insegn on inserogato.id_insegn = insegn.id
  join insinperiodo on inserogato.id = insinperiodo.id_inserogato
  join periodolez on insinperiodo.id_periodolez = periodolez.id
where  corsostudi.id = 4
 and periodolez.abbreviazione like '2%';
```

### Esercizio 4

Trovare il `nome` dei corsi di studio che non hanno mai erogato insegnamenti che
contengono nel nome la stringa `'matematica'` (usare `ILIKE` invece di `LIKE` per
rendere il test non sensibile alle maiuscole/minuscole (case-insensitive)).

La soluzione ha 572 righe.

```sql
-- Tutti i corsi
select corsostudi.nome
from corsostudi

except

-- Corsi che hanno erogato insegnamenti con 'matematica'
select corsostudi.nome
from corsostudi
  join inserogato on corsostudi.id = inserogato.id_corsostudi
  join insegn on inserogato.id_insegn = insegn.id
where insegn.nomeins ilike '%matematica%';
```

### Esercizio 5

Trovare `nome`, `cognome` e `telefono` dei docenti che hanno tenuto nel `2009/2010`
un'occorrenza di insegnamento che non sia un'unità logistica del corso di studi con
`id = 4` ma che non hanno mai tenuto un modulo dell'insegnamento di `'Programmazione'`
del medesimo corso di studi.

La soluzione ha 5 righe:

| nome     | cognome    | telefono         |
| -------- | ---------- | ---------------- |
| Alberto  | Belussi    | 045 802 7980     |
| Vincenzo | Manca      | 045 802 7981     |
| Angelo   | Pica       |                  |
| Graziano | Pravadelli | +39 045 802 7081 |
| Roberto  | Segala     | 045 802 7997     |

```sql
select persona.nome, persona.cognome, persona.telefono
from inserogato
  join docenza on inserogato.id = docenza.id_inserogato
  join persona on docenza.id_persona = persona.id
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where corsostudi.id = 4
  and inserogato.annoaccademico = '2009/2010'
  and inserogato.modulo >= 0

except

select persona.nome, persona.cognome, persona.telefono
from inserogato
  join docenza on inserogato.id = docenza.id_inserogato
  join persona on docenza.id_persona = persona.id
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
  join insegn on inserogato.id_insegn = insegn.id
where corsostudi.id = 4
  and inserogato.annoaccademico = '2009/2010'
  and inserogato.modulo > 0
  and insegn.nomeins = 'Programmazione';
```

### Esercizio 6

Trovare, per ogni facoltà, il numero di unità logistiche erogate (`modulo < 0`) e il
numero corrispondente di crediti totali erogati nel `2010/2011`, riportando il `nome`
della facoltà e i conteggi richiesti. Usare pure la relazione diretta tra `InsErogato`
e `Facolta`.

La soluzione ha 8 righe. La riga relativa a 'Medicina e Chirurgia' ha valori 253 e 979,50.

```sql
select facolta.nome, count(inserogato.id), sum(inserogato.crediti)
from inserogato
  join facolta on inserogato.id_facolta = facolta.id
where inserogato.modulo < 0
  and inserogato.annoaccademico = '2010/2011'
group by facolta.nome;
```

### Esercizio 7

Trovare, per ogni facoltà, il docente che ha tenuto il numero massimo di ore di
lezione nel `2009/2010`, riportando il `cognome` e il `nome` del docente e la facoltà.
Per la relazione tra `InsErogato` e `Facolta` usare la relazione diretta.

La soluzione ha 10 righe.

| cognome          | nome          | facolta                                | oretot  |
| ---------------- | ------------- | -------------------------------------- | ------- |
| Babbi            | Anna Maria    | Lingue e letterature straniere         | 144.000 |
| Bartolozzi       | Pietro        | Medicina e Chirurgia                   | 411.000 |
| Battistelli      | Adalgisa      | Scienze motorie                        | 144.000 |
| Brunetti         | Federico      | Economia                               | 202.000 |
| De Lotto         | Cinzia        | Lingue e letterature straniere         | 144.000 |
| Pedrazza Gorlero | Maurizio      | Giurisprudenza                         | 158.000 |
| Peruzzi          | Enrico        | Lettere e filosofia                    | 150.000 |
| Pescatori        | Sergio        | Lingue e letterature straniere         | 144.000 |
| Sala             | Gabriel Maria | Scienze della formazione               | 245.000 |
| Spera            | Mauro         | Scienze matematiche fisiche e naturali | 169.000 |

```sql
-- SBAGLIATO
select persona.nome, persona.cognome, facolta.nome, sum(docenza.orelez) as oretot
from inserogato
  join docenza on inserogato.id = docenza.id_inserogato
  join persona on docenza.id_persona = persona.id
  join facolta on inserogato.id_facolta = facolta.id
where inserogato.annoaccademico = '2009/2010'
group by persona.nome, persona.cognome, facolta.nome, facolta.id
having sum(docenza.orelez) = any (
    select max(docenza_in.orelez)
    from inserogato as inserogato_in
      join docenza as docenza_in on inserogato_in.id = docenza_in.id_inserogato
      join facolta as facolta_in on inserogato_in.id_facolta = facolta_in.id
    where inserogato_in.annoaccademico = '2009/2010'
      and facolta_in.id = facolta.id
  )
```

### Esercizio 8

Trovare gli insegnamenti (esclusi i moduli e le unità logistiche) del corso di studi con id=240 erogati nel
2009/2010 e nel 2010/2011 che hanno avuto almeno un docente ma che non hanno avuto docenti di
nome 'Roberto', 'Alberto', 'Massimo' o 'Luca' in entrambi gli anni accademici, riportando il nome, il
discriminante dell'insegnamento, ordinati per nome insegnamento.

La soluzione ha 22 righe. Le cinque a partire dalla XV riga sono

| nomeins                                                    | discriminante |
| ---------------------------------------------------------- | ------------- |
| Medicina interna (V anno )                                 | -             |
| Patologia e clinica delle endocrinopatie (IV anno )        | -             |
| Patologia e clinica delle endocrinopatie (V anno )         | -             |
| Patologia e clinica delle malattie del ricambio (IV anno ) | -             |
| Patologia e clinica delle malattie del ricambio (V anno )  | -             |

### Esercizio 9

Trovare le unità logistiche del corso di studi con id=420 erogati nel 2010/2011 e che hanno lezione o
il lunedì (Lezione.giorno=2) o il martedì (Lezione.giorno=3), ma non in entrambi i giorni, riportando
il nomedell'insegnamento e il nome dell'unità ordinate per nome insegnamento.

La soluzione ha 8 righe:

| nomeins                        | nomeunita   |
| ------------------------------ | ----------- |
| Algoritmi                      | Teoria      |
| Architettura degli elaboratori | Laboratorio |
| Architettura degli elaboratori | Teoria      |
| Basi di dati                   | Laboratorio |
| Programmazione I               | Laboratorio |
| Programmazione I               | Teoria      |
| Sistemi operativi              | Laboratorio |
| Sistemi operativi              | Teoria      |

### Esercizio 10

Trovare gli insegnamenti in ordine alfabetico (esclusi moduli e unità logistiche) dei corsi di studi della
facoltà di 'Scienze Matematiche Fisiche e Naturali' che sono stati tenuti dallo stesso docente per due anni
accademici consecutivi riportando id, nome dell'insegnamento e id, nome, cognome del docente. Per la
relazione tra InsErogato e Facolta non usare la relazione diretta. Circa la condizione sull'anno
accademico, dopo aver estratto una sua opportuna parte, si può trasformare questa in un intero e, quindi,
usarlo per gli opportuni controlli. Oppure si può usarla direttamente confrontandola con un'opportuna
parte dell'altro anno accademico.

La soluzione ha 544 righe. Le ultime 5 sono:
| id | ?? | ?? | ?? | ??|
| ---- | -- |----|----|------------------------------------- |
| 321 | Viticoltura III | 119 | Claudio | Giulivo|
| 4068 | Viticoltura e territorio | 3937 | Maurizio | Boselli|
| 4087 | Viticoltura generale | 3937 | Maurizio | Boselli|
| 5648 | Web semantico | 62 | Matteo | Cristani|
| 322 | Zonazione vinicola | 186 | Francesco | Morari|

### Esercizio 11

Trovare per ogni docente il numero di insegnamenti o moduli o unità logistiche a lui assegnate come
docente
nell'anno accademico 2005/2006, riportare anche coloro che non hanno assegnato alcun insegnamento.
Nel risultato si mostri identificatore, nome e cognome del docente insieme al conteggio richiesto (0 per il
caso nessun insegnamento/modulo/unità insegnati).

La soluzione ha 3315 righe.
