# Esercitazione 3

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
  - [Esercizio 13](#esercizio-13)
  - [Esercizio 14](#esercizio-14)
  - [Esercizio 15](#esercizio-15)
  - [Esercizio 16](#esercizio-16)
  - [Esercizio 17](#esercizio-17)
  - [Esercizio 18](#esercizio-18)

Si considerino le seguenti tabelle (grassetto per le chiavi primarie), presenti
nella base di dati did2014 nel database di UniVR:

- CorsoStudi(**id**, nome, codice, abbreviazione, durataAnni, sede, informativa)
- Facolta(**id**, nome, codice, indirizzo, informativa, id_preside_persona, id_segreteria)
- Insegn(**id**, nomeins, codiceins)
- Discriminante(**id**, nome, descrizione)
- InsErogato(**id**, annoaccademico, id_insegn, id_corsostudi, id_discriminante, modulo,
  discriminantemodulo, nomemodulo, crediti, programma, id_facolta, hamoduli,
  id_inserogato_padre, nomeunità, annierogazione)
- CorsoInFacolta(**id**, id_corsostudi, id_facolta)

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

Visualizzare il numero di corso studi presenti nella base di dati.

```sql
select count(*)
from corsostudi;
```

Soluzione: ci sono 635 corsi di studio.

### Esercizio 2

Visualizzare il nome, il codice, l'indirizzo e l'identificatore del preside di tutte
le facoltà.

```sql
select nome, codice, indirizzo, id_preside_persona
from facolta;
```

Soluzione: ci sono 8 facoltà.

### Esercizio 3

Trovare per ogni corso di studi che ha erogato insegnamenti nel 2010/2011 il suo nome
e il nome delle facoltà che lo gestiscono (si noti che un corso può essere gestito da
più facoltà). Non usare la relazione diretta tra InsErogato e Facoltà. Porre i
risultati in ordine di nome corso studi.

Soluzione: ci sono 211 righe. Le 5 righe dalla 10° posizione sono:

| nome                                                         | nome                                   |
| ------------------------------------------------------------ | -------------------------------------- |
| Corso di Perfezionamento in Traumatologia dentale            | Medicina e Chirurgia                   |
| Laurea in Beni culturali                                     | Lettere e filosofia                    |
| Laurea in Bioinformatica                                     | Scienze matematiche fisiche e naturali |
| Laurea in Bioinformatica (ordinamento fino ALL'a.a. 2008/09) | Scienze matematiche fisiche e naturali |
| Laurea in Biotecnologie                                      | Scienze matematiche fisiche e naturali |

```sql
select distinct corsostudi.nome, facolta.nome
from corsoinfacolta
  join corsostudi on (corsostudi.id = corsoinfacolta.id_corsostudi)
  join facolta on (facolta.id = corsoinfacolta.id_facolta)
  join inserogato on (inserogato.id_corsostudi = corsostudi.id)
where inserogato.annoaccademico = '2010/2011'
order by corsostudi.nome;
```

### Esercizio 4

Visualizzare il nome, il codice e l'abbreviazione di tutti i corsi di studio gestiti
dalla facoltà di Medicina e Chirurgia.

Soluzione: ci sono 236 righe.

```sql
select corsostudi.nome, corsostudi.codice, corsostudi.abbreviazione
from corsoinfacolta
  join corsostudi on (corsoinfacolta.id_corsostudi = corsostudi.id)
  join facolta on (corsoinfacolta.id_facolta = facolta.id)
where facolta.nome = 'Medicina e Chirurgia';
```

### Esercizio 5

Visualizzare il codice, il nome e l'abbreviazione di tutti corsi di studio che nel
nome contengono la sottostringa 'lingue' (eseguire il confronto usando ILIKE invece di
LIKE: in questo modo i caratteri maiuscolo e minuscolo non sono diversi).

Soluzione: ci sono 16 righe.

```sql
select corsostudi.codice, corsostudi.nome, corsostudi.abbreviazione
from corsostudi
where corsostudi.nome ilike '%lingue%';
```

### Esercizio 6

Visualizzare le sedi dei corsi di studi in un elenco senza duplicati.

Soluzione: ci sono 48 righe.

```sql
select distinct corsostudi.sede
from corsostudi;
```

### Esercizio 7

Visualizzare solo i moduli degli insegnamenti erogati nel 2010/2011 nei corsi di studi
della facoltà di Economia.

Si visualizzi il nome dell'insegnamento, il discriminante (attributo descrizione della
tabella Discriminante), il nome del modulo e l'attributo modulo.

Soluzione: ci sono 27 righe.

```sql
select insegn.nomeins, discriminante.descrizione, inserogato.nomemodulo, inserogato.modulo
from inserogato
  join insegn on insegn.id = inserogato.id_insegn
  join discriminante on discriminante.id = inserogato.id_discriminante
  join corsoinfacolta on corsoinfacolta.id_corsostudi = inserogato.id_corsostudi
  join facolta on facolta.id = corsoinfacolta.id_facolta
where inserogato.annoaccademico = '2010/2011'
  and facolta.nome = 'Economia'
  and inserogato.modulo > 0;
```

### Esercizio 8

Visualizzare il nome e il discriminante (attributo descrizione della tabella
Discriminante) degli insegnamenti erogati nel 2009/2010 che non sono moduli o unità
logistiche e che hanno 3, 5 o 12 crediti. Si ordini il risultato per discriminante.

Soluzione: ci sono 724 righe distinte. Le ultime 5 righe sono:

| nomeins                              | discriminante |
| ------------------------------------ | ------------- |
| Prova finale                         | CInt          |
| Laboratorio di composizione italiana | Cognomi A-K   |
| Biologia                             | Cognomi A-L   |
| Laboratorio di composizione italiana | Cognomi L-Z   |
| Biologia                             | Cognomi M-Z   |

```sql
select distinct insegn.nomeins, discriminante.descrizione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
where inserogato.annoaccademico = '2009/2010'
  and inserogato.modulo = 0
  and inserogato.crediti in (3, 5, 12)
order by discriminante.descrizione;
```

### Esercizio 9

Visualizzare l'identificatore, il nome e il discriminante degli insegnamenti erogati
nel 2008/2009 che non sono moduli o unità logistiche e con peso maggiore di 9 crediti.
Ordinare per nome.

Soluzione: ci sono 1218 righe. Le 5 righe dalla 1023° riga sono:

| id    | nomeins                                | discriminante     |
| ----- | -------------------------------------- | ----------------- |
| 39872 | Storia del diritto medievale e moderno | Matricole pari    |
| 44440 | Storia del diritto medievale e moderno | Matricole dispari |
| 39724 | Storia del diritto medievale e moderno | Matricole pari    |
| 44428 | Storia del diritto medievale e moderno | Matricole dispari |
| 44441 | Storia del diritto medievale e moderno | Matricole dispari |

```sql
select inserogato.id, insegn.nomeins, discriminante.descrizione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
where inserogato.annoaccademico = '2008/2009'
  and inserogato.modulo = 0
  and inserogato.crediti > 9
order by insegn.nomeins;
```

### Esercizio 10

Visualizzare in ordine alfabetico di nome degli insegnamenti (esclusi i moduli e le
unità logistiche) erogati nel 2010/2011 nel corso di studi in Informatica, riportando
il nome, il discriminante, i crediti e gli anni di erogazione.

Soluzione: ci sono 26 righe.

```sql
select insegn.nomeins,
  discriminante.descrizione,
  inserogato.crediti,
  inserogato.annierogazione
from inserogato
  join insegn on inserogato.id_insegn = insegn.id
  join discriminante on inserogato.id_discriminante = discriminante.id
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.annoaccademico = '2010/2011'
  and inserogato.modulo = 0
  and corsostudi.nome = 'Laurea in Informatica'
order by insegn.nomeins;
```

### Esercizio 11

Trovare il massimo numero di crediti associato a un insegnamento fra quelli erogati
nel 2010/2011.

Soluzione: 180.

```sql
select max(inserogato.crediti)
from inserogato
where inserogato.annoaccademico = '2010/2011';
```

### Esercizio 12

Trovare, per ogni anno accademico, il massimo e il minimo numero di crediti erogati
tra gli insegnamenti dell'anno.

Soluzione: ci sono 16 righe.

```sql
select inserogato.annoaccademico,
  max(inserogato.crediti),
  min(inserogato.crediti)
from inserogato
group by inserogato.annoaccademico;
```

### Esercizio 13

Trovare, per ogni anno accademico e per ogni corso di studi la somma dei crediti
erogati (esclusi i moduli e le unità logistiche: vedi nota sopra) e il massimo e
minimo numero di crediti degli insegnamenti erogati sempre escludendo i moduli e le
unità logistiche.

Soluzione: ci sono 1587 righe. La riga relativa alla "Scuola di
Specializzazione in Urologia (Vecchio ordinamento)" nell'anno 2011/2012 ha valori
52.00, 10.00 e 162.00.

```sql
select inserogato.annoaccademico,
  corsostudi.nome,
  max(inserogato.crediti),
  min(inserogato.crediti),
  sum(inserogato.crediti)
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.modulo = 0
group by inserogato.annoaccademico, corsostudi.nome;
```

### Esercizio 14

Trovare per ogni corso di studi della facoltà di Scienze Matematiche Fisiche e
Naturali il numero di insegnamenti (esclusi i moduli e le unità logistiche) erogati
nel 2009/2010.

Soluzione: ci sono 19 righe.

```sql
select corsostudi.nome, count(inserogato.id) as numinsegnamenti
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
  join corsoinfacolta on inserogato.id_corsostudi = corsoinfacolta.id_corsostudi
  join facolta on corsoinfacolta.id_facolta = facolta.id
where facolta.nome = 'Scienze matematiche fisiche e naturali'
  and inserogato.annoaccademico = '2009/2010'
  and inserogato.modulo = 0
group by corsostudi.nome;
```

### Esercizio 15

Trovare i corsi di studi che nel 2010/2011 hanno erogato insegnamenti con un numero di
crediti pari a 4 o 6 o 8 o 10 o 12 o un numero di crediti di laboratorio tra 10 e 15
escluso, riportando il nome del corso di studi e la sua durata. Si ricorda che i
crediti di laboratorio sono rappresentati dall'attributo creditilab della tabella
InsErogato.

Soluzione: ci sono 197 righe.

```sql
select distinct corsostudi.nome, corsostudi.durataanni
from inserogato
  join corsostudi on inserogato.id_corsostudi = corsostudi.id
where inserogato.annoaccademico = '2010/2011'
  and (
        inserogato.crediti in (4, 6, 8, 10, 12)
        or inserogato.creditilab between 10 and 15
      );
```

### Esercizio 16

Trovare nome, cognome dei docenti che nell'anno accademico 2010/2011 erano docenti in
almeno due corsi di studio (vale a dire erano docenti in almeno due insegnamenti o
moduli A e B dove A è del corso C1 e B è del corso C2 con C1 <> C2).

La soluzione ha 839 righe. Se si ordina la risposta per un opportuno attributo, le 5
righe a partire dalla 50° sono:

| id  | nome       | cognome |
| --- | ---------- | ------- |
| 268 | Paolo      | Roffia  |
| 269 | Andrea     | Lionzo  |
| 270 | Corrado    | Corsi   |
| 278 | Alessandro | Lai     |
| 280 | Giuseppe   | Ceriani |

```sql
select distinct persona.id, persona.nome, persona.cognome
from inserogato
  join docenza on inserogato.id = docenza.id_inserogato
  join persona on docenza.id_persona = persona.id
where inserogato.annoaccademico = '2010/2011'
group by persona.id, persona.nome, persona.cognome
having count(distinct docenza.id_inserogato) > 1
  and count(distinct inserogato.id_corsostudi) > 1
order by persona.id;
```

### Esercizio 17

Trovare per ogni periodo di lezione del 2010/2011 la cui descrizione inizia con
'I semestre' o 'Primo semestre' il numero di occorrenze di insegnamento allocate in
quel periodo. Si visualizzi quindi: l'abbreviazione, il discriminante, inizio, fine e
il conteggio richiesto ordinati rispetto all'inizio e fine.

La soluzione ha 3 righe:

| abbreviazione  | discriminante  | inizio       | fine         | insprimosem |
| -------------- | -------------- | ------------ | ------------ | ----------- |
| Primo semestre | eco            | 2010 -10 -04 | 2010 -12 -22 | 104         |
| Primo semestre | Primo semestre | 2010 -10 -04 | 2011 -01 -22 | 124         |
| I semestre     | I semestre     | 2010 -10 -04 | 2011 -01 -31 | 159         |

```sql
select periodolez.abbreviazione,
  periododid.discriminante,
  periododid.inizio,
  periododid.fine,
  count(inserogato.id)
from periododid
  join periodolez on periododid.id = periodolez.id
  join insinperiodo on periodolez.id = insinperiodo.id_periodolez
  join inserogato on insinperiodo.id_inserogato = inserogato.id
where periododid.annoaccademico = '2010/2011'
  and (
        periododid.descrizione like 'I semestre'
        or periododid.descrizione like 'Primo semestre'
      )
group by (
  periodolez.abbreviazione,
  periododid.discriminante,
  periododid.inizio,
  periododid.fine
)
order by periododid.inizio, periododid.fine;
```

### Esercizio 18

Trovare per ogni segreteria che serve almeno un corso di studi il numero di corsi di
studi serviti, riportando il nome della struttura, il suo numero di fax e il conteggio
richiesto.

La soluzione ha 42 righe.

```sql
select strutturaservizio.nomestruttura,
  strutturaservizio.fax,
  count(corsostudi.id)
from strutturaservizio
  join corsostudi on strutturaservizio.id = corsostudi.id_segreteria
group by strutturaservizio.nomestruttura, strutturaservizio.fax;
```
