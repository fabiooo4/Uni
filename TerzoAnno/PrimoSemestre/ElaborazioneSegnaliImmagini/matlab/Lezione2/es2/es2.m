%  Realizzare una funzione che, data l’immagine a livelli
%   di grigio moon.tif, conti quanti pixel (= entries i,j
%   all’interno della matrice) assumono un particolare
%   valore di grigio, per tutti i valori di grigio compresi
%   tra 0 e 255.  
%  Il risultato sarà un vettore di naturali di
%   dimensionalità (256,1) (chiamato istogramma).  
%  Provare a visualizzare questo vettore usando il comando bar. 
%    Nota: non utilizzare comando imhist o histogram 

%%
img = imread("../assets/moon.tif");
black_count = count_black_pixels(img);
disp(black_count)
bar(black_count)
%%
