package it.univr.pl;

/**
 * IntExprImp
 *
 * Implements semantics for the grammar
 */
public class IntExprImp extends IntExprBaseVisitor<Integer> {
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
  public Integer visitMain(IntExprParser.MainContext ctx) {
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
  public Integer visitAdd(IntExprParser.AddContext ctx) {
    // Interpret left and right expressions
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left + right;
  }

  /**
   * Interprets the mul tree
   *
   * @param ctx
   * @return
   *
   */
  @Override
  public Integer visitMul(IntExprParser.MulContext ctx) {
    Integer left = visit(ctx.exp(0));
    Integer right = visit(ctx.exp(1));

    return left * right;
  }

  /**
   * Interprets the integer value
   *
   * @param ctx
   * @return
   *
   */
  @Override
  public Integer visitVal(IntExprParser.ValContext ctx) {
    // Parse an integer from a string
    return Integer.parseInt(ctx.getText());
  }
}
