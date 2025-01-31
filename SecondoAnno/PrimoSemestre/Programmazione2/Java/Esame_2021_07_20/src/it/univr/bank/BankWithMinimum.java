package it.univr.bank;

public class BankWithMinimum extends SimpleBank {

	@Override
	public void deposit(String to, double amount) {
		try {
			balanceOf(to);
		} catch (BankException e) {
			if (amount < 100)
				throw new IllegalArgumentException("Non creare un account con meno di 100 euro");
		}

		super.deposit(to, amount);
	}

	@Override
	public void withdraw(String from, double amount) throws BankException {
		Double currentValue = balanceOf(from);

		if (currentValue - amount < 100)
			throw new IllegalArgumentException("Non puoi avere un account con meno di 100 euro");

		super.withdraw(from, amount);
	}

	@Override
	public void transfer(String from, String to, double amount) throws BankException {
		withdraw(from, amount);
		deposit(to, amount);
	}
}
