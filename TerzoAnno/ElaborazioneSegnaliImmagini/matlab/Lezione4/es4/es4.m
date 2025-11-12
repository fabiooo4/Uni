%  Utilizzo avanzato della cross-correlazione 2D
%   normalizzata: trovare difetti su tessuti  
%    Caricare l'immagine “tex.jpg” 
%    Estrarre alcuni pattern in zone che non contengono difetti 
%    Calcolare la cross-correlazione dei pattern con l'immagine originale 
%    Mediare le matrici di cross-correlazione ottenute con
%     i diversi pattern (per una maggiore robustezza)  
%      le zone a bassa cross-correlazione indicano i difetti 
%  Suggerimento: usare nuovamente la cross correlazione normalizzata
%   (normxcross2) sulle immagini convertite in toni di grigio 
%  Partire dalla traccia presente in Lezione4_EserciziExtra.m  
%  Extra: provare la pipeline su altre immagini di difetti
%   prese da internet, modifciandola se necessario 
%    Cambiare la dimensione, il numero e la posizione dei patterns 
%    Cambiare la soglia per il rilevamento 
