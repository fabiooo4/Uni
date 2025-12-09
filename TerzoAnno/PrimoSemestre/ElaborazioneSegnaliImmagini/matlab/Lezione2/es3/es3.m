%  Caricare nel workspace l'immagine "seattle.png" e assegnarla  alla variabile I 
%  Costruire una nuova matrice Ih in cui ad ogni elemento di I viene
%   sottratto il suo precedente sulle colonne (in valore assoluto). 
%    In altre parole, l'elemento (i,j) della nuova matrice Ih deve
%     essere uguale a abs(I(i,j)-I(i-1,j)) (attenzione agli indici
%     di inizio e fnie del for) 
%  Ripetere l'esercizio costruendo l'immagine Iv, ottenuta
%   sottraendo ad ogni elemento quello adiacente sulle righe:
%   Iv(i,j)=abs(I(i,j)-I(i,j-1)) 
%  Cosa rappresentano Ih e Iv? 

%%
img = imread("../assets/seattle.png");
[img_height, img_width] = size(img);

img_horizontal_edges = img;
img_vertical_edges = img;

for y = 2:img_height
  for x = 2:img_width
    img_horizontal_edges(y,x) = abs(img(y,x) - img(y - 1, x));
    img_vertical_edges(y,x) = abs(img(y,x) - img(y, x - 1));
  end
end

figure;
subplot(1,4,1);
imshow(img);
title("Immagine Originale")

subplot(1,4,2);
imshow(img_horizontal_edges);
title("Bordi orizzontali dell'immagine")

subplot(1,4,3);
imshow(img_vertical_edges);
title("Bordi verticali dell'immagine")

img_edges = img_horizontal_edges + img_vertical_edges;
subplot(1,4,4);
imshow(img_edges);
title("Tutti i bordi dell'immagine")
%%
