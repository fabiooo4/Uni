package es1;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        long n = 0;
        long dentro = 0;

        // Input
        System.out.println("Inserisci il numero di punti da generare");
        do {
            try {
                n = scan.nextLong();

                if (n <= 0) {
                    System.out.println("Inserisci un numero maggiore di 0");
                }
            } catch (Exception e) {
                System.out.println("Il numero deve essere un intero");
                scan.nextLine();
            }
        } while (n <= 0);


        for (long i = 0; i < n; i++) {
            Punto p = new Punto();

            if (p.isInCircle(1)) {
                dentro++;
            }
        }

        System.out.println("La risposta è " + (double)(dentro * 4) / n);
        System.out.println("I punti che sono dentro il cerchio sono:");
        System.out.printf("%d/%d", dentro, n);
    }
}
