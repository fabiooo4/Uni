package it.univr.pl;

import java.util.HashMap;

import it.univr.pl.ImpParser.AddContext;
import it.univr.pl.ImpParser.DeclarationContext;
import it.univr.pl.ImpParser.DivContext;
import it.univr.pl.ImpParser.MainContext;
import it.univr.pl.ImpParser.ModContext;
import it.univr.pl.ImpParser.MulContext;
import it.univr.pl.ImpParser.NegContext;
import it.univr.pl.ImpParser.ParenContext;
import it.univr.pl.ImpParser.PowContext;
import it.univr.pl.ImpParser.SubContext;
import it.univr.pl.ImpParser.ValContext;
import it.univr.pl.ImpParser.VarContext;

/**
 * ImpImp
 *
 * Implements semantics for the grammar
 */
public class ImpInterpreter extends ImpBaseVisitor<Float> {
  static HashMap<String, Float> memory = new HashMap<String, Float>();

  @Override
  public Float visitMain(MainContext ctx) {
    return visit(ctx.prog());
  }

  @Override
  public Float visitAdd(AddContext ctx) {
    Float left = visit(ctx.exp(0));
    Float right = visit(ctx.exp(1));

    return left + right;
  }

  @Override
  public Float visitSub(SubContext ctx) {
    Float left = visit(ctx.exp(0));
    Float right = visit(ctx.exp(1));

    return left - right;
  }

  @Override
  public Float visitMul(MulContext ctx) {
    Float left = visit(ctx.exp(0));
    Float right = visit(ctx.exp(1));

    return left * right;
  }

  @Override
  public Float visitPow(PowContext ctx) {
    Float left = visit(ctx.exp(0));
    Float right = visit(ctx.exp(1));

    return (float)Math.pow(left, right);
  }

  @Override
  public Float visitDiv(DivContext ctx) {
    Float left = visit(ctx.exp(0));
    Float right = visit(ctx.exp(1));

    return left / right;
  }

  @Override
  public Float visitMod(ModContext ctx) {
    Float left = visit(ctx.exp(0));
    Float right = visit(ctx.exp(1));

    return left % right;
  }

  @Override
  public Float visitNeg(NegContext ctx) {
    return -visit(ctx.exp());
  }

  @Override
  public Float visitParen(ParenContext ctx) {
    return visit(ctx.exp());
  }

  @Override
  public Float visitVal(ValContext ctx) {
    // Parse a value from a string

    switch (ctx.type.getType()) {
      case ImpParser.INT: {
        return Float.parseFloat(ctx.getText());

      }

      case ImpParser.FLOAT: {
        return Float.parseFloat(ctx.getText());
      }

      default:
        return 0.f; // Unreachable
    }
  }

  /**
   * Get the value of the variable from memory
   * If the variable has not been initialized its value is 0
   */
  @Override
  public Float visitVar(VarContext ctx) {
    String varName = ctx.getText();
    Float val = memory.getOrDefault(varName, 0.f);

    return val;
  }

  /** Declares a variable with a value */
  @Override
  public Float visitDeclaration(DeclarationContext ctx) {
    String varName = ctx.VAR().getText();
    Float val = visit(ctx.exp());

    memory.put(varName, val);

    visit(ctx.decl());

    return val;
  }

}
