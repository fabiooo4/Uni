package it.univr.instructions;

import java.util.List;

public class PUSH implements Instruction {
	private int value;

	public PUSH(int value) {
		this.value = value;
	}

	@Override
	public void execute(List<Integer> stack) {
		stack.add(value);
	}

	@Override
	public String toString() {
		return "push(" + value + ")";
	}
}
