package it.univr.pl;

/**
 * IntToStrExprImp
 *
 * Implements semantics for the grammar
 */
public class IntToStrExprInterpreter extends IntExprBaseVisitor<String> {
  /**
   * The main node will have 2 nodes:
   * - The starting node
   * - EOF terminal node
   * 
   * This function visits the starting `exp` symbol
   * 
   * @param ctx
   * @return
   * 
   */
  @Override
  public String visitMain(IntExprParser.MainContext ctx) {
    return visit(ctx.exp());
  }

  /**
   * Interprets the add tree
   *
   * @param ctx
   * @return
   *
   */
  @Override
  public String visitAdd(IntExprParser.AddContext ctx) {
    // Interpret left and right expressions
    String left = visit(ctx.exp(0));
    String right = visit(ctx.exp(1));

    return left + "plus" + right;
  }

  /**
   * Interprets the mul tree
   *
   * @param ctx
   * @return
   *
   */
  @Override
  public String visitMul(IntExprParser.MulContext ctx) {
    String left = visit(ctx.exp(0));
    String right = visit(ctx.exp(1));

    return left + "times" + right;
  }

  /**
   * Interprets the integer value
   *
   * @param ctx
   * @return
   *
   */
  @Override
  public String visitVal(IntExprParser.ValContext ctx) {
    // Parse an integer from a string
    return ctx.getText();
  }
}
