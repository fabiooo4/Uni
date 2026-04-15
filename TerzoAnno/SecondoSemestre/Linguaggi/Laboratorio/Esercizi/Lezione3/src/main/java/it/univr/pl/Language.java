package it.univr.pl;

import java.util.function.Function;
import java.util.function.Supplier;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

public enum Language {
  IntegerExpressions,
  IntegerStringExpressions,
  NegativeIntegerExpressions,
  ;

  /**
   * Parses a grammar on a given input string, using the provided lexer and
   * parser constructors, and starting from the specified nonterminal symbol.
   *
   * @return The ParseTree resulting from executing the grammar on the input
   *         string.
   *
   * @throws ParseCancellationException If the input string causes parsing errors
   *                                    according to the grammar, a
   *                                    ParseCancellationException is thrown.
   */
  public static <GenericLexer extends Lexer, GenericParser extends Parser> ParseTree parse(String input,
      Function<CharStream, GenericLexer> lexerConstructor,
      Function<TokenStream, GenericParser> parserConstructor,
      Function<GenericParser, ParseTree> startRule)
      throws ParseCancellationException {
    // Create a CharStream from the input string
    CharStream cs = CharStreams.fromString(input);

    // Create a TokenSource from the CharStream for the grammar
    GenericLexer lexer = lexerConstructor.apply(cs);
    lexer.removeErrorListeners();
    lexer.addErrorListener(new ThrowingErrorListener());

    // Obtain the tokens from the TokenSource as a TokenStream
    CommonTokenStream tokens = new CommonTokenStream(lexer);

    // Create a parser that parses the grammar
    GenericParser parser = parserConstructor.apply(tokens);
    parser.removeErrorListeners();
    parser.addErrorListener(new ThrowingErrorListener());

    // Execute the grammar from the given nonterminal symbol
    return startRule.apply(parser);
  }

  /**
   * Executes the interpreter on a given parse tree
   */
  public static <T, GenericInterpreter extends ParseTreeVisitor<T>> T exec(
      ParseTree parseTree,
      Supplier<GenericInterpreter> interpreterConstructor) {
    GenericInterpreter interpreter = interpreterConstructor.get();
    return interpreter.visit(parseTree);
  }

}
