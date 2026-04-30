package it.univr.pl;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Scanner;
import org.antlr.v4.runtime.tree.ParseTree;

public class App {

  public static void main(String[] args) throws Exception {
    String input;
    if (args.length > 0) {
      // Read from file

      input = String.join("\n", Files.readAllLines(Paths.get(args[0])));
    } else {
      // Read from stdin

      Scanner reader = new Scanner(System.in);

      System.out.println("\nInsert a string to parse:");
      input = reader.nextLine();
      reader.close();
    }

    ParseTree ast = Language.parse(
        input,
        ImpLexer::new,
        ImpParser::new,
        ImpParser::main);

    Language.exec(ast, ImpInterpreter::new);
  }
}
