package it.univr.corso;

import java.time.Year;

/**
 * Uno studente lavoratore è identico a uno studente ma finisce fuori corso nel
 * doppio di anni rispetto a uno studente non lavoratore.
 */
public class StudenteLavoratore extends Studente {
	// aggiungete campi se servissero

	public StudenteLavoratore(String nome, String cognome, int matricola, int annoDiImmatricolazione)
			throws StudenteIllegaleException {
		super(nome, cognome, matricola, annoDiImmatricolazione);
	}

	@Override
	public boolean fuoriCorso(Corso corso) {
		int annoCorrente = Year.now().getValue();
		int durataStudente = annoCorrente - getAnnoDiImmatricolazione();
		if (durataStudente > corso.getDurata() * 2)
			return true;

		return false;
	}
}