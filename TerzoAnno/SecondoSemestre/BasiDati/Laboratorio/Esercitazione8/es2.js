// Esercizio 2
// Creare una collezione museo equivalente alla precedente, in cui però le proprietà opere e
// mostre usano riferimenti tramite ObjectId(‘…’) a documenti presenti in altre due collezioni
// Opera e Mostra

conn = db.getMongo();
db = conn.getDB("MuseiVerona");

// Clear the collection if it already exists
db.opera.drop();
db.mostra.drop();
db.museo.drop();

museoArena = db.museo.insertOne({
  nome: "Arena",
  citta: "Verona",
  indirizzo: "piazza Bra",
  numeroTelefono: "045 8003204",
  giornoChiusura: "martedì",
  prezzo: 20,
  orari: [
    {
      giorno: "lunedì",
      orarioApertura: "13:00 CET",
      orarioChiusura: "19:00 CET",
    },
    {
      giorno: "mercoledì",
      orarioApertura: "09:00 CET",
      orarioChiusura: "19:00 CET",
    },
  ],
});

museoCastelvecchio = db.museo.insertOne({
  nome: "CastelVecchio",
  citta: "Verona",
  indirizzo: "Corso Castelvecchio",
  numeroTelefono: "045 594734",
  giornoChiusura: "lunedì",
  prezzo: 15,
  orari: [
    {
      giorno: "martedì",
      orarioApertura: "09:00 CET",
      orarioChiusura: "19:00 CET",
    },
  ],
});

opereArena = db.opera.insertMany([
  {
    idMuseo: museoArena.insertedId,
    nome: "L'Abbraccio",
    cognomeAutore: "Domenico",
    nomeAutore: "Foschini",
    epoca: "Rinascimento",
    anno: 1500,
  },
  {
    idMuseo: museoArena.insertedId,
    nome: "La Danza",
    cognomeAutore: "Leonardo",
    nomeAutore: "Da Vinci",
    epoca: "Rinascimento",
    anno: 1505,
  },
]);

mostreArena = db.mostra.insertMany([
  {
    idMuseo: museoArena.insertedId,
    titolo: "Rinascimento a Verona",
    inizio: ISODate("2026-01-01"),
    fine: ISODate("2026-06-30"),
    prezzo: 12,
  },
  {
    idMuseo: museoArena.insertedId,
    titolo: "Arte Moderna a Verona",
    inizio: ISODate("2026-03-01"),
    fine: ISODate("2026-08-31"),
    prezzo: 15,
  },
]);

opereCastelvecchio = db.opera.insertOne({
  idMuseo: museoCastelvecchio.insertedId,
  nome: "Il Bacio",
  cognomeAutore: "Giuseppe",
  nomeAutore: "Verdi",
  epoca: "Barocco",
  anno: 1600,
});

mostreCastelvecchio = db.mostra.insertOne({
  idMuseo: museoCastelvecchio.insertedId,
  titolo: "Barocco a Verona",
  inizio: ISODate("2026-02-01"),
  fine: ISODate("2026-07-31"),
  prezzo: 10,
});
