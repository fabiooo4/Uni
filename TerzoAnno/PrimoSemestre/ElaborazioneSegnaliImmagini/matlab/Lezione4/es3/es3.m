%  Caricare l'immagine "puzzle.jpg" 
%  Ritagliare un pezzo dell'immagine (suggerimento: funzione imcrop) 
%  Utilizzare la cross-correlazione per ritrovare la posizione corretta del pezzo tagliato  
%  Visualizzare l’immagine originale, il pezzo ritagliato, la 
%   matrice di cross-correlazione e la figura “risultato” 
%    Figura risultato: immagine originale a toni di grigio
%     "attenuata" con sovrapposto il pezzo estratto (a
%     colori) nella posizione corretta 
%  Suggerimenti:  
%    Per la cross-correlazione: 
%      convertire l'immagine e il pezzo ritagliato in scala di grigi,
%       la cross-correlazione funziona su matrici -- funzione rgb2gray 
%      usare la cross-correlazione normalizzata – funzione
%       normxcorr2 dell’Image processing toolbox (attenzione
%       all'ordine dell'input) 
%    Per la visualizzazione:  
%      creare un'immagine con 3 canali (uguali all'immagine 
%       originale in scala di grigio) 
%      per attenuare moltiplicare tutti i valori dell'immagine per 0.6 
