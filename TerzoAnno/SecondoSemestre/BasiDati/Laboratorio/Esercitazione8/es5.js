// Esercizio 5
// Aggiornare i prezzi dei musei di Verona aggiungendo un prezzo ridotto pari a 5 euro.
// La funzione update può essere utilizzata sia per aggiornare un valore, che aggiornare la
// struttura di un documento aggiungendo una proprietà mancante.
// Verificare l’esito eseguendo una interrogazione che mostri solo nome del museo, città, prezzo e
// prezzo ridotto.

conn = db.getMongo();
db = conn.getDB("MuseiVerona");

// Delete the prezzoRidotto field if it already exists
db.museo.updateMany({ citta: "Verona" }, { $unset: { prezzoRidotto: null } });

db.museo.updateMany(
  {
    citta: "Verona",
  },
  {
    $set: { prezzoRidotto: 5 },
  },
);

musei = db.museo.find(
  {},
  { nome: true, citta: true, prezzo: true, prezzoRidotto: true },
);

console.log(musei)
