package it.univr.bank;

import java.util.HashMap;

public class SimpleBank implements Bank {
	private HashMap<String, Double> accounts = new HashMap<String, Double>();

	protected HashMap<String, Double> getAccounts() {
		return accounts;
	}

	@Override
	public double balanceOf(String account) throws BankException {
		Double value = accounts.get(account);

		if (value == null)
			throw new BankException("Account non esiste");

		return value;
	}

	@Override
	public void deposit(String to, double amount) {
		if (to == null)
			throw new IllegalArgumentException("L'account non esiste");

		if (amount < 0)
			throw new IllegalArgumentException("Non puoi depositare una quantità negativa");

		try {
			Double currentValue = balanceOf(to);
			accounts.put(to, currentValue + amount);
		} catch (BankException e) {
			accounts.put(to, amount);
		}
	}

	@Override
	public void withdraw(String from, double amount) throws BankException {
		if (from == null)
			throw new IllegalArgumentException("L'account non esiste");

		if (amount < 0)
			throw new IllegalArgumentException("Non puoi ritirare una quantità negativa");

		Double currentValue = balanceOf(from);

		if (currentValue < amount)
			throw new BankException("Non hai abbastanza soldi");

		accounts.put(from, currentValue - amount);
	}

	@Override
	public void transfer(String from, String to, double amount) throws BankException {
		if (from == null || to == null)
			throw new IllegalArgumentException("L'account non esiste");

		if (amount < 0)
			throw new IllegalArgumentException("Non puoi trasferire una quantità negativa");

		Double currentValue = balanceOf(from);

		if (currentValue < amount)
			throw new BankException("Non hai abbastanza soldi");

		withdraw(from, amount);

		deposit(to, amount);
	}

}
