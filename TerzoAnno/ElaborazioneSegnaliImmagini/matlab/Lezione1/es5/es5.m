% Scrivere una funzione, checksym, che dia 1 se la  matrice inserita è simmetrica, 0 altrimenti.
%  Nota: la simmetria è defniita per matrici quadrate:
%    Controllare che l’ingresso sia efefttivamente una matrice (che non sia un
%     vettore o una matrice ndimensionale)
%    Controllare che l’ingresso sia una matrice quadrata
%  Suggerimento: una matrice simmetrica è uguale alla  sua trasposta
%  Nota: in matlab la trasposta si ottiene con l’apice:
%  A = [1 2 3; 2 4 5; 3 5 6];
%  At = A';

%%
A = [1 2 3; 2 4 5; 3 5 6];
is_symmetric = checksym(A);
if (is_symmetric)
  disp("The matrix is symmetric")
else
  disp("The matrix is not symmetric")
end
%%
