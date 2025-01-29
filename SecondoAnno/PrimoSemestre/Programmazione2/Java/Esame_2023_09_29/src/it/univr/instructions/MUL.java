package it.univr.instructions;

import java.util.List;

public class MUL implements Instruction {

	public MUL() {

	}

	@Override
	public void execute(List<Integer> stack) throws IllegalProgramException {
		if (stack.size() < 2)
			throw new IllegalProgramException("Operandi insufficienti per un’operazione binaria ");
		
		int op2 = stack.removeLast();
		int op1 = stack.removeLast();
		
		stack.add(op1 * op2);
	}

	@Override
	public String toString() {
		return "mul";
	}
}
