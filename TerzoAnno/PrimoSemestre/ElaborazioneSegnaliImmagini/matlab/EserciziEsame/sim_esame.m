%% Esercizio 1
% Il seguente codice, che mira a implementare un’operazione di filtraggio puntuale, contiene
% un errore semantico.
% 1. Si indichi dove si trova l’errore e come potrebbe essere corretto
% 2. Si indichi di che operatore si tratta
% Si prega di giustificare brevemente le risposte.

I = imread ('assets/cameraman.tif') ;
figure , imshow ( I ) ;
I = double(I) ;

r_max = max(I(:)) ;
r_min = min(I(:)) ;
a = 0;
b = 255;

LUT =[];
for i = 0:255
  r = i ;
  if r <= r_max && r >= r_min
    s = ((r - r_min) /(r_max - r_min)) * (b - a) + a; % Errore qua
  else
    s = r ;
  end
  LUT(i+1) = s ;
end
Inew = uint8 ( LUT ( I +1) ) ;
figure , imshow ( Inew ) ;

% Questo è l'operatore di stretching/shrinking
%%

%% Esercizio 2
% Il seguente codice, che mira a implementare un’operazione di filtraggio puntuale, contiene
% un errore di natura semantica.
% 1. Si indichi dove si trova l’errore e come potrebbe essere corretto
% 2. Si indichi di che operatore si tratta
% Si prega di giustificare brevemente le risposte

I = imread('assets/cameraman.tif') ;
figure , imshow(I) ;
a = 100;
b = 200;
LUT = zeros(1,256) ;

% L'errore è che questo for inizia da 1 e quindi non si considerano tutti i pixel
% neri. Bisogna cambiare l'indice della LUT perchè gli array iniziano da 1.
for i = 0:255
  r = i ;
  if r < a
    LUT ( i+1 ) = a ;
  elseif r <= b && r >= a
    LUT ( i+1 ) = r ;
  elseif r > b
    LUT ( i+1 ) = b ;
  end
end
Inew = uint8(LUT(I+1)) ;
figure , imshow(Inew) ;

% Questo è l'operatore di clamping
%%

%% Esercizio 3
% Il seguente codice deve implementare un’operazione di filtraggio puntuale (pixel-wise) che,
% processando l’immagine di sinistra, ritorni l’immagine di destra.
% 1. Si indichi qual `e l’istruzione mancante a riga 7
% 2. Si indichi di che operatore si tratta
% Si prega di giustificare brevemente le risposte.

I = imread ( 'assets/cameraman.tif');
figure, imshow ( I ), title ('Immagine originale')

LUT =[];
for i = 0:255
  r = i ;
  % Bisogna invertire il valore di grigio
  LUT(i + 1) = 255 - r;
end

I_new = uint8 (LUT(I + 1)) ;
figure;
imshow(I_new ), title ('Immagine filtrata')

% Questo è l'operatore negativo.
%%

%% Esercizio 4
% Il seguente codice deve implementare un’operazione di filtraggio locale (spaziale) che, pro-
% cessando l’immagine di sinistra, ritorni l’immagine di destra.
% 1. Si indichi qual `e l’istruzione mancante a riga 5
% 2. Si indichi che operatore viene utilizzato
% Si prega di giustificare brevemente le risposte.

I = imread('assets/peppers.png') ;
I = rgb2gray(I) ;
figure, imshow(I), title ('Immagine originale')

% Bisogna generare il kernel
H = fspecial("average", 10);
I_new = imfilter (I, H, 'replicate') ;

figure, imshow(I_new), title('Immagine filtrata')

% Questo è l'operatore di filtraggio locale.
%%

%% Esercizio 5
% Il seguente codice mira a calcolare lo spettro di ampiezza della trasformata di Fourier 1D del
% segnale y, riordinarlo e visualizzarlo nel corretto range delle frequenze. Il codice contiene un
% errore di natura semantica.
% 1. Si indichi dove si trova l’errore e come potrebbe essere corretto
% 2. Si individui la frequenza di campionamento e si dica se avremo il fenomeno dell’aliasing
% Si prega di giustificare brevemente le risposte

Dt = 0.01;
fc = 1/ Dt;
t = 0: Dt :1 - Dt;
N = length(t);

