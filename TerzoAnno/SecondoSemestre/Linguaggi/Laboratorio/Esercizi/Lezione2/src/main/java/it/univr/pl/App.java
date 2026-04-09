package it.univr.pl;

import java.util.Scanner;
import java.util.function.Consumer;
import java.util.function.Function;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.TokenStream;

public class App {

  public static void main(String[] args) {
    Scanner reader = new Scanner(System.in);
    System.out.println("Which grammar do you want to execute?");
    System.out.println("1. L3");
    System.out.println("2. L4");

    int choice = Integer.max(0, Integer.min(Grammar.values().length, reader.nextInt() - 1));
    Grammar grammar = Grammar.values()[choice];
    reader.nextLine();

    System.out.println("\nInsert a string to parse:");
    String input = reader.nextLine();
    reader.close();

    switch (grammar) {
      case L3:
        exec_grammar(
            input,
            L3Lexer::new,
            L3Parser::new,
            L3Parser::main);
        break;

      case L4:
        exec_grammar(
            input,
            L4Lexer::new,
            L4Parser::new,
            L4Parser::main);
        break;

      default:
        System.out.println("Grammar not recognized");
        break;
    }
  }

  /**
   * Executes a grammar on a given input string, using the provided lexer and
   * parser constructors, and starting from the specified nonterminal symbol.
   */
  public static <GenericLexer extends Lexer, GenericParser extends Parser> void exec_grammar(String input,
      Function<CharStream, GenericLexer> lexerConstructor,
      Function<TokenStream, GenericParser> parserConstructor,
      Consumer<GenericParser> startRule) {
    // Create a CharStream from the input string
    CharStream cs = CharStreams.fromString(input);

    // Create a TokenSource from the CharStream for the grammar
    GenericLexer lexer = lexerConstructor.apply(cs);

    // Obtain the tokens from the TokenSource as a TokenStream
    CommonTokenStream tokens = new CommonTokenStream(lexer);

    // Create a parser that parses the grammar
    GenericParser parser = parserConstructor.apply(tokens);

    // Execute the grammar from the given nonterminal symbol
    startRule.accept(parser);
  }
}
