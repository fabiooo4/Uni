%  Generare un numero casuale con il comando randn  (distribuzione normale standard)
%  Assegnare alla variabile y il valore 1 se tale numero e'  compreso tra -1 e 1 (media +- deviazione standard), 0  altrimenti.
%  Se ripeto il procedimento 10000 volte, quante volte il  numero casuale cade nell'intervallo [-1 1]?
%  EXTRA: Provare a risolvere l'esercizio anche senza  usare cicli (suggerimento: consultate l'help della  funzione randn) 

%
rand_number = randn(10000, 1);
disp('Numero casuale:');
disp(rand_number);

y = rand_number > -1 & rand_number < 1;
disp('Il numero casuale è compreso tra -1 e 1?:');

total = sum(y);
disp("Volte in cui il numero casuale cade nell'intervallo [-1, 1]:")
disp(total);
%
