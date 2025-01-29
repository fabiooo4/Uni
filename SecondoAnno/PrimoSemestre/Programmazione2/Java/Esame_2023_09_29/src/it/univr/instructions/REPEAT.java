package it.univr.instructions;

import java.util.List;

public class REPEAT implements Instruction {
	private int c;
	private Instruction ins;

	public REPEAT(int c, Instruction ins) throws IllegalProgramException {
		if (c < 0)
			throw new IllegalProgramException("Impossibile ripetere un numero negativo di volte");
		
		this.c = c;
		this.ins = ins;
	}

	@Override
	public void execute(List<Integer> stack) throws IllegalProgramException {
		for (int i = 0; i < c; i++) {
			ins.execute(stack);
		}
	}

	@Override
	public String toString() {
		return "repeat(" + c + ", " + ins + ")";
	}
}
