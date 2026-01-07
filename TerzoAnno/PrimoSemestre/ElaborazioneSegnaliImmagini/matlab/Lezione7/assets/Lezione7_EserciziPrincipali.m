% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego
% Lezione 7: Esercizi principali


% Alcuni comandi utili disponibili nell'Image Processing Toolbox
% imnoise(I, 'gaussian',m) -> aggiunge rumore gaussiano con media m e
% varianza pari a 0.01 (puo' essere cambiata)
%
% normrnd(mu,sigma,sz1,...,szN) -> genero un vettore di numeri random a partire da una
% distribuzione gaussiana con media mu e standard deviation sigma, avente
% dimensione data da sz1, sz2 etc
%
% fspecial(type) -> crea un filtro H 2D di uno specifico tipo (e.g.
% 'average', 'gaussian', etc). Nota = fspecial ritorna un "correlation
% kernel", che puo' essere utilizzato insieme al comando imfilter
%
% imfilter(I,H,'replicate') -> filtra la matrice I con il filtro H. Di default il
% filtraggio e' eseguito con la correlazione, ma si puo' scegliere anche
% convoluzione. "Replicate" e' una delle opzioni piu' usate per la gestione
% dei bordi (padding).
%
% medfilt2 (I,[m n]) -> esegue un filtraggio mediano in due dimensioni. Se
% non si specificano le dimensioni m ed n, di default viene scelto un
% intorno attorno al pixel di 3x3.





%% ESEMPI: creazione e applicazione diversi di filtri di smoothing
% e calcolo SNR
%
% Definisco l'immagine simulata I a cui poi aggiungo rumore gaussiano

clear all
close all
clc

I = ones(128,128).*128;
I(1:64,1:64) = 96;
I(65:128,65:128) = 160;
J = I +normrnd(0,5,128,128);
figure; set(gcf,'name','Studio sintetico rumore e filtraggio');
subplot(221); imagesc(I), colormap gray, axis image; title('Originale')
colorbar
subplot(222); imagesc(J), colormap gray, axis image; title('Noisy')
colorbar

% Calcolo il SNR_{MSE} e SNR_{VAR} nell'immagine di partenza
% f = I (immagine senza rumore)
% ftilde = J (immagine con rumore)
num = sum(J(:).^2);
den = sum((J(:)-I(:)).^2);
SNR1mse = num/den;
SNR1var = var(I(:))/var(J(:));
% Attenzione:
% Se l'immagine è uint8 occorre fare un casting per avere la precisione nei
% calcoli (e la funzione "var" prende in ingresso solo single/double)
% I = double(I);
% J = double(J);
% In questo esempio non ci sono problemi perché è un immagine sintetica
% definita come double

fprintf('SNR img noisy (Gauss)\nMSE: %g\nVAR: %g\n',SNR1mse,SNR1var);


%% Esempio 1: Filtro Media
% Per creare un filtro locale media: fspecial
% si veda doc fspecial
% Creo un filtro media 3x3
H = fspecial('average',3);
% Per applicare il filtro all'immagine: imfilter
Km = imfilter(J,H,'replicate');
% "'replicate'" è un'opzione per gestire il "problema dei bordi"
% si veda l'help di imfilter (--> opzioni/options)
% Visualizzo il risultato
subplot(223); imagesc(Km), colormap gray, axis image; title('Smoothing Media'), colorbar
% Calcolo SNR
SNRMmse = sum(Km(:).^2)/sum((Km(:)-I(:)).^2);
SNRMvar = var(I(:))/var(Km(:));
fprintf('SNR img noisy + Mean smoothing \nMSE: %g\nVAR: %g\n',SNRMmse,SNRMvar);



%% Esempio 2: Filtro Gaussiano
% Per creare un filtro locale gaussiano: fspecial
% filtro gaussiano KxK con standard deviation 0.6
H = fspecial('gaussian',3,0.6);
% Importante: relazione tra K  e sigma:
% K = 5*sigma
Kg = imfilter(J,H,'replicate');


subplot(224); imagesc(Kg), colormap gray, axis image; title('Smoothing Gaussiano'), colorbar
SNRGmse = sum(Kg(:).^2)/sum((Kg(:)-I(:)).^2);
SNRGvar = var(I(:))/var(Kg(:));
fprintf('SNR img noisy + Gaussian smoothing \nMSE: %g\nVAR: %g\n',SNRGmse,SNRGvar);



%% Esempio 3: Filtro Mediano
% In questo esempio si vedra' come e' possibile eliminare il rumore
% impulsivo utilizzando un filtro di smoothing mediano.
clear all
close all
clc

I = imread('saturn2.png');
% aggiungo rumore sale e pepe all'immagine originale
J = imnoise(I,'salt & pepper',0.02);
figure; set(gcf,'name','Studio sintetico rumore e filtraggio');
subplot(221); imagesc(I), colormap gray, axis image; title('Originale')
colorbar
subplot(222); imagesc(J), colormap gray, axis image; title('Noisy')
colorbar
% casting per il calcolo del SNR
I = double(I);
J = double(J);
SNR1mse = sum(J(:).^2)/sum((J(:)-I(:)).^2);
SNR1var = var(I(:))/var(J(:));
fprintf('SNR img noisy (Salt-pepper)\nMSE: %g\nVAR: %g\n\n',SNR1mse,SNR1var);


% per applicare il filtro mediano si usa
% la funzione medfilt2
Kmed = medfilt2(J);
% senza parametri si applica un filtro 3x3
subplot(223); imagesc(Kmed), colormap gray, axis image; title('Smoothing Mediano'), colorbar

SNRMedmse = sum(Kmed(:).^2)/sum((Kmed(:)-I(:)).^2);
SNRMedvar = var(I(:))/var(Kmed(:));
fprintf('SNR img noisy (Salt-pepper) + Median smoothing\nMSE: %g\nVAR: %g\n\n',SNRMedmse,SNRMedvar);



%% Esempio 4 -  Filtraggio Locale: Sharpening ---
% Esempio di applicazione di sharpening.

clear all; close all; clc

A = imread('moon.tif');
figure; imshow(A); title ('Immagine partenza')

alpha = 0.2; %valore di default
H = fspecial('laplacian',alpha);
B = imfilter(A,H);
figure; imshow(B); title (['Filtraggio sharpening con Laplaciano Alpha = ', num2str(alpha)])

% Basic highpass spatial filtering
% L'immagine finale è l'immagine originale
% sommata con l'immagine filtrata con il laplaciano
cost = -1; % valore centrale di H è negativo
C = double(A) + cost*double(B);
figure; imshow(uint8(C)), colormap gray, axis image; title('Immagine finale (basic highpass)')



%% Esercizio 1. Smoothing
%
% - Applicare diversi filtri di smoothing alle immagini reali definite
%   sotto 
% - Variare il tipo di filtro (media, gaussiano, mediano) e variare la
%   dimensione della maschera
%     - Per il filtro Gaussiano: fare attenzione a stimare 
%       correttamente la deviazione standard del filtro con la regola
%       K = 5*sigma
% - Confrontare i risultati in modo qualitativo e rispondere, per ogni 
%   immagine, alle seguenti domande: 
%     - In generale, funziona meglio un filtro Media, un filtro 
%       Gaussiano o un filtro Mediana?
%     - Considerando il filtro ottimale: cosa succede quando cambio 
%       la dimensione della maschera?
%     - Qual'è la dimensione ottimale? 
% 
%  Nota: l'obiettivo è cercare di eliminare la maggior quantità possibile
%  di rumore cercando però di mantenere al massimo i dettagli


clear all;
close all;
clc;

% Scegliere l'immagine su cui si vuole
% lavorare
immagine = 1;

switch immagine
    case 1
        I = imread('peppers.png');
        J = imread('peppers_Noise1.png');
    case 2
        I = imread('peppers.png');
        J = imread('peppers_Noise2.png');
    case 3
        I = imread('peppers.png');
        J = imread('peppers_Noise3.png');
    case 4
        I = imread('saturn2.png');
        J = imread('saturn2_Noise1.png');
    case 5
        I = imread('saturn2.png');
        J = imread('saturn2_Noise2.png');
        
end

% Visualizzazione immagini
figure, imshow(I); set(gcf,'name','Originale');
figure, imshow(J); set(gcf,'name','Con Rumore');

% ...





%% Esercizio 2. Sharpening
%
% - Applicare il filtraggio di sharpening all'immagine Pavone
%   corrotta con rumore Gaussiano
% - Provare ad applicarlo direttamente all'immagine con rumore
%   oppure dopo aver applicato un filtraggio media o gaussiano.
%   Che differenza si nota?

clear all; close all; clc

I = imread('peacock.jpg');
J = imread('peacock_Noise.png');
figure, imshow(I); set(gcf,'name','Originale');
figure, imshow(J); set(gcf,'name','Rumore Gaussiano');


% ...





