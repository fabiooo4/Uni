%  Prendete la foto di Paperino oppure fatevi una foto al  volto.
%  Copiate questa foto nella directory di lavoro, e  caricatela attraverso MATLAB.
%  Attraverso opportune indicizzazioni della matrice in  cui è contenuta la foto,
%   sostituite ai pixel che  rappresentano gli occhi dei pixel neri, facendo  comparire una sorta di occhiali da sole.
%  NOTA:  Ricordo che il valore nero si ottiene con  una terna RGB = [0,0,0]. 
%  Ruotate l’immagine originale di 45 gradi verso sinistra
%  Estraete la parte dell’immagine contenente gli occhi  (comando imcrop)
%  Create una fgiura con quattro plot (comando subplot)  per visualizzare:
%    L’immagine originale
%    L’immagine modifciata
%    L’immagine ruotata
%    L’immagine con il dettaglio degli occhi 

%%
figure;
paperino = imread('../assets/Paperino.jpg');
paperino_glasses = paperino;
paperino_glasses(160:210, 100:200, :) = 0;

subplot(2,2,1);
imshow(paperino);
title("Immagine Originale")

subplot(2,2,2);
imshow(paperino_glasses);
title("Immagine Modificata")
%%

%%
paperino_rotated = paperino;
imrotate(paperino_rotated, 45);
subplot(2,2,3)
imshow(paperino_rotated);
title("Immagine ruotata")

paperino_cropped = paperino;
paperino_cropped = imcrop(paperino_cropped);
subplot(2,2,3)
imshow(paperino_cropped);
title("Immagine con dettaglio occhi")
%%
