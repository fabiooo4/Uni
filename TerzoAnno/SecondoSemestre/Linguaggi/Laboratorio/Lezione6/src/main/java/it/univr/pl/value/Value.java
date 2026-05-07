package it.univr.pl.value;

/**
 * Value
 */
public abstract class Value {

  @Override
  public abstract boolean equals(Object obj);

  @Override
  public abstract int hashCode();

  @Override
  public abstract String toString();
}
