package it.univr.pl.typeSystem;

import java.util.HashMap;
import java.util.Map;

import it.univr.pl.ImpBaseVisitor;
import it.univr.pl.ImpParser.DeclContext;
import it.univr.pl.ImpParser.ExpContext;
import it.univr.pl.ImpParser.IfContext;
import it.univr.pl.exception.TypeMismatchException;
import it.univr.pl.exception.VarDeclarationException;
import it.univr.pl.typeSystem.types.Type;
import it.univr.pl.typeSystem.types.ExpType;
import it.univr.pl.typeSystem.types.PrimitiveType;
import it.univr.pl.typeSystem.types.StmtType;

/**
 * TypeSystem
 *
 * It is another interpreter but working on types instead of values
 */
public class TypeSystem extends ImpBaseVisitor<Type> {

  private final Map<String, ExpType> memType = new HashMap<>();

  private PrimitiveType visitBoolExp(ExpContext ctx) throws TypeMismatchException {
    try {
      PrimitiveType expType = (PrimitiveType) visit(ctx);

      if (expType != PrimitiveType.Bool)
        throw new RuntimeException();

    } catch (RuntimeException e) {
      String err = ctx.start.getLine() + ":" + ctx.start.getCharPositionInLine() + " Type mismatch: expected bool";
      throw new TypeMismatchException(err);
    }

    return PrimitiveType.Bool;
  }

  @Override
  public StmtType visitDecl(DeclContext ctx) {
    for (int i = 0; i < ctx.ID().size(); i++) {
      String id = ctx.ID(i).getText();
      PrimitiveType type = PrimitiveType.fromString(ctx.TYPE(i).getText());

      // No variable shadowing in this language
      if (memType.containsKey(id)) {
        String err = "Variable " + id + " is already declared";
        throw new VarDeclarationException(err);
      }

      memType.put(id, type);
    }

    return StmtType.INSTANCE;
  }

  @Override
  public StmtType visitIf(IfContext ctx) {
    visitBoolExp(ctx.exp());
    return (StmtType) visit(ctx.stmt());
  }
}
