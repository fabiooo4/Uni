// Esercizio 1
// Creare una collezione museoNoRef ed inserire alcuni documenti usarndo le funzioni insertOne() o insertMany()

conn = db.getMongo();
db = conn.getDB("MuseiVerona");

// Clear the collection if it already exists
db.museoNoRef.drop();

db.museoNoRef.insertMany([
  {
    nome: "Arena",
    citta: "Verona",
    indirizzo: "piazza Bra",
    numeroTelefono: "045 8003204",
    giornoChiusura: "martedì",
    prezzo: 20,
    opere: [
      {
        nome: "L'Abbraccio",
        cognomeAutore: "Domenico",
        nomeAutore: "Foschini",
        epoca: "Rinascimento",
        anno: 1500,
      },
      {
        nome: "La Danza",
        cognomeAutore: "Leonardo",
        nomeAutore: "Da Vinci",
        epoca: "Rinascimento",
        anno: 1505,
      },
    ],
    mostre: [
      {
        titolo: "Rinascimento a Verona",
        inizio: ISODate("2026-01-01"),
        fine: ISODate("2026-06-30"),
        prezzo: 12,
      },
      {
        titolo: "Arte Moderna a Verona",
        inizio: ISODate("2026-03-01"),
        fine: ISODate("2026-08-31"),
        prezzo: 15,
      },
    ],
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
  },
  {
    nome: "CastelVecchio",
    citta: "Verona",
    indirizzo: "Corso Castelvecchio",
    numeroTelefono: "045 594734",
    giornoChiusura: "lunedì",
    prezzo: 15,
    opere: [
      {
        nome: "Il Bacio",
        cognomeAutore: "Giuseppe",
        nomeAutore: "Verdi",
        epoca: "Barocco",
        anno: 1600,
      },
    ],
    mostre: [
      {
        titolo: "Barocco a Verona",
        inizio: ISODate("2026-02-01"),
        fine: ISODate("2026-07-31"),
        prezzo: 10,
      },
    ],
    orari: [
      {
        giorno: "martedì",
        orarioApertura: "09:00 CET",
        orarioChiusura: "19:00 CET",
      },
    ],
  },
]);
