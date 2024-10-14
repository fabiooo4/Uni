package es4;

import es2.Cornice;

public class Main {
    public static void main(String[] args) {
        for (int i = 0; i < 26; i++) {
            Cornice.setBorder((char)('a' + i));
            Cornice.stampa(10);
        }
    }
}
