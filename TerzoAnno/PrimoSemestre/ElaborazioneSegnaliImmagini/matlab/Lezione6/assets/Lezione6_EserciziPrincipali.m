% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego
% Lezione 6: esercizi principali


%% Esempi - Operazioni puntuali

clear all
close all
clc

% Alcuni comandi utili disponibili nell'Image Processing Toolbox
% imshow(I) -> mostra l'immagine I, assumendo che I contenga gia' valori
% quantizzati.
% imhist(I) -> mostra l'istogramma dei valori di grigio dell'immagine I
% uint8(I) -> trasforma valori a doppia precisione in interi a 8 bit (0-255)
% double(I) -> passa da interi a valori in doppia precisione


%% Operazione puntuale: Negativo
% Caricare l'immagine "FLAIR.png" e una volta convertita in scala di grigi
% da RGB farne il negativo. Visualizzare in un'unica figura con piu' subplot le due immagini e
% i corrispondenti istogrammi.

clear all;
close all;
clc;

MRI = imread('FLAIR.png');
MRI = rgb2gray(MRI);
MRI_neg = 255-MRI;

figure;
subplot(221);imshow(MRI); colorbar, title ('Immagine Originale')
subplot(222);imshow(MRI_neg);colorbar, title ('Immagine Negativo')
subplot(223);imhist(MRI); title ('Hist Immagine Originale')
subplot(224);imhist(MRI_neg); title ('Hist Immagine Negativo')


%% Operazione puntuale: Clamping
% Caricare l'immagine di saturno ("saturn2.png")
% Fare l'operazione di clamping e visualizzare la LUT relativa a questa operazione.
% Infine, visualizzare le due immagini (originale/modificata) e i corrispondenti istogrammi
clear all;
close all;
clc;
I = imread('saturn2.png');

% Creo una LUT per operazione di clamping e la visualizzo
a = 110;
b = 190;
LUT=[];
for i = 0:255
    r = i;
    if r<a
        LUT(i+1) = a; % --> MATLAB inizia l'indicizzazione a 1, mentre le intensita' iniziano da 0
    elseif r<=b & r>=a
        LUT(i+1) = r;
    elseif r>b
        LUT(i+1) = b;
    end
end

figure;
plot([0:255],LUT);
xlim([0 255]);
ylim([0 255]);
grid on, title ('Clamping LUT')
xlabel('Valori originali')
ylabel('Valori per Clamping LUT')

% Applico la LUT e visualizzo l'immagine dopo operazione di clamping
[r,c] = size(I);
Inew = zeros(size(I));
for i = 1:r
    for j = 1:c
        ldg = I(i,j);
        newldg = LUT(ldg+1);% --> MATLAB inizia l'indicizzazione a 1, mentre le intensita' iniziano da 0
        Inew(i,j) = newldg;
    end
end
Inew = uint8(Inew);
% I due cicli for si possono scrivere in forma compatta:
Inew2 = uint8(LUT(I+1)); % --> MATLAB inizia l'indicizzazione a 1, mentre le intensita' iniziano da 0
% % To check
% sum(abs(Inew2-Inew),'all')
% % ans =
% %      0

figure;
subplot(221);imshow(I); colorbar, title ('Immagine Originale')
subplot(223);imhist(I); title ('Istogramma')
hold on; plot([a a],[0 max(imhist(I))]);
plot([b b],[0 max(imhist(I))])
subplot(222);imshow(Inew); colorbar, title ('Immagine Clamping')
subplot(224);imhist(Inew); title ('Istogramma')


%% Operazione puntuale: Trasformazione Non lineare (Log/Potenza) ---
% La trasformazione lineare espande in modo uniforme la dinamica originale dell’immagine,
% producendo un effetto globale di miglioramento del contrasto.
% In alcuni casi pero' si ha l’esigenza di effettuare una trasformazione non uniforme,
% che agisca differentemente sui livelli di grigio. In particolare:
% Immagine sottoesposta = i particolari interessanti sono poco evidenti e concentrati nelle zone scure;
% in tal caso possiamo espandere la dinamica associata ai livelli scuri e comprimere quella dei livelli chiari;
% Immagine sovraesposta = i particolari interessanti sono poco evidenti e concentrati nelle zone chiare;
% in tal caso possiamo espandere la dinamica associata ai livelli chiari e comprimere quella dei livelli scuri.
% L’espansione non uniforme della dinamica dell’immagine si puo' ottenere mediante
% elevazione a potenza dei livelli originari.
clear all;
close all;
clc;

