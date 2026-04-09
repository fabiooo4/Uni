package it.univr.pl;

import java.util.Scanner;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

public class App {

  public static void main(String[] args) {
    Scanner reader = new Scanner(System.in);
    System.out.println("\nInsert a string to parse:");
    String input = reader.nextLine();
    reader.close();

    // Create a CharStream from the input string
    CharStream cs = CharStreams.fromString(input);

    // Create a TokenSource from the CharStream for the grammar
    IntExprLexer lexer = new IntExprLexer(cs);

    // Obtain the tokens from the TokenSource as a TokenStream
    CommonTokenStream tokens = new CommonTokenStream(lexer);

    // Create a parser that parses the grammar
    IntExprParser parser = new IntExprParser(tokens);

    // Execute the grammar from the given nonterminal symbol
    ParseTree tree = parser.main();

    IntExprInterpreter interpreter = new IntExprInterpreter();
    System.out.println(interpreter.visit(tree));
  }
}
