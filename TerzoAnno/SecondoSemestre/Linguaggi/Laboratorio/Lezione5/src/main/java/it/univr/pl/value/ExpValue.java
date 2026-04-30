package it.univr.pl.value;

import java.util.Objects;

import it.univr.pl.exception.TypeMismatchException;

/**
 * ExpValue
 */
public class ExpValue<T> extends Value {
  private final T value;

  public ExpValue(T value) {
    this.value = value;
  }

  public T toJavaValue() {
    return value;
  }

  @Override
  public boolean equals(Object obj) {
    if (obj == null || getClass() != obj.getClass())
      return false;
    ExpValue<?> expValue = (ExpValue<?>) obj;
    return Objects.equals(value, expValue.value);
  }

  @Override
  public int hashCode() {
    return value.hashCode();
  }

  @Override
  public String toString() {
    return value.toString();
  }

  public ExpValue<?> add(ExpValue<?> rhs) {
    if (this.toJavaValue().getClass() == Integer.class && rhs.toJavaValue().getClass() == Integer.class) {
      return new ExpValue<Integer>((Integer) this.toJavaValue() + (Integer) rhs.toJavaValue());
    } else if (this.toJavaValue().getClass() == Float.class && rhs.toJavaValue().getClass() == Float.class) {
      return new ExpValue<Float>((Float) this.toJavaValue() + (Float) rhs.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public ExpValue<?> sub(ExpValue<?> rhs) {
    if (this.toJavaValue().getClass() == Integer.class && rhs.toJavaValue().getClass() == Integer.class) {
      return new ExpValue<Integer>((Integer) this.toJavaValue() - (Integer) rhs.toJavaValue());
    } else if (this.toJavaValue().getClass() == Float.class && rhs.toJavaValue().getClass() == Float.class) {
      return new ExpValue<Float>((Float) this.toJavaValue() - (Float) rhs.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

}
