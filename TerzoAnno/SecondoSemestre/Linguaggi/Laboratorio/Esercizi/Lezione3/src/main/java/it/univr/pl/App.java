package it.univr.pl;

import java.util.Scanner;

public class App {

  public static void main(String[] args) {
    Scanner reader = new Scanner(System.in);
    System.out.println("Which grammar do you want to execute?");
    System.out.println("1. Integer expressions");

    int choice = Integer.max(0, Integer.min(Language.values().length, reader.nextInt() - 1));
    Language grammar = Language.values()[choice];
    reader.nextLine();

    System.out.println("\nInsert a string to parse:");
    String input = reader.nextLine();
    reader.close();

    switch (grammar) {
      case IntegerExpressions:
        var res = Language.exec(
            input,
            IntExprLexer::new,
            IntExprParser::new,
            IntExprParser::main,
            IntToStrExprInterpreter::new);
        System.out.println(res);
        break;

      default:
        System.out.println("Grammar not recognized");
        break;
    }
  }
}
