// Esercizio 3
// Cercare tutti i musei che si trovano a Verona, riportando solo il nome ed il numero di telefono.
// Attenzione: la funzione .project() può essere utilizzata solo all’interno di applicazioni (es.
// python) ed in presenza di un cursore. Al contrario nell’interazione tramite shell (Compass
// oppure mongosh) non è possibile usare la funzione .project(), ma è possibile specificare la
// proiezione come secondo argomento della funzione find(), come segue:
//
// db.<collection>.find( { item: ‘value’}, { item1: 1, item2: 1 })
//
// in questo modo solo gli attributi item1 e item2 saranno visualizzati.

conn = db.getMongo();
db = conn.getDB("MuseiVerona");

museiVerona = db.museo.find(
  {
    citta: "Verona",
  },
  {
    nome: true,
    numeroTelefono: true,
  },
);

console.log(museiVerona);
