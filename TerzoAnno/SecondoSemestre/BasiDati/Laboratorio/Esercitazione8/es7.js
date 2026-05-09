// Esercizio 7
// Utilizzare l’operatore di lookup per eseguire un join tra ciascun documento Museo ed i
// corrispondenti documenti Mostra e Opera.
// Selezionare solo i musei di Verona.

conn = db.getMongo();
db = conn.getDB("MuseiVerona");
today = new Date("2026-02-01");

musei = db.museo.aggregate([
  {
    $lookup: {
      from: "mostra",
      localField: "_id",
      foreignField: "idMuseo",
      as: "mostre",
    },
  },
  {
    $lookup: {
      from: "opera",
      localField: "_id",
      foreignField: "idMuseo",
      as: "opere",
    },
  },
  {
    $match: {
      citta: "Verona",
    },
  },
]);

console.log(musei);
