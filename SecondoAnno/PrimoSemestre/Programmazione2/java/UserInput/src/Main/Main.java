package Main;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Inserisci il tuo nome");
        String nome = scanner.nextLine();

        System.out.println("Ciao, " + nome);
    }
}
