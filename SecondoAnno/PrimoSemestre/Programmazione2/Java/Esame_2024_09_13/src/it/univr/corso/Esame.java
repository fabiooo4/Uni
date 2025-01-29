package it.univr.corso;

import java.util.SortedSet;
import java.util.TreeSet;
import java.util.function.Consumer;
import java.util.function.Predicate;
import java.util.stream.Collectors;

/**
 * Un esame di un corso di laurea, con il nome dell'esame e il corso di laurea a
 * cui appartiene.
 */
public class Esame {
	private String nome;
	private Corso corso;
	private SortedSet<Studente> iscritti = new TreeSet<>();

	/**
	 * Crea un esame con il nome indicato, per il corso indicato, inizialmente senza
	 * iscritti.
	 */
	public Esame(String nome, Corso corso) {
		this.nome = nome;
		this.corso = corso;
	}

	/**
	 * Iscrive lo studente indicato a questo esame.
	 * 
	 * @throws StudenteIllegaleException se ci fosse già uno studente iscritto a
	 *                                   questo esame con la stessa matricola
	 */
	public void iscrivi(Studente studente) throws StudenteIllegaleException {
		if (!iscritti.contains(studente))
			iscritti.add(studente);
		else
			throw new StudenteIllegaleException("Lo studente è già stato iscritto all'esame");
	}

	@Override
	public String toString() {
		// restituisce la stringa ottenuta concatenando tutti gli iscritti all'esame
		// in ordine crescente per matricola; all'inizio riporta nome dell'esame e
		// corso;
		// si veda l'esempio nel testo del compito

		return "Esame di " + nome + " del corso di " + corso + ":\n"
				+ iscritti.stream().map(s -> s.toString()).collect(Collectors.joining("\n"));
	}

	/**
	 * Esegue l'azione indicata per ogni studente iscritto che soddisfa la
	 * condizione indicata.
	 */
	public void perOgniIscritto(Predicate<Studente> condizione, Consumer<Studente> azione) {
		for (Studente studente : iscritti) {
			if (condizione.test(studente)) {
				azione.accept(studente);
			}
		}
	}
}