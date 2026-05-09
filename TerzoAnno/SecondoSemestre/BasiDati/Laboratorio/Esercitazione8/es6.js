// Esercizio 6
// Selezionare tutti i musei che hanno una mostra attiva oggi, visualizzando il nome del museo ed
// il nome della mostra.
// Usare gli operatori $gte e $lte con il tipo ISODate().

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
    $match: {
      "mostre.inizio": { $lte: today },
      "mostre.fine": { $gte: today },
    },
  },
  {
    $project: {
      nome: true,
      mostre: "$mostre.titolo",
    },
  },
]);

console.log(musei);
