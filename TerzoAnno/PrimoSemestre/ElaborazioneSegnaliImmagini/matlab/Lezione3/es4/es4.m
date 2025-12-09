%  Cross-correlazione tra segnali di risonanza magnetica funzionale. 
%    Caricare il flie "Ab_pASL_Yeo_Average.txt":
%     contiene segnali medi di fMRI (functional MRI) di
%     un soggetto, misurati per 200 istanti in 100
%     diverse regioni del cervello 
%  Utilizzare questa informazione per estrarre delle
%   matrici di connettività, che spiegano come le aree
%   cerebrali comunicano tra di loro. In particolare: 
%    sottrarre da ogni segnale la sua media 
%    calcolare per ogni coppia di segnali (i,j) la crosscorrelazione normalizzata. 
%    salvare il massimo di tale cross-correlazione nella
%     posizione (i,j) della matrice "matrice_xcorr_max"  
%    questa matrice rappresenta una possibile stima di una matrice di connettività 
%  Visualizzare la matrice e rispondere alla seguente domanda: quali sono le due regioni più simili?  

%%
signal = readmatrix("../assets/Ab_pASL_Yeo_Average.txt");
signal_size = size(signal);

% Subtract mean from signal
signal = signal - mean(signal);

xcorr_max_mat = zeros(signal_size);

%% TODO
for x = 1:signal_size(2) - 1
  [corr, ~] = xcorr(signal(:,x), signal(:,x+1), 'normalized');
  xcorr_max_mat(y,x) = max(corr);
end
%%
