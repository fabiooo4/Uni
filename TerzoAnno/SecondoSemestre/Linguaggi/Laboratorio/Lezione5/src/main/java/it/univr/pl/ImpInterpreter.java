package it.univr.pl;

import java.util.HashMap;

import it.univr.pl.ImpParser.AddSubContext;
import it.univr.pl.ImpParser.AssignContext;
import it.univr.pl.ImpParser.EqExpContext;
import it.univr.pl.ImpParser.ExpContext;
import it.univr.pl.ImpParser.ExpStmtContext;
import it.univr.pl.ImpParser.FloatContext;
import it.univr.pl.ImpParser.IdContext;
import it.univr.pl.ImpParser.IfContext;
import it.univr.pl.ImpParser.IntContext;
import it.univr.pl.ImpParser.MainContext;
import it.univr.pl.ImpParser.SeqContext;
import it.univr.pl.exception.TypeMismatchException;
import it.univr.pl.exception.UnknownVariableException;
import it.univr.pl.value.BoolValue;
import it.univr.pl.value.ExpValue;
import it.univr.pl.value.FloatValue;
import it.univr.pl.value.IntValue;
import it.univr.pl.value.StmtValue;
import it.univr.pl.value.Value;

/**
 * ImpImp
 *
 * Implements semantics for the grammar
 */
public class ImpInterpreter extends ImpBaseVisitor<Value> {
  static Mem memory = new Mem();

  private BoolValue visitBoolExp(ExpContext ctx) throws TypeMismatchException {
    try {
      return (BoolValue) visit(ctx);
    } catch (ClassCastException e) {
      String err = ctx.start.getLine() + ":" + ctx.start.getCharPositionInLine() + " Type mismatch: expected bool";
      throw new TypeMismatchException(err);
    }
  }

  private ExpValue<?> visitNumberExp(ExpContext ctx) throws TypeMismatchException {
    if (visit(ctx) instanceof IntValue || visit(ctx) instanceof FloatValue) {
      return (ExpValue<?>) visit(ctx);
    } else {
      String err = ctx.start.getLine() + ":" + ctx.start.getCharPositionInLine() + " Type mismatch: expected bool";
      throw new TypeMismatchException(err);
    }
  }

  @Override
  public Value visitMain(MainContext ctx) {
    return visit(ctx.prog());
  }

  @Override
  public IntValue visitInt(IntContext ctx) {
    return new IntValue(Integer.parseInt(ctx.getText()));
  }

  @Override
  public FloatValue visitFloat(FloatContext ctx) {
    return new FloatValue(Float.parseFloat(ctx.getText()));

  }

  @Override
  public ExpValue<?> visitAddSub(AddSubContext ctx) {
    ExpValue<?> left = visitNumberExp(ctx.exp(0));
    ExpValue<?> right = visitNumberExp(ctx.exp(1));

    return switch (ctx.op.getType()) {
      case ImpParser.ADD -> left.add(right);
      case ImpParser.SUB -> left.sub(right);
      default -> null; // unreachable
    };
  }

  @Override
  public StmtValue visitIf(IfContext ctx) {
    BoolValue condition = visitBoolExp(ctx.exp());
    return condition.toJavaValue() ? (StmtValue) visit(ctx.stmt()) : StmtValue.INSTANCE;
  }

  @Override
  public StmtValue visitAssign(AssignContext ctx) {
    String id = ctx.ID().getText();
    ExpValue<?> val = (ExpValue<?>) visit(ctx.exp());
    memory.update(id, val);

    return StmtValue.INSTANCE;
  }

  @Override
  public Value visitExpStmt(ExpStmtContext ctx) {
    return visit(ctx.exp());
  }

  @Override
  public StmtValue visitSeq(SeqContext ctx) {
    visit(ctx.stmt(0));
    return (StmtValue) visit(ctx.stmt(1));
  }

  @Override
  public ExpValue<?> visitId(IdContext ctx) {

    String id = ctx.ID().getText();

    if (memory.contains(id)) {
      return memory.get(id);
    } else {
      String err = ctx.start.getLine() + ":" + ctx.start.getCharPositionInLine() + "Variable '" + id
          + "' used but not initialized";

      throw new UnknownVariableException(err);
    }
  }

  @Override
  public ExpValue<?> visitEqExp(EqExpContext ctx) {
    ExpValue<?> left = (ExpValue<?>) visit(ctx.exp(0));
    ExpValue<?> right = (ExpValue<?>) visit(ctx.exp(1));

    return switch (ctx.op.getType()) {
      case ImpParser.EQQ -> new BoolValue(left.equals(right));
      case ImpParser.NEQ -> new BoolValue(!left.equals(right));
      default -> null; // unreachable
    };
  }

}