fsig = 10;
y = sin(2* pi * fsig * t );
Y = fft(y) ;
YY = fftshift(Y);

% L'errore si trova qui perchè se in ingresso si ha un segnale campionato in
% N punti con una frequenza di campionamento fc, l'operazione fft ritorna lo
% spettro delle frequenze campionato ogni fc/N Hz. L'errore sta nell'usare
% la frequenza del segnale al posto della frequenza di campionamento.
% mu = - fsig /2: fsig / N :( fsig /2 - fsig / N ) ;
mu = - fc /2: fc / N :( fc /2 - fc / N ) ;
figure, stem (mu, abs(YY)) ;
title('DFT del segnale');
xlabel('frequenze ( Hz )');
ylabel('magnitudo');

% La frequenza di campionamento è 1/0.1 Hz. Non si presenta aliasing perchè
% la frequenza di campionamento supera fsig*2 (Teorema di Nyquist).
%%

%% Esercizio 6
% Il seguente codice, che mira a implementare manualmente la cross correlazione 1D come
% implementata dal comando Matlab xcorr, contiene un errore di natura semantica.
% Si indichi dove si trova l’errore e come potrebbe essere corretto. Si prega di giustificare
% brevemente le risposte.

x1 = [1 1 1 1 1 1 1 1]; % segnale 1
x2 = [1 2 3 4 5 6 7 8]; % segnale 2

M = length(x1) ;
N = length(x2) ;
% L'errore sta qua perchè i valori totali di cross correlazione è M + N - 1
% C = M + N + 1;
C = M + N - 1;

tx1 = [ zeros(1 ,N -1) ,x1 , zeros(1 ,N -1) ];
tx2 = [ x2, zeros(1 ,2*N - 2)];

xC = zeros(1 , C) ;
for i = 1:C
  xC ( i ) = sum(tx1.*tx2) ;
  tx2 ( end ) = [];
  tx2 = [0 tx2];
end

xC
%%

%% Esercizio 7
% Il seguente codice mira ad effettuare una classica analisi di Fourier del segnale f definito a
% riga 7. In particolare il codice calcola lo spettro di ampiezza della trasformata di Fourier 1D
% del segnale, lo riordina e lo visualizza nel corretto range delle frequenze, ottenendo la figura
% visualizzata qui sotto.
% 1. Si indichi qual `e l’istruzione mancante a riga 6.
% 2. Si indichi se si verifica o meno il fenomeno dell’aliasing.
% Si prega di giustificare brevemente le risposte.

mu_s = 100;
Dt = 1/ mu_s ;
t = -0.5: Dt :0.5 - Dt ;
N = length ( t ) ;

% ??? Manca la frequenza del segnale che è ricavata dall'immagine del documento.
mu = 20;
f = sin (2* pi * mu * t ) ;

F = fft ( f ) ;
Fs = fftshift ( F ) ;
mu_max = mu_s /2;
mu_sampling = mu_s / N ;
mu = - mu_max : mu_sampling : mu_max - mu_sampling ; % nuovo vettore frequenze
figure
stem ( mu , abs ( Fs ) , 'LineWidth' ,3)
xlabel ( 'frequenza(Hz)')
ylabel ( '|Fs|')
grid
title ( 'DFT (abs) con riordinamento') ;

% Non si presenta aliasing perchè la frequenza di campionamento (100Hz) è maggiore
% della frequenza del segnale * 2 (Frequenza di Nyquist)
%%

%% Esercizio 8
% Il seguente codice mira a calcolare la matrice di cross correlazione 2D tra la matrice visual-
% izzata in figura (a sinistra) e una matrice template definita nelle righe 3 e 4 del codice.
% 1. Che istruzione va aggiunta a riga 4 per far s`ı che il codice produca in uscita la matrice
% di cross correlazione 2D riportata nella parte destra della figura?
% Si prega di giustificare brevemente la risposta.

% Uso un array perchè l'immagine non è fornita
immagine = [
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0;
  0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0;
  0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 1 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
];

figure, imshow(immagine);

template = 0.2* ones(9) ;
% ?? Bisogna creare il template con una riga orizzontale
template(3,:) = 1;

cc = xcorr2 ( immagine , template ) ;
figure, imagesc(cc)
title ('Matrice di cross correlazione 2 D')
%%
