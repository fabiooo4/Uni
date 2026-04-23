package it.univr.pl;

import java.util.Scanner;
import org.antlr.v4.runtime.tree.ParseTree;

public class App {

  public static void main(String[] args) {
    Scanner reader = new Scanner(System.in);

    System.out.println("\nInsert a string to parse:");
    String input = reader.nextLine();
    reader.close();

    ParseTree ast = Language.parse(
        input,
        ImpLexer::new,
        ImpParser::new,
        ImpParser::main);

    float res = Language.exec(ast, ImpInterpreter::new);
    System.out.println(res);
  }
}
