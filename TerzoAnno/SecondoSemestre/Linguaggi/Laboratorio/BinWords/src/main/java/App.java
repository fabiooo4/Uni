import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

public class App {
  public static void main(String[] args) {
    if (args.length < 1) {
      System.err.println("Missing argument, provide a string to parse");
      System.exit(1);
    }

    System.out.println(args[0]);

    // Create a CharStream from the input string
    CharStream cs = CharStreams.fromString(args[0]);

    // Create a TokenSource from the CharStream using the BinWords grammar
    BinWordsLexer lexer = new BinWordsLexer(cs);

    // Obtain the tokens from the TokenSource as a TokenStream
    CommonTokenStream tokens = new CommonTokenStream(lexer);

    // Create a parser that parses the BinWords grammar
    BinWordsParser parser = new BinWordsParser(tokens);

    // Execute the grammar from the 'main' nonterminal symbol
    ParseTree tree = parser.main();
  }
}
