package es5;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int n = 0;

        // Input
        System.out.println("Inserisci l'altezza del triangolo da generare");
        do {
            try {
                n = scan.nextInt();

                if (n <= 0) {
                    System.out.println("Inserisci un numero maggiore di 0");
                }
            } catch (Exception e) {
                System.out.println("Il numero deve essere un intero");
                scan.nextLine();
            }
        } while (n <= 0);
    }
}
