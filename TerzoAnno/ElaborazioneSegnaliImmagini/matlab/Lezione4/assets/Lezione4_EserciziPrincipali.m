% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego 
% Lezione 4: Esercizi principali 



%% Esempio 1 - Cross-correlazione 2D
% Controllate rispetto a quanto visto in teoria se tornano i conti: 
 
X1 =[1     2     5     2     5;
     3     4     5     4     2;
     5     2     3     2     2;
     2     3     2     4     2;
     3     4     2     2     3];
     
     
X2 =[3     3     2;
     2     3     4;
     4     5     4];
 
Corr = xcorr2(X1,X2);
size(Corr)



%% Esercizio 1
% Matching 2D
% Usare la cross correlazione 2D per trovare la posizione del template 
% nell'immagine
% In particolare si richiede di calcolare di quanto (righe-colonne) 
% il template è stato traslato rispetto all’angolo in alto a sinistra 
% dell’immagine
%
% Suggerimento: calcolare la cross correlazione (xcorr2) tra l'immagine 
% e il template (kernel), estrarre le coordinate del massimo e 
% recuperare la posizione del kernel
% 
% Controllare anche l'help della funzione xcorr2

clear all
close all

% Template: una croce
template = 0.2*ones(55);
template(29:31,15:45) = 0.6;
template(15:45,29:31) = 0.6;


% Immagine: si posiziona il template con un offset 
immagine = 0.2*ones(111);
offset = [10 40];
immagine(offset(1):offset(1)+size(template,1)-1,offset(2):offset(2)+size(template,2)-1) = template;

figure
imshow(template,[])
title('Template')

figure
imshow(immagine,[])
title('Immagine')

% ...


%% Esercizio 2
% Implementazione manuale della cross-correlazione 2D
% Calcolare manualmente la cross correlazione 2D tra le 
% matrici X1 e X2. Confrontare con il risultato del comando matlab
% xcorr2(X1,X2)
%
% Suggerimento: usare la versione più ottimizzata:
% si fa zero padding della matrice immagine (la matrice più
% grande) e si fa scorrere il kernel
% 

clear all
close all

X1 =[1     2     5     2     5;
     3     4     5     4     2;
     5     2     3     2     2;
     2     3     2     4     2;
     3     4     2     2     3];
     
     
X2 =[3     3     2;
     2     3     4;
     4     5     4];

 
[R1, C1] = size(X1);
[R2, C2] = size(X2);

% ...




