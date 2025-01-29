package it.univr.instructions;

import java.util.List;

public class DIV implements Instruction {

	public DIV() {

	}

	@Override
	public void execute(List<Integer> stack) throws IllegalProgramException {
		if (stack.size() < 2)
			throw new IllegalProgramException("Operandi insufficienti per un’operazione binaria ");
		
		int op2 = stack.removeLast();
		
		if (op2 == 0)
			throw new IllegalProgramException("Divisione per 0");
		
		int op1 = stack.removeLast();
		
		stack.add(op1 / op2);
	}

	@Override
	public String toString() {
		return "div";
	}
}