% carico immagine "Spine.png" e applico trasformazione a potenza per migliore il contrasto
img = imread('Spine.png');
img = (rgb2gray(img));
figure, imshow(img),colorbar
figure,  imhist(img),colorbar

% casting a double in modo che le operazioni funzionino
img = double(img);

% I dettagli che mi interessano sono nei livelli di grigio scuri --
% --> gamma <1
gamma = 0.4;
s_tilde = img.^gamma;
s_tilde_min = min(s_tilde(:));
s_tilde_max = max(s_tilde(:));
MAX = 255;
MIN = 0;
s = ((s_tilde - s_tilde_min)./(s_tilde_max-s_tilde_min))*(MAX-MIN) + MIN;

% casting a uint8 per avere di nuovo immagini
newimg = uint8(s);

figure, imshow(newimg),colorbar
figure, imhist(newimg),colorbar


%
% carico immagine "satellite.jpg" e applico trasformazione di potenza per migliore il contrasto
img = imread('satellite.jpg');
img = (rgb2gray(img));
figure, imshow(img),colorbar
figure, imhist(img),colorbar


% casting a double in modo che le operazioni funzionino
img = double(img);

% I dettagli che mi interessano sono nei livelli di grigio chiari --
% --> gamma >1
gamma = 4;
s_tilde = img.^gamma;
s_tilde_min = min(s_tilde(:));
s_tilde_max = max(s_tilde(:));
MAX = 255;
MIN = 0;
s = ((s_tilde - s_tilde_min)./(s_tilde_max-s_tilde_min))*(MAX-MIN) + MIN;


% casting a uint8 per avere di nuovo immagini
newimg = uint8(s);

figure,  imshow(newimg),colorbar
figure, imhist(newimg),colorbar


%% Operazione puntuale: Binarizzazione ---
% Produce una immagine che ha solo due livelli: nero e bianco.
% Si ottiene scegliendo una soglia T e mettendo a nero tutti i pixel
% il cui valore è minore a T e a bianco tutti gli altri.
% La difficoltà risiede nel saper scegliere la soglia T più ragionevole
% Ci sono metodi per scegliere automaticamente la soglia (Metodo di Otsu)
clear all;
close all;
clc;


I = imread('coins.png');
figure
set(gcf,'name','Binarizzazione di immagini')
subplot(121); imshow(I); title('Immagine originale');


T = 80; % soglia
BW = zeros(size(I)); % immagine binaria
BW(I>T) = 1;
subplot(122); imshow(BW);title('Immagine binarizzata');

% Nota: si può ottenere lo stesso risultato utilizzando
% il comando imbinarize.
% La soglia deve essere tra 0 e 1
% Si veda doc imbinarize

% BW2 = imbinarize(I,T/255);
% % check che siano uguali
% sum(abs(BW-BW2),'all')
% % ans =
%   %  0





%% Esercizio 1. 
% Implementare l'operazione puntuale di stretching/shrinking e applicarla
% all'immagine "fog.png"
% - caricare l'immagine "fog.png" (auto nella nebbia)
% - visualizzare l'immagine e il corrispondente istogramma  
% - individuare i limiti rmin rmax per l'operazione di stretching/shrinking
% - costruire la LUT (Look Up Table) corrispondente
% - applicare la LUT all'immagine originale e visualizzare il risultato
%   ottenuto: come cambia? Si riesce a visualizzare meglio i numeri della
%   targa?
% - visualizzare l'istorgramma dell'immagine risultato: come cambia
%   rispetto all'istogramma dell'immagine originale?
% 
% Suggerimento: fare attenzione che in matlab gli array partono da 1, mentre 
% i livelli di grigio vanno da 0 a 255 (La LUT è un array con elementi 
% in posizione da 1 a 256 ma con valori da 0 a 255).


clear all;
close all;
clc;

% Auto nella nebbia:  come fare a visualizzare meglio i numeri della targa? Data l'operazione
% puntuale costruita, visualizzarne la Look Up Table (LUT)
img = imread('fog.png');
figure; set(gcf,'name','Immagine originale auto nella nebbia')
imshow(img); colorbar, title('Immagine originale')

% ...






%% Esercizio 2
% - Caricare l'immagine 'noisy.png'
% - Visualizzare l'immagine e il relativo istogramma
% - Cercare di migliorare l'immagine riducendo il rumore con un'operazione
% puntuale: qual'è l'operazione più adatta?

clear all
close all
clc

I = imread('noisy.png');
figure, imshow(I), title('Immagine originale')


% ...


