% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego 
% Lezione 4: Esercizi extra 



%% Esercizio 3
% - Caricare l'immagine "puzzle.jpg"
% - Ritagliare un pezzo dell'immagine (suggerimento: imcrop)
% - Utilizzare la cross-correlazione per ritrovare la posizione corretta del 
%   pezzo tagliato 
%   Suggerimenti: 1. convertire l'immagine e il pezzo 
%         ritagliato in scala di grigi, la cross correlazione funziona su
%         matrici -- funzione rgb2gray
%         2. usare la cross correlazione normalizzata -- funzione
%         normxcorr2 (attenzione all'ordine dell'input)
% 
% - Visualizzare il risultato in 4 figure
%     Figura 1: immagine originale
%     Figura 2: pezzo ritagliato
%     Figura 3: matrice di cross correlazione
%     Figura 4: immagine originale a toni di grigio "attenuata"
%               con sovrapposto il pezzo estratto (a colori) nella posizione
%               corretta (Suggerimento: creare un'immagine con 3 canali 
%               (uguali all'immagine originale in scala di grigio -- 
%               per attenuare moltiplicare tutti i valori dell'immagine per 0.6)
%   


clear all
close all
clc

I = imread('puzzle.jpg');

% Ritaglia la sezione di immagine
template = imcrop(I);

% ...



%% Esercizio 4
% Cross-correlazione 2D normalizzata per trovare difetti su tessuti
% - Caricare l'immagine tex.jpg
% - Estrarre alcuni pattern in zone che non contengono difetti
% - Calcolare la cross correlazione dei pattern con l'immagine originale
% - Mediare le matrici di cross correlazione ottenute con i diversi pattern 
%   (per una maggiore robustezza)
%   le zone a bassa cross correlazione indicano i difetti
% 
% Partire dalla traccia presente in Lezione4_EserciziExtra_soluzioni.m
% 


clear all
close all
clc

% Carico immagine e la converto in scala di grigi
A = rgb2gray(imread('tex.jpg'));
[M,N] = size(A);

% Definisco una serie di pattern, tutti quadrati 14x14
R = 14;
C = 14; 
pattern1 = A(1:R,1:C); 
pattern2 = A(2:R+1,2:C+1); 
pattern3 = A(M-13:M,N-13:N);
pattern4 = A(M-14:M-1,N-14:N-1);
pattern5 = A(1:R,N-13:N);
pattern6 = A(2:R+1,N-13:N);

% Visualizzo i pattern sovrapposti all'immagine di partenza (convertita in
% scala di grigi)
figure;
imagesc(A); axis image; colormap gray; hold on;
title ('Tessitura e pattern sovrapposti')
rectangle('position',[1,1,R,C],'EdgeColor','r'); % pattern1
rectangle('position',[2,2,R,C],'EdgeColor','g'); % pattern2
rectangle('position',[M-13,N-13,14,14],'EdgeColor','b'); % pattern3
rectangle('position',[M-14,N-14,14,14],'EdgeColor','c'); % pattern4
rectangle('position',[1,N-13,14,14],'EdgeColor','m'); % pattern5
rectangle('position',[2,N-13,14,14],'EdgeColor','k'); % pattern6

% Calcolo per ogni pattern la cross-correlazione 2D (normalizzata). Attenzione all'ordine delle variabili in input! 
% L'output avra' dimensione (M+R-1,N+C-1)
% From MATLAB Help:
% C = normxcorr2(TEMPLATE,A) computes the normalized cross-correlation of
%     matrices TEMPLATE and A. The matrix A must be larger than the matrix
%     TEMPLATE for the normalization to be meaningful. The values of TEMPLATE
%     cannot all be the same. The resulting matrix C contains correlation
%     coefficients and its values may range from -1.0 to 1.0.
% ...


% Calcolo la cross-correlazione media, che avra' sempre dimensione (M+R-1,N+C-1) 
% ...

% Considero solo la parte di cross-correlazione che e' stata eseguita senza 
% gli zero-padded edges, in modo da rimuovere effetto bordo. Quindi l'output
% avra' dimensioni (M-R+1, N-C+1)
% Hint: matrice_xcorr_reduced = matrice_xcorr(r:(end-r+1),c:(end-c+1));
% ...


% Visualizzo, in un subplot con due riquadri, il valore assoluto della
% cross-correlazione appena stimata sia come surface plot che come immagine
% ...



% Faccio il modulo della cross-correlazione appena stimata, su cui
% lavorero' da qui in avanti
% ...


% A partire dalla cross-correlazione stimata, creo una maschera
% selezionando tutti i valori inferiori a 0.2 e la visualizzo 
% ...


% Creo come elemento strutturale un disco con raggio = 3, da utilizzare poi per eseguire 
% una operazione morfologica di apertura (hint: utilizzare i comandi strel e imopen)
% Il risultato deve essere una variabile chiamata mask2, che va poi
% visualizzata in una nuova figura
% Nota per IMOPEN = Perform morphological opening.
% The opening operation erodes an image and then dilates the eroded image,
% using the same structuring element for both operations.
% Morphological opening is useful for removing small objects from an image
% while preserving the shape and size of larger objects in the image.

se = strel('disk',3); 
mask2 = imopen(mask,se);


% Modifico l'immagine di partenza A in modo che abbia dimensioni uguali alla
% cross-correlazione 
% ...


% Creo una nuova immagine A1, uguale ad A. I pixel che sono pari a 1 nella variabile
% mask2 devono essere messi a 255 in A1 
% ...


% Visualizzo a lato immagine A e immagine con il difetto evidenziato in rosso  
Af = cat(3,A1,A,A);
figure;
imshowpair(A,Af,'montage')
title ('Immagine e Difetto finale')




%% Esempio (già svolto, solo da guardare) 
%  Video stabilizzazione

clear all
close all
load frames; % video preso da: https://www.youtube.com/watch?v=wHsrBJ4ynk4
[nr,nc,ns,nt] = size(frames);
Res = 1.2; 

% Eseguo per tutti i frame una operazione di resize utilizzando il valore
% di scala Res sopra definito e salvo in una nuova variabile temporanea, sempre 4D, che
% chiameremo sub
for i = 1:nt
    sub(:,:,:,i) = imresize(frames(:,:,:,i),Res);
end

frames = sub;
clear sub;
[nR,nC,nS,nT] = size(frames);

% Eseguo operazione di crop nel frame n.10 per trovare una zona di ancoraggio e 
% salvo il risultato in una variabile chiamata template. 
% Converto template in scala di grigi 
figure; template = imcrop(frames(:,:,:,10));
template = rgb2gray(template);
[A,B] = size(template);

figure;
for i=1:nT
    % Prendo il frame e lo salvo in una variabile temporanea comp, che
    % converto poi in scala di grigi (compg)
    comp  = frames(:,:,:,i);
    compg = rgb2gray(comp);
    
    % Eseguo la cross-correlazione normalizzata tra questa e il template.
    % Individuo il punto di massima cross-correlazione e relativo offset
    % (corr_offset)
    cc = normxcorr2(template,compg);
    [max_cc, imax] = max((cc(:)));
    [ypeak, xpeak] = ind2sub(size(cc),imax(1));
    corr_offset = [(ypeak-A+1) (xpeak-B+1)];
   
    % Capire cosa viene eseguito in queste righe
    offset = [-(corr_offset(2)-round(nC/2)-1) -(corr_offset(1)-round(nR/2)-1)];
    new(:,:,:,i) = imtranslate(frames(:,:,:,i),offset,'FillValues',0);
    ccs(:,:,i) = cc;
    
    % Ad ogni ciclo, quindi per ogni frame, definire quattro subplot e visualizzare:
    % 1. template, 2. compg, 3. ccs con evidenziata in sovrapposizione la posizione del picco,
    % 4. new
    subplot(221); imagesc(template); axis image; title('Template scelto');
    subplot(222); imagesc(compg); axis image;  title(strcat('Immagine originale: ', num2str(i)));
    subplot(223); imagesc(ccs(:,:,i)); colorbar; title('Mappa di cross-correlazione 2D');
    hold on;      scatter(xpeak, ypeak,'rX');
    subplot(224); imshow(new(:,:,:,i)); title('Immagine stabilizzata');
    disp (['Frame numero ', num2str(i)])
    drawnow
    pause(0.1)
end
%
% Codice che mi permette di visualizzare affiancati il video originale e
% quello stabilizzato, e infine di salvare in un .avi il risultato
vidObj = VideoWriter('Stabilized_video');
open(vidObj);
figure;
for i=1:nT
    subplot(121); imshow(frames(:,:,:,i));
    subplot(122); imshow(new(:,:,:,i));
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);

end 
close(vidObj);
   
% Esempi tosti di video stabilization si trovano in https://www.youtube.com/watch?v=I6E6InIQ76Q

