% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego 
% Lezione 5: Esercizi extra 



%% Esercizio 3 -  ALIASING SU SEGNALE REALE
% - Caricare il segnale in 'Voice.m4a' (se non funziona caricare il file 
%   Voice.mat (f è il segnale, fs la frequenza di campionamento)
% - Analizzarlo con Fourier (calcolare e visualizzare lo spettro di
%   ampiezza)
% - Operare un sottocampionamento con un fattore "downsampling"
%   Suggerimento: per fare sottocampionamento si può prendere solo
%   un sottoinsieme di punti, uno ogni "downsampling". 
%   Exe: f segnale originale, f(1:2:end) segnale in cui prendo un punto
%        ogni due (cioè con un fattore di sottocampioamento downsampling=2)
%        La frequenza di campionamento corrispondente è fs/downsampling
% - Effettuare nuovamente l'analisi di Fourier, visualizzando lo spettro di
%   ampiezza risultante
% - A che livello di sottocampionamento si avverte un aliasing sonoro?
%   (utilizzare la funzione sound per ascoltare il segnale originale e il
%   segnale sottocampionato)


clear all
close all
clc

[f,fs]=audioread('Voice.wav'); 
% Se non funziona usare load('Voice.mat')


% Ascoltare il suono (se non funziona provare con gli auricolari)
sound(f,fs)

% ...






%% Esercizio 4 - Aliasing di segnale in banda limitata
% - Caricare il segnale nel file 'SegnaleBL.mat': 
%      f1: segnale della durata di 1 secondo; 
%      mu_s1: frequenza di campionamento;
% - Effettuare l'analisi di Fourier 
% - Visualizzare il segnale e lo spettro di ampiezza 
%   verificare che si tratti effettivamente di un segnale in banda limitata 
%   (spettro di ampiezza a forma di triangolo)
% - Sottocampionare il segnale, effettuare l'analisi di Fourier 
%   e verificare l'effetto di aliasing nello spettro di ampiezza
%   (visualizzare sia il segnale sottocampionato che lo spettro di
%   ampiezza)
%
% Domanda: fino a che fattore di sottocampionamento si può evitare aliasing?  


clear all 
close all
clc

% Caricamento di un segnale in banda limitata  
load('SegnaleBL.mat')

% ...






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ALTRI ESEMPI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Esempio 3  -  COSENO CON SFASAMENTO E OPERAZIONE DI PADDING 
% Obiettivo di questo esercizio è quello di testare un segnale coseno con sfasamento. In particolare,
% utilizzare una frequenza di 5 Hz, campionare il segnale a 150 Hz e osservare lo spettro di 
% ampiezza/spettro di fase. Eseguire poi un'operazione di padding. 


clear all
close all
clc
% Definisco le principali variabili
mu_s = 150; 
mu = 5;
Dt = 1/mu_s;
t = 0:Dt:1-Dt;
phs = 1/3*pi; 

signal = cos(2*pi*mu*t + phs);

figure
subplot(131)
plot(t,signal);
xlabel ('tempo (sec.)')
ylabel ('f(t)')
title('Segnale campionato');

X = fft(signal);
N = length(X);
mu_m = mu_s/2;
freq = -mu_m:mu_s/N:mu_m-mu_s/N;
FF = fftshift(X);


subplot(132)
plot(freq,(abs(FF)));
xlabel ('frequenza (Hz)')
ylabel ('|Fs|')
grid
title('DFT (abs) con riordinamento');

% Eseguo operazione di zero padding al segnale nel tempo. 
% Questa e' applicata automaticamente in Matlab con il comando X = fft(x,N) 
% quando la dimensione N e' maggiore della lunghezza del segnale x 
Npad = 1024;
X_padded = fft(signal,Npad);
FF_padded = fftshift(X_padded);
freq_padded = -mu_m:mu_s/Npad:mu_m-mu_s/Npad; 

subplot(133)
plot(freq_padded,(abs(FF_padded)));
xlabel ('frequenza (Hz)')
ylabel ('|Fs|')
grid
title('DFT (abs) con riordinamento - Padding ');





%% Esempio 4 - ANALISI FFT SU SEGNALE REALE 
% Analizzare lo spettro del suono contenuto nel file Unknown_Sound attraverso la DFT. 
% Che tipo di suono abbiamo?
% Visualizzare sia lo spettro di ampiezza che di fase
close all
clear all
clc

load Unknown_Sound % contiene [f,fs] dove f = suono, fs = freq. di campionamento

% Questa situazione (ho un segnale che non conosco in partenza e lo devo
% analizzare) è particolarmente importante in un recentissimo ambito,
% quello della manutenzione predittiva. In pratica, l'idea è di ascoltare
% un sistema (p.e. un motore di aereo) a capire dal suono quando si stanno
% per verificare problemi, facendo partire la manutenzione prima che
% avvenga il guasto. La manutenzione predittiva è uno dei cardini dell'industria 4.0. 
% Vedasi https://www.processingmagazine.com/predictive-maintenance-airborne-sound-analysis/ 

% a) Valutare l'andamento generale del segnale e la sua durata

figure; set(gcf,'name','Analisi preliminare segnale');
subplot(211)
plot(f); % utilizzo lo strumento di zoom per analizzare una porzione di segnale;
xlim([0 length(f)])
xlabel ('#campioni')
ylabel ('ampiezza')
title('Segnale audio completo');

subplot(212)
plot(f(1:200)); 
xlabel ('#campioni')
ylabel ('ampiezza')
title('Segnale audio - 200 campioni');

N = length(f); 
durata = N/fs; % N = fs * T; 
sprintf('Durata del segnale audio = %f', durata)

% b) Eseguire l'analisi di Fourier e visualizzare gli spettri 

t = 0:1/fs:1-1/fs; % Prendo un secondo (segnale con andamento regolare nel tempo, ho piu' di 44100 campioni) 
f = (f(1:fs,1)); % In un secondo ho fs campioni
% trasformata di fourier
F = fft(f);

% calcolo vettore frequenze
mu_sampling = fs/length(f); 
mu_max = fs/2;
mu = 0:mu_sampling:fs-mu_sampling; 
mu_shift = -mu_max:mu_sampling:mu_max-mu_sampling;

figure; set(gcf,'name','Analisi spettrale segnale 1D');

subplot(231); 
plot(t,f);
xlabel ('tempo (sec.)')
ylabel ('f(t)')
title ('Segnale - 1 sec')

subplot(232); 
plot(t(1:2000),f(1:2000));
xlabel ('tempo (sec.)')
ylabel ('f(t)')
title ('Segnale ~ 0.05 sec')

subplot(233); 
stem(mu, abs(F));
xlabel ('frequenza (Hz)')
ylabel ('|F|')
title('La DFT come vista a lezione');

% shifto e visualizzo
FF = fftshift(F);
subplot(234); 
stem(mu_shift, abs(FF))
xlabel ('frequenza (Hz)')
ylabel ('|F|')
title('La DFT centrata');

th = max(abs(FF))/100; % decido di pulire lo spettro cancellando i residui di frequenza sotto un 100esimo del massimo valore
FF(abs(FF) < th) = 0; 
theta = angle(FF);

subplot(235);
stem(mu_shift,theta/pi)
xlabel ('frequenza (Hz)')
ylabel ('fase/\pi')
grid
title('Spettro di fase');






