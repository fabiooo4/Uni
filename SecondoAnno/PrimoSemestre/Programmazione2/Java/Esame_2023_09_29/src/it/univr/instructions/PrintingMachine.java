package it.univr.instructions;

import java.util.List;

public class PrintingMachine extends SimpleMachine {

	public PrintingMachine(List<Instruction> program) throws IllegalProgramException {
		super(program);
	}

	@Override
	protected void execute(Instruction ins, List<Integer> stack) throws IllegalProgramException {
		System.out.print(ins + ": ");
		ins.execute(stack);
		System.out.println(stack.toString());
	}
}
