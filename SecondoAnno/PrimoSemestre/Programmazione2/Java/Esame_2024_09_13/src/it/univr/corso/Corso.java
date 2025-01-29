package it.univr.corso;

/**
 * Un corso di laurea (per esempio, informatica), con nome e durata in anni.
 */
public class Corso {
	private String nome;
	private int durata;

	public Corso(String nome, int durata) {
		this.nome = nome;
		this.durata = durata;
	}

	@Override
	public String toString() {
		// Restituisce il nome del corso
		return nome;
	}

	public String getNome() {
		return nome;
	}

	public int getDurata() {
		return durata;
	}
}