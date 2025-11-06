%  Scrivere una funzione, MYflip, che dato un vettore
%    ne crei una copia “rifelssa” (per esempio, da [1 2  3] ottengo [3,2,1])  
%    La concateni a sinistra al vettore originale (ossia  [3,2,1,1,2,3])  
% A = [1 2 3]
% A_flipped = [3 2 1 1 2 3]

%%
A = [1 2 3];
A_flipped = flip_append(A);
disp(A_flipped)
%%
