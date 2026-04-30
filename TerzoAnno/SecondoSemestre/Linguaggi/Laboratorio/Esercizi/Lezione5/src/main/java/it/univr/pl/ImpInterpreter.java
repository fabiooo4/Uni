package it.univr.pl;

import java.util.HashMap;

import it.univr.pl.ImpParser.AddSubContext;
import it.univr.pl.ImpParser.AndOrContext;
import it.univr.pl.ImpParser.AssignContext;
import it.univr.pl.ImpParser.BoolContext;
import it.univr.pl.ImpParser.CharContext;
import it.univr.pl.ImpParser.CmpExpContext;
import it.univr.pl.ImpParser.EqExpContext;
import it.univr.pl.ImpParser.ExpContext;
import it.univr.pl.ImpParser.FloatContext;
import it.univr.pl.ImpParser.IdContext;
import it.univr.pl.ImpParser.IfContext;
import it.univr.pl.ImpParser.IntContext;
import it.univr.pl.ImpParser.MainContext;
import it.univr.pl.ImpParser.MulDivModContext;
import it.univr.pl.ImpParser.NegContext;
import it.univr.pl.ImpParser.NotContext;
import it.univr.pl.ImpParser.ParenContext;
import it.univr.pl.ImpParser.PowContext;
import it.univr.pl.ImpParser.PrintContext;
import it.univr.pl.ImpParser.ProgContext;
import it.univr.pl.ImpParser.SeqContext;
import it.univr.pl.ImpParser.StrConcatContext;
import it.univr.pl.ImpParser.StringContext;
import it.univr.pl.ImpParser.ToStrContext;
import it.univr.pl.ImpParser.WhileContext;
import it.univr.pl.exception.TypeMismatchException;
import it.univr.pl.exception.UnknownVariableException;
import it.univr.pl.value.BoolValue;
import it.univr.pl.value.CharValue;
import it.univr.pl.value.ExpValue;
import it.univr.pl.value.FloatValue;
import it.univr.pl.value.IntValue;
import it.univr.pl.value.StmtValue;
import it.univr.pl.value.StringValue;
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
    ExpValue<?> visit = (ExpValue<?>) visit(ctx);
    Object val = visit.toJavaValue();
    if (val instanceof Integer || val instanceof Float) {
      return visit;
    } else {
      String err = ctx.start.getLine() + ":" + ctx.start.getCharPositionInLine() + " Type mismatch: expected a number";
      throw new TypeMismatchException(err);
    }
  }

  @Override
  public Value visitMain(MainContext ctx) {
    return visit(ctx.prog());
  }

  @Override
  public Value visitProg(ProgContext ctx) {
    Value visit = super.visitProg(ctx);

    // If there is only an expression, print the interpretation
    if (ctx.exp() != null) {
      System.out.println(visit);
    }

    return visit;
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
  public Value visitNeg(NegContext ctx) {
    ExpValue<?> val = visitNumberExp(ctx.exp());

    return val.negate();
  }

  @Override
  public ExpValue<?> visitMulDivMod(MulDivModContext ctx) {
    ExpValue<?> left = visitNumberExp(ctx.exp(0));
    ExpValue<?> right = visitNumberExp(ctx.exp(1));

    return switch (ctx.op.getType()) {
      case ImpParser.MUL -> left.mul(right);
      case ImpParser.DIV -> left.div(right);
      case ImpParser.MOD -> left.mod(right);
      default -> null; // unreachable
    };
  }

  @Override
  public Value visitPow(PowContext ctx) {
    ExpValue<?> base = visitNumberExp(ctx.exp(0));
    ExpValue<?> exp = visitNumberExp(ctx.exp(1));
    return base.pow(exp);
  }

  @Override
  public BoolValue visitBool(BoolContext ctx) {
    return new BoolValue(Boolean.parseBoolean(ctx.getText()));
  }

  @Override
  public BoolValue visitNot(NotContext ctx) {
    boolean val = visitBoolExp(ctx.exp()).toJavaValue();
    return new BoolValue(!val);
  }

  @Override
  public BoolValue visitAndOr(AndOrContext ctx) {
    boolean left = visitBoolExp(ctx.exp(0)).toJavaValue();
    boolean right = visitBoolExp(ctx.exp(1)).toJavaValue();

    return switch (ctx.op.getType()) {
      case ImpParser.AND -> new BoolValue(left && right);
      case ImpParser.OR -> new BoolValue(left || right);
      default -> null; // unreachable
    };
  }

  @Override
  public BoolValue visitEqExp(EqExpContext ctx) {
    ExpValue<?> left = (ExpValue<?>) visit(ctx.exp(0));
    ExpValue<?> right = (ExpValue<?>) visit(ctx.exp(1));

    return switch (ctx.op.getType()) {
      case ImpParser.EQQ -> new BoolValue(left.equals(right));
      case ImpParser.NEQ -> new BoolValue(!left.equals(right));
      default -> null; // unreachable
    };
  }

  @Override
  public BoolValue visitCmpExp(CmpExpContext ctx) {
    ExpValue<?> left = visitNumberExp(ctx.exp(0));
    ExpValue<?> right = visitNumberExp(ctx.exp(1));

    return switch (ctx.op.getType()) {
      case ImpParser.LT -> new BoolValue(left.lt(right));
      case ImpParser.LEQ -> new BoolValue(left.leq(right));
      case ImpParser.GEQ -> new BoolValue(left.geq(right));
      case ImpParser.GT -> new BoolValue(left.gt(right));
      default -> null; // unreachable
    };
  }

  @Override
  public StmtValue visitAssign(AssignContext ctx) {
    String id = ctx.ID().getText();
    ExpValue<?> val = (ExpValue<?>) visit(ctx.exp());
    memory.update(id, val);

    return StmtValue.INSTANCE;
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
  public StmtValue visitSeq(SeqContext ctx) {
    visit(ctx.stmt(0));
    return (StmtValue) visit(ctx.stmt(1));
  }

  @Override
  public StmtValue visitIf(IfContext ctx) {
    boolean condition = visitBoolExp(ctx.exp()).toJavaValue();
    return condition ? (StmtValue) visit(ctx.stmt()) : StmtValue.INSTANCE;
  }

  @Override
  public StmtValue visitWhile(WhileContext ctx) {
    boolean condition = visitBoolExp(ctx.exp()).toJavaValue();

    while (condition) {
      visit(ctx.stmt());
    }

    return StmtValue.INSTANCE;
  }

  @Override
  public ExpValue<?> visitParen(ParenContext ctx) {
    ExpValue<?> val = (ExpValue<?>) visit(ctx.exp());
    return val;
  }

  @Override
  public StringValue visitString(StringContext ctx) {
    String quoted_str = ctx.STRING().getText();
    String str = quoted_str.substring(1, quoted_str.length() - 1);
    return new StringValue(str);
  }

  @Override
  public CharValue visitChar(CharContext ctx) {
    // 'c'
    // 012
    // ^
    char c = ctx.CHAR().getText().toCharArray()[1];
    return new CharValue(c);
  }

  @Override
  public StringValue visitStrConcat(StrConcatContext ctx) {
    ExpValue<?> left = (ExpValue<?>) visit(ctx.exp(0));
    ExpValue<?> right = (ExpValue<?>) visit(ctx.exp(1));
    return new StringValue(left.strConcat(right));
  }

  @Override
  public StmtValue visitPrint(PrintContext ctx) {
    ExpValue<?> val = (ExpValue<?>) visit(ctx.exp());

    System.out.println(val.toJavaValue().toString());

    return StmtValue.INSTANCE;
  }

  @Override
  public StringValue visitToStr(ToStrContext ctx) {
    ExpValue<?> val = (ExpValue<?>) visit(ctx.exp());
    return new StringValue(val.toJavaValue().toString());
  }
}
