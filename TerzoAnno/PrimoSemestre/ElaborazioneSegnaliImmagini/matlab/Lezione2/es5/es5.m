%  Caricare l’immagine “cells.png”, che contiene una
%   visualizzazione di cellule U2OS
%   (Human Bone Osteosarcoma)
%  Provare ad evidenziare i nuclei.
%    Suggerimento: i nuclei sono caratterizzati da valori
%     sopra una certa soglia (provare con diverse soglie)
%  Costruire inoltre una figura con due subplot dove
%   l'immagine originale viene afafincata all'immagine in cui
%   sono evidenziati i nuclei.
%    Nota: non usare la funzione imbinarize

%%
cells_img = imread("../assets/cells.png");
[img_height, img_width] = size(cells_img);

cells_highlighted = cells;

threshold = 30;
for y = 1:img_height
  for x = 1:img_width
    if (cells_img(y,x) > threshold)
      cells_highlighted(y,x) = 255;
    end
  end
end

figure;
subplot(1,2,1);
imshow(cells_img);
title("Immagine originale")

subplot(1,2,2);
imshow(cells_highlighted);
title("Immagine con cellule evidenziate")
%%
