package it.univr.pl;

import java.util.HashMap;

import it.univr.pl.IntVarExprParser.DeclarationContext;
import it.univr.pl.IntVarExprParser.ModContext;
import it.univr.pl.IntVarExprParser.NegContext;
import it.univr.pl.IntVarExprParser.ParenContext;
import it.univr.pl.IntVarExprParser.SubContext;
import it.univr.pl.IntVarExprParser.VarContext;

/**
 * IntVarExprImp
 *
 * Implements semantics for the grammar
 */
public class IntVarExprInterpreter extends IntVarExprBaseVisitor<Integer> {
  static HashMap<String, Integer> memory = new HashMap<String, Integer>();

  @Override
  public Integer visitMain(IntVarExprParser.MainContext ctx) {
    return visit(ctx.exp());
  }

  @Override
  public Integer visitAdd(IntVarExprParser.AddContext ctx) {
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left + right;
  }

  @Override
  public Integer visitSub(SubContext ctx) {
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left - right;
  }

  @Override
  public Integer visitMul(IntVarExprParser.MulContext ctx) {
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left * right;
  }

  @Override
  public Integer visitDiv(IntVarExprParser.DivContext ctx) {
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left / right;
  }

  @Override
  public Integer visitMod(ModContext ctx) {
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left % right;
  }

  @Override
  public Integer visitNeg(NegContext ctx) {
    return -visit(ctx.exp());
  }

  @Override
  public Integer visitParen(ParenContext ctx) {
    return visit(ctx.exp());
  }

  @Override
  public Integer visitVal(IntVarExprParser.ValContext ctx) {
    // Parse an integer from a string
    return Integer.parseInt(ctx.getText());
  }

  /**
   * Get the value of the variable from memory
   * If the variable has not been initialized its value is 0
   */
  @Override
  public Integer visitVar(VarContext ctx) {
    String varName = ctx.getText();
    Integer val = memory.getOrDefault(varName, 0);

    return val;
  }

  /** Declares a variable with a value */
  @Override
  public Integer visitDeclaration(DeclarationContext ctx) {
    String varName = ctx.VAR().getText();
    Integer val = visit(ctx.exp());

    memory.put(varName, val);

    return val;
  }
  
}
