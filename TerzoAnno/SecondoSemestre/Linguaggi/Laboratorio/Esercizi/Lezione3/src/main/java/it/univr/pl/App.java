package it.univr.pl;

import java.util.Scanner;
import org.antlr.v4.runtime.tree.ParseTree;

public class App {

  public static void main(String[] args) {
    Scanner reader = new Scanner(System.in);
    System.out.println("Which grammar do you want to execute?");
    System.out.println("1. Natural numbers expressions");
    System.out.println("2. Natural to string expressions");
    System.out.println("3. Integer expressions");
    System.out.println("4. Integer expressions with variables");

    int choice = Integer.max(0, Integer.min(Language.values().length, reader.nextInt() - 1));
    Language grammar = Language.values()[choice];
    reader.nextLine();

    System.out.println("\nInsert a string to parse:");
    String input = reader.nextLine();
    reader.close();

    switch (grammar) {
      case IntegerExpressions: {
        ParseTree ast = Language.parse(
            input,
            IntExprLexer::new,
            IntExprParser::new,
            IntExprParser::main);

        int res = Language.exec(ast, IntExprInterpreter::new);
        System.out.println(res);
        break;
      }

      case IntegerStringExpressions: {
        ParseTree ast = Language.parse(
            input,
            IntExprLexer::new,
            IntExprParser::new,
            IntExprParser::main);

        String res = Language.exec(ast, IntToStrExprInterpreter::new);
        System.out.println(res);
        break;
      }

      case NegativeIntegerExpressions: {
        ParseTree ast = Language.parse(
            input,
            IntNegExprLexer::new,
            IntNegExprParser::new,
            IntNegExprParser::main);

        int res = Language.exec(ast, IntNegExprInterpreter::new);
        System.out.println(res);
        break;
      }

      case VariableIntegerExpressions: {
        ParseTree ast = Language.parse(
            input,
            IntVarExprLexer::new,
            IntVarExprParser::new,
            IntVarExprParser::main);

        int res = Language.exec(ast, IntVarExprInterpreter::new);
        System.out.println(res);
        break;
      }

      default:
        System.out.println("Grammar not recognized");
        break;
    }
  }
}
