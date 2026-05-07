package it.univr.pl.value;

/**
 * StmtValue
 */
public class StmtValue extends Value {
  public static final StmtValue INSTANCE = new StmtValue();

  private StmtValue() {
  }

  public boolean equals(Object obj) {
    return obj instanceof StmtValue;
  }

  public int hashCode() {
    return 0;
  }

  @Override
  public String toString() {
    return "void";
  };
}
