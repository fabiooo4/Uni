package id.univr.pl;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.antlr.v4.runtime.misc.ParseCancellationException;
import org.junit.jupiter.api.Test;

import it.univr.pl.App;
import it.univr.pl.LDigLexer;
import it.univr.pl.LDigParser;

/**
 * Unit tests for Ldig grammar
 */
public class LdigTest {

  // Strings in grammar
  @Test
  public void LDigCorrectTest1() {
    assertDoesNotThrow(() -> {
      App.exec_grammar(
          "()",
          LDigLexer::new,
          LDigParser::new,
          LDigParser::main);
    });
  }

  @Test
  public void LDigCorrectTest2() {
    assertDoesNotThrow(() -> {
      App.exec_grammar(
          "(1, 2,3)",
          LDigLexer::new,
          LDigParser::new,
          LDigParser::main);
    });
  }

  // Strings not in grammar
  @Test
  public void LDigIncorrectTest1() {
    assertThrows(ParseCancellationException.class, () -> {
      App.exec_grammar(
          "(",
          LDigLexer::new,
          LDigParser::new,
          LDigParser::main);
    });
  }

  @Test
  public void LDigIncorrectTest2() {
    assertThrows(ParseCancellationException.class, () -> {
      App.exec_grammar(
          "(1, 10)",
          LDigLexer::new,
          LDigParser::new,
          LDigParser::main);
    });
  }
}
