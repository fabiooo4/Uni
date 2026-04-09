package it.univr.pl;

import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Supplier;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

public enum Language {
  IntegerExpressions,
  IntegerStringExpressions;

  /**
   * Executes the interpreter on a given input string, using the provided lexer
   * and
   * parser constructors, and starting from the specified nonterminal symbol.
   */
  public static <T, GenericLexer extends Lexer, GenericParser extends Parser, GenericInterpreter extends IntExprBaseVisitor<T>> T exec(
      String input,
      Function<CharStream, GenericLexer> lexerConstructor,
      Function<TokenStream, GenericParser> parserConstructor,
      Function<GenericParser, ParseTree> startRule,
      Supplier<GenericInterpreter> interpreterConstructor
  ) {
    // Create a CharStream from the input string
    CharStream cs = CharStreams.fromString(input);

    // Create a TokenSource from the CharStream for the grammar
    GenericLexer lexer = lexerConstructor.apply(cs);

    // Obtain the tokens from the TokenSource as a TokenStream
    CommonTokenStream tokens = new CommonTokenStream(lexer);

    // Create a parser that parses the grammar
    GenericParser parser = parserConstructor.apply(tokens);

    // Execute the grammar from the given nonterminal symbol
    ParseTree tree = startRule.apply(parser);

    GenericInterpreter interpreter = interpreterConstructor.get();
    return interpreter.visit(tree);
  }

}
