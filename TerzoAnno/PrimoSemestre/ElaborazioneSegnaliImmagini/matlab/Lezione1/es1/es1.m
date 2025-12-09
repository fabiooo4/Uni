%  Definire i seguenti tre vettori:
%    A vettore riga che contiene i numeri pari da 2 fino  a 20
%    B vettore riga con tutti i numeri da -22 a -13
%    C vettore riga con 10 valori uguali a 0.
%
%  A partire da questi, efefttuare le seguenti operazioni
%    Creare una matrice MatX dove le righe sono  costituite da A, B e C (in questo ordine)
%    Verificare e salvare le dimensioni di MatX e il  numero di elementi 

%%
A = 2:2:20;
B = -22:-13;
C = zeros(1,10);

MatX = [A;B;C];
disp('Matrice MatX:');
disp(MatX);

sz = size(MatX);
el = numel(MatX);
disp('Dimensione di MatX:');
disp(sz);
disp('Numero di elementi in MatX:');
disp(el);
%%

%  Estrarre la sotto-matrice che contiene le prime due  righe e le prime cinque colonne
%  Sostituire la seconda colonna di MatX con il valore  31
%  Creare una matrice MatY di numeri reali distribuiti in  modo random (randn),
%   con 4 righe e 10 colonne
%  Creare una matrice MatZ data dalla concatenazione  di MatX,
%   MatY e di nuovo MatX
%  Verifciare le dimensioni di MatZ ed estrarre la  diagonale. 

%%
subMatX = MatX(1:2,1:5);
disp('Sotto-matrice di MatX (prime due righe e prime cinque colonne):');
disp(subMatX);

MatX(:,2) = 31;
disp('Matrice MatX dopo aver sostituito la seconda colonna con 31:');
disp(MatX);

MatY = randn(4, 10);
disp('Matrice MatY (4 righe e 10 colonne di numeri reali random):');
disp(MatY);

MatZ = [MatX; MatY, MatX];
disp('Matrice MatZ (concatenazione di MatX, MatY e di nuovo MatX):');
disp(MatZ);

size_MatZ = size(MatZ);
diag_MatZ = diag(MatZ);
disp('Dimensioni di MatZ:');
disp(size_MatZ);
disp('Diagonale di MatZ:');
disp(diag_MatZ);
%%
