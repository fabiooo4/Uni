% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego 
% Lezione 6: Esercizi extra 


%% Esercizio 3
% Provare a recuperare dettagli non visibili presenti nell'immagine
% 'xray.png'.
% - 'xray.png' rappresenta un'immagine ai raggi x per la valutazione di tumori
%   ai polmoni. Un'ulteriore analisi senza aggiungere altre radiazioni
%   vorrebbe controllare i dischi vertebrali, in particolare il loro aspetto.
% - Provare ad applicare una operazione puntuale per evidenziare le
%   suddivisioni orizzontali della spina vertebrale. Che operazione
%   dobbiamo applicare?

clear all
close all
clc

img = imread('xray.png');
img = rgb2gray(img);
figure; set(gcf,'name','Immagine originale raggi x')
imshow(img); colorbar

% ...









%% Esercizio 4 
% - Provare a segmentare l'oggetto dallo sfondo nelle immagini definite nel file
%   Lezione6_EserciziExtra.m
% - Applicare l'algoritmo di binarizzazione: utilizzare sia soglie settate 
%   a mano che la soglia ottimale determinata da Matlab (metodo di Otsu)
%   T = graythresh(I) -> ritorna la soglia ottimale per la binarizzazione
%   (si veda help graythresh)
% - Vedere l'effetto della segmentazione oggetto/sfondo al variare delle soglie

clear all
close all
clc

% Lista immagini, li metto in un array di celle
Im{1} = imread('coins.png');
Im{2} = rgb2gray(imread('pag136.jpg'));
Im{3} = imread('moon.tif');
Im{4} = imread('eight.png');
Im{5} = imread('quarter.png');
Im{6} = imread('rice2.png');
Im{7} = imread('rice3.png');
Im{8} = imread('saturn2.png');


% ...



%% Esercizio 5 
% - Studiare il metodo di binarizzazione di Otsu (descritto nel pdf "OtsuMethod.pdf", 
%   non sarà parte dell'esame) e implementarlo a mano
% - Applicarlo all'immagne 'moon.tif' e confrontare la soglia ottenuta 
%   con quella identificata automaticamente da MATLAB con il comando 
%   "graythresh" 

clear all
close all
clc

B = imread('moon.tif');

% ...



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ALTRI ESEMPI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Esempio 1 --- Thresholding & Sostituzione Background 
% Scopo dell'esercizio e' quello di applicare una sogliatura ad un'immagine
% RGB e sostuire il background con uno a piacere. Attenzione a non
% rimuovere pixel anche all'interno dell'immagine stessa! 

clear all
close all
clc

img = imread('Tigre.jpeg');
bkgr = imread('BG.png');
[nr,nc,ns]=size(img);
J = imresize(bkgr,[nr nc]);

figure(1), subplot(221), imshow(img), title('Immagine Originale')
img_r = img(:,:,1);
img_g = img(:,:,2);
img_b = img(:,:,3);
subplot(222), imshow(img_r), title('Red'), colorbar
subplot(223), imshow(img_g), title('Green'), colorbar
subplot(224), imshow(img_b), title('Blue'), colorbar

% Idea: trovo l'oggetto sui tre canali R,G,B con la binarizzazione
% Calcolo le soglie col metodo ottimale (metodo di Otsu)
thr_r = 255*graythresh(img_r);
thr_g = 255*graythresh(img_g);
thr_b = 255*graythresh(img_b);

% visualizzo la binarizzazione 
figure(1), subplot(221), imshow(img), title('Immagine Originale')
subplot(222), imshow(img_r>thr_r), title('Red'), colorbar
subplot(223), imshow(img_g>thr_g), title('Green'), colorbar
subplot(224), imshow(img_b>thr_b), title('Blue'), colorbar

% Cerco di identificare il background:
% Per red è sotto la soglia, per blue e green è sopra

img_mod = img;
for i=1:nr
    for j=1:nc
        %  controllo se ho il background per tutti e tre i canali
        if (img_r(i,j)<=thr_r) & (img_g(i,j)>thr_g) & (img_b(i,j)>thr_b)
            % background: sostituisco con J
            img_mod(i,j,:) = J(i,j,:);
        end
    end
end

figure,set(gcf,'name','Sostituzione Background'),imshow(img_mod,[]), colorbar 
% Risultato non perfetto, provate ad aggiustare a mano le soglie


%% Esempio 2 --- Equalizzazione istogramma 
% Massimizzare il contrasto dell'istogramma attraverso l'equalizzazione
% dell'istogramma con il comando histeq.
% Confrontare il risultato con uno stretching lineare dell'istogramma, 
% visualizzando in tutti i casi immagine e istogramma.  

clear all
close all
clc

img = imread('china.png');
img = rgb2gray(img);
figure;
set(gcf,'name','Equalizzazione istogramma: Originale');
subplot(121); imshow(img); title('Originale')
subplot(122); imhist(img); title('Istogramma')
H = imhist(img);

% Implementazione equalizzazione istogramma con histeq
[newimg,LUT] = histeq(img);
figure; set(gcf,'name','Equalizzazione istogramma');
subplot(121); imshow(newimg);  title('Equalizzata')
subplot(122); imhist(newimg);  title('Istogramma')
H = imhist(newimg);


% Stretching lineare 
[rows,cols]=size(img);
r_max = double(max(img(:))); 
r_min = double(min(img(:))); 
a=0;   
b=255;
newimg = imadjust(img,[r_min,r_max]./255,[a,b]./255);

figure; set(gcf,'name','Stretching lineare istogramma');
subplot(121); imshow(uint8(newimg)); title('Immagine con stretching') 
subplot(122); imhist(uint8(newimg)); title('Istogramma') 
H = imhist(newimg); 


%% Esempio 3 --- Operatori puntuali per immagini RGB ---
% Scopo dell'esercizio e' quello di applicare ad una immagine RGB varie
% operazioni puntuali, in particolare: negativo, stretching ed equalizzazione
% istogramma. 
clear all
close all

img = imread('WindowPainting.png');
img_r = img(:,:,1);
img_g = img(:,:,2);
img_b = img(:,:,3);
img11 = img;
t1 = 20;  
t2 = 150;  

for i=1
    img11_1(:,:,i) = 255 - img11( :, :, i ); % negativo
    img11_3(:,:,i) = imadjust(img11(:,:,i),[t1,t2]./255,[0,255]./255); % stretching
    img11_4( :, :, i ) = histeq(img11(:,:,i));  % histogram equalization
end

% Visualizzo e confronto i risultati 
figure(26), subplot(2, 2, 1), imshow(uint8(img11),[]), title('Original Picture'), colorbar
subplot(2, 2, 2), imshow(uint8(img11_1),[]), title('Negative Film'), colorbar
subplot(2, 2, 3), imshow(img11_3,[]), title('Contrast Clip & Stretch'), colorbar
subplot(2, 2, 4), imshow(img11_4,[]), title('Histogram Equalization'), colorbar
