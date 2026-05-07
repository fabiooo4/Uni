package it.univr.pl;

import java.util.HashMap;
import java.util.Map;

import it.univr.pl.ImpParser.ExpContext;
import it.univr.pl.value.ExpValue;

/**
 * Mem
 */
public class Mem {
  private final Map<String, ExpValue<?>> memory = new HashMap<String, ExpValue<?>>();

  public boolean contains(String id) {
    return memory.containsKey(id);
  }

  public ExpValue<?> get(String id) {
    return (ExpValue<?>) memory.get(id);
  }

  public void update(String id, ExpValue<?> val) {
    memory.put(id, val);
  }

}
