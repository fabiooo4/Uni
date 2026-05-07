package it.univr.pl.typeSystem.types;

/**
 * PrimitiveType
 */
public enum PrimitiveType implements ExpType {
  Int("int"),
  Float("float"),
  String("string"),
  Char("char"),
  Bool("bool");

  private final String name;

  PrimitiveType(String name) {
    this.name = name;

  }

  public static PrimitiveType fromString(String typeName) {
    return switch (typeName) {
      case "int" -> PrimitiveType.Int;
      case "float" -> PrimitiveType.Float;
      case "string" -> PrimitiveType.String;
      case "char" -> PrimitiveType.Char;
      case "bool" -> PrimitiveType.Bool;
      default -> null;
    };
  }

}
