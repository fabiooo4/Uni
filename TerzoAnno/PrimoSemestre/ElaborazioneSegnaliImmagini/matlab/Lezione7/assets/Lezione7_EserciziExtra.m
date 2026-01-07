% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego 
% Lezione 7: Esercizi extra 



%% Esercizio 3 -  Implementazione filtraggio locale mediano
% 
% - Implementare il filtraggio locale per un filtro Mediano 3x3 (senza usare 
%   medfilt2), e applicarla all’immagine butterfly.jpg
% - Suggerimenti:
%   - Con un doppio ciclo for si scorre tutta l’immagine
%   - Per ogni posizione, si estrae l’intorno, si calcola il nuovo valore 
%     (la mediana) e lo si salva nella posizione corrispondente 
%     nell’immagine filtrata
% 
% - Nota Importante: occorre gestire i problemi ai bordi: 
%   - Usare l’opzione “replicate”
%   - Idea: replico la prima/ultima riga/colonna, calcolo il filtraggio, 
%     rimuovo l'informazione in più

clear all
close all
clc

A = imread('butterfly.jpg');
A = rgb2gray(A);
figure; imshow(A); set(gcf,'name','Immagine Partenza');

% ...






%% Esercizio 4. Caso di studio reale
%
% - Riuscire a migliorare il piu' possibile la qualita' della
%   scrittura nel file hand.png, utilizzando gli strumenti visti fino ad ora
% - Suggerimento: ragionare sull'istogramma, e utilizzare sia operatori
%   puntuali (lezione scorsa) che operatori locali (questa lezione)

clear all; close all; clc

img = imread('hand.png');

figure(1);
imshow(img); title('Originale')


% ...



%% Esercizio 5. Casi reali
% - Trovare piu' informazioni possibili dall'immagine 'fogBN.jpg', ed in
%   particolare rendere massimamente visibili le informazioni sulle macchine 
%   (targhe in primis) usando tutti gli strumenti visti finora.
% - Alcune domande a cui rispondere: In che stato ci troviamo? Si leggono le targhe?
% - Suggerimento: lavorare su parti specifiche dell'immagine (crop con la funzione imcrop)

clear all; close all; clc 

img = imread('fogBN.jpg');
figure;
set(gcf,'name','Analisi targhe: Originale');
imshow(img); title('Originale')

% ...


