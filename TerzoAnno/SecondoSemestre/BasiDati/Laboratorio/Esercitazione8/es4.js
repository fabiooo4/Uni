// Esercizio 4
// Cercare tutti i musei che sono aperti il martedì oppure il giovedì.
// L’interrogazione su una proprietà innestata avviene nel seguente modo:
// 'orari.giorno': 'Martedì'
// Ricordarsi di usare le virgolette singole per indicare il nome della proprietà innestata.

conn = db.getMongo();
db = conn.getDB("MuseiVerona");

musei = db.museo.find(
  {
    $or: [{ "orari.giorno": "martedì" }, { "orari.giorno": "giovedì" }],
  },
);

console.log(musei);
