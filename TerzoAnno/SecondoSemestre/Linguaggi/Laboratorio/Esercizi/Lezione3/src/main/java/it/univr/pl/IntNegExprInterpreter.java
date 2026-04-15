package it.univr.pl;

import it.univr.pl.IntNegExprParser.ModContext;
import it.univr.pl.IntNegExprParser.NegContext;
import it.univr.pl.IntNegExprParser.ParenContext;
import it.univr.pl.IntNegExprParser.SubContext;
import it.univr.pl.IntNegExprParser.ValContext;

/**
 * IntNegExprImp
 *
 * Implements semantics for the grammar
 */
public class IntNegExprInterpreter extends IntNegExprBaseVisitor<Integer> {
  @Override
  public Integer visitMain(IntNegExprParser.MainContext ctx) {
    return visit(ctx.exp());
  }

  @Override
  public Integer visitAdd(IntNegExprParser.AddContext ctx) {
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
  public Integer visitMul(IntNegExprParser.MulContext ctx) {
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left * right;
  }

  @Override
  public Integer visitDiv(IntNegExprParser.DivContext ctx) {
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
  public Integer visitVal(IntNegExprParser.ValContext ctx) {
    // Parse an integer from a string
    return Integer.parseInt(ctx.getText());
  }
}
