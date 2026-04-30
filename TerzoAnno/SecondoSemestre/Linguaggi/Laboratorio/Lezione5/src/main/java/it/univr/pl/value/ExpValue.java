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

  private boolean isType(Class<? extends Object> type) {
    return this.toJavaValue().getClass().equals(type);
  }

  public ExpValue<?> add(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return new ExpValue<Integer>((Integer) this.toJavaValue() + (Integer) rhs.toJavaValue());
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return new ExpValue<Float>((Float) this.toJavaValue() + (Float) rhs.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public ExpValue<?> sub(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return new ExpValue<Integer>((Integer) this.toJavaValue() - (Integer) rhs.toJavaValue());
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return new ExpValue<Float>((Float) this.toJavaValue() - (Float) rhs.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public ExpValue<?> mul(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return new ExpValue<Integer>((Integer) this.toJavaValue() * (Integer) rhs.toJavaValue());
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return new ExpValue<Float>((Float) this.toJavaValue() * (Float) rhs.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public ExpValue<?> div(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return new ExpValue<Integer>((Integer) this.toJavaValue() / (Integer) rhs.toJavaValue());
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return new ExpValue<Float>((Float) this.toJavaValue() / (Float) rhs.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public ExpValue<?> mod(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return new ExpValue<Integer>((Integer) this.toJavaValue() % (Integer) rhs.toJavaValue());
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return new ExpValue<Float>((Float) this.toJavaValue() % (Float) rhs.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public ExpValue<?> pow(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return new ExpValue<Integer>(Math.powExact((Integer) this.toJavaValue(), (Integer) rhs.toJavaValue()));
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return new ExpValue<Float>((float) Math.pow((Float) this.toJavaValue(), (Float) rhs.toJavaValue()));
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public ExpValue<?> negate() {
    if (this.isType(Integer.class)) {
      return new ExpValue<Integer>(-(Integer) this.toJavaValue());
    } else if (this.isType(Float.class)) {
      return new ExpValue<Float>(-(Float) this.toJavaValue());
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public boolean lt(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return (Integer) this.toJavaValue() < (Integer) rhs.toJavaValue();
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return (Float) this.toJavaValue() < (Float) rhs.toJavaValue();
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public boolean leq(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return (Integer) this.toJavaValue() <= (Integer) rhs.toJavaValue();
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return (Float) this.toJavaValue() <= (Float) rhs.toJavaValue();
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public boolean gt(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return (Integer) this.toJavaValue() > (Integer) rhs.toJavaValue();
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return (Float) this.toJavaValue() > (Float) rhs.toJavaValue();
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }

  public boolean geq(ExpValue<?> rhs) {
    if (this.isType(Integer.class) && rhs.isType(Integer.class)) {
      return (Integer) this.toJavaValue() >= (Integer) rhs.toJavaValue();
    } else if (this.isType(Float.class) && rhs.isType(Float.class)) {
      return (Float) this.toJavaValue() >= (Float) rhs.toJavaValue();
    } else {
      throw new TypeMismatchException("Expected a numeric type");
    }
  }
}
