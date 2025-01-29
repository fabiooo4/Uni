package it.univr.instructions;

@SuppressWarnings("serial")
public class IllegalProgramException extends Exception {
  IllegalProgramException(String message) {
	  super(message);
  }
}
