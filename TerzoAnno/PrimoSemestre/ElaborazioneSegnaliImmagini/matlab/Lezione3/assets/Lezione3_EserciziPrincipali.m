% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego 
% Lezione 3: Esercizi principali 



%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% ESEMPI
%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%% ESEMPIO 1
% Esempio sintetico di cross-correlazione - rettangolo e triangolo
clear all
close all
clc

x1 = [1 1 1 1 1 1 1 1]; %box 
x2 = [1 2 3 4 5 6 7 8]; %triangolo
%x2 = [8 7 6 5 4 3 2 1]; %triangolo "ribaltato"

figure; 
set(gcf,'name','Cross Correlazione','IntegerHandle','off');
subplot(311); stem(x1,'Markersize',5,'MarkerFaceColor','b','Linewidth',1.1); grid on
subplot(312); stem(x2,'Markersize',5,'MarkerFaceColor','b','Linewidth',1.1); grid on
[x1x2,lag] = xcorr(x1,x2);
subplot(313); 
plot(lag,x1x2,'Linewidth',2); 
hold on; 
stem(lag,x1x2,'Markersize',5,'MarkerFaceColor','r','Linewidth',1.1);
title('Cross-correlation');
xlabel('Lags');
ylabel('Corr Values');



%% 
% ESEMPIO 2 
% Esempio di cross correlazione con segnali reali
% Cross correlazione tra segnali di vibrazione su un ponte emessi da un 
% veicolo in prossimita' di due diversi sensori. La cross correlazione mi 
% aiuta a capire quanto sono diversi tra loro.
clear all
close all
clc


load ('noisysignals.mat','s1','s2');  % caricamento segnali. I segnali sono simili a quanto ottenuto da questi sensori
% https://www.luchsinger.it/it/sensori/vibrazioni/
[acor,lag] = xcorr(s1,s2);
[~,I] = max(acor);
timeDiff = lag(I);   % Perche' timeDiff = 350?       
figure;
subplot(411); plot(s1); title('s1');
subplot(412); plot(s2); title('s2');
subplot(413); plot(lag,acor);
title('Cross-correlation tra s1 e s2')
subplot(414); plot([zeros(1,timeDiff) s2']); 
hold on; plot(s1);
title('Allineamento')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% ESERCIZI
%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%% ESERCIZIO 1
% Implementare a mano la cross correlazione 1D, partendo 
% dallo script sottostante
clear all
close all
clc

% Si vuole calcolare la cross correlazione 
% di questi due segnali (stessi segnali dell'esempio 1)

x1 = [1 1 1 1 1 1 1 1]; %box 
x2 = [1 2 3 4 5 6 7 8]; %triangolo

M = length(x1); % lunghezza primo segnale
N = length(x2); % lunghezza secondo segnale

% visualizzazione 
figure; set(gcf,'name','Segnali originali','IntegerHandle','off');
subplot(211); stem(x1); title('x1')
subplot(212); stem(x2); title('x2')


% DA COMPLETARE CON I PASSI MANCANTI:
% Opzione 1: creazione vettori con zero padding, calcolo cross correlazione
% Opzione 2: inizializzazione vettori, calcolo cross correlazione, shifting
% ....

% Confrontare il vettore risultante col vettore ottenuto nell'esempio 1



%%
%%% ESERCIZIO 2
% Cross-correlazione su segnali audio: riconoscimento del suono attraverso 
% la cross-correlazione.
% 
% - Caricare i segnali audio presenti nel file audioSignals.mat
%    - Le variabili "Y1", "Y2", "Y3"... corrispondono ai primi 20 secondi 
%      secondi dei segnali audio delle canzoni 'funky.mp3','lost.mp3',
%      'Diana.mp3','never.mp3', 'T69.mp3'. In particolare i segnali
%      corrispondono al primo canale 
%    - la variabile "test" contiene un segnale audio 'Test.wav'
% - Confrontare l'esempio di test con le varie canzoni della galleria usando
%   la cross correlazione: riusciamo a capire da quale canzone proviene? 
% - Suggerimenti: 
%   - determinare la similarità tra il segnale di test e ogni canzone tramite 
%     la crosscorrelazione 
%   - determinare la canzone più simile guardando quella con similarità più grande


clear all
close all
clc

load('audioSignals.mat');
% - Le variabili "Y1", "Y2", "Y3"... corrispondono ai primi 20 secondi 
%   secondi dei segnali audio delle canzoni 'funky.mp3','lost.mp3',
%   'Diana.mp3','never.mp3', 'T69.mp3'. In particolare i segnali
%   corrispondono al primo canale 
% - la variabile "test" contiene un segnale audio 'Test.wav'
%
% Le variabili sono ottenute con le istruzioni qui sotto (se volete usare
% altre canzoni)
%
% [fullY1,fs1] = audioread('funky.mp3',[1,96000*20]);
% [fullY2,fs2] = audioread('lost.mp3',[1,96000*20]);
% [fullY3,fs3] = audioread('Diana.mp3',[1,96000*20]);
% [fullY4,fs4] = audioread('never.mp3',[1,96000*20]);
% [fullY5,fs5] = audioread('T69.mp3',[1,96000*20]);
% 
% fulltest = audioread('Test.wav');
%
%%% Nota: un segnale audio ha due canali (stereo),
%%% per la cross correlazione consideriamo solo il primo
% Y1 = fullY1(:,1);
% Y2 = fullY2(:,1);
% Y3 = fullY3(:,1);
% Y4 = fullY4(:,1);
% Y5 = fullY5(:,1);
% test = fulltest(:,1);


% Visualizzo un pezzo dei segnali
figure; set(gcf,'name','Dataset canzoni','IntegerHandle','off');
subplot(2,3,1); plot(Y1(1:96000*3));
subplot(2,3,2); plot(Y2(1:96000*3));
subplot(2,3,3); plot(Y3(1:96000*3));
subplot(2,3,4); plot(Y4(1:96000*3));
subplot(2,3,5); plot(Y5(1:96000*3));
subplot(2,3,6); plot(test(1:96000*3));


% - Confrontare l'esempio di test con le varie canzoni della galleria usando
%   la cross correlazione: riusciamo a capire da quale canzone proviene? 


% DA COMPLETARE CON I PASSI MANCANTI:
%   - determinare la similarità tra il segnale di test e ogni canzone tramite 
%     la crosscorrelazione 
%   - determinare la canzone più simile guardando quella con similarità più grande





