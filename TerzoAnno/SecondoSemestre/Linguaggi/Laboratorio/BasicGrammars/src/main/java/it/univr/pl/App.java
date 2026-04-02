package it.univr.pl;

import java.util.Scanner;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

public class App {
  public static void main(String[] args) {
    Scanner reader = new Scanner(System.in);
    System.out.println("Insert a string to parse:");
    String input = reader.nextLine();
    reader.close();

    // Create a CharStream from the input string
    CharStream cs = CharStreams.fromString(input);

    // Create a TokenSource from the CharStream using the NatNumbers grammar
    NatNumbersLexer lexer = new NatNumbersLexer(cs);

    // Obtain the tokens from the TokenSource as a TokenStream
    CommonTokenStream tokens = new CommonTokenStream(lexer);

    // Create a parser that parses the NatNumbers grammar
    NatNumbersParser parser = new NatNumbersParser(tokens);

    // Execute the grammar from the 'main' nonterminal symbol
    parser.main();
  }
}
