% Corso di Elaborazione dei Segnali e Immagini
% Docente: Manuele Bicego 
% Lezione 5: Esercizi principali 


%% Esempio 1 - SINUSOIDE A 20 Hz 1-D CAMPIONATA A 100 Hz 
% Obiettivo di questo esempio è mostrare come si possono
% generare segnali e controllarne lo spettro. In particolare,
% si definisce una sinusoide a 20 Hz, si campiona a 100Hz e si osserva lo 
% spettro di magnitudo con picco a 20 Hz. 
% Controllare anche lo spettro di fase.


clear all
close all
clc

% FUNZIONI RICHIESTE: fft, fftshift, abs, angle

% Definisco le principali variabili di interesse e il segnale 
mu = 20;        % frequenza del segnale sinusoidale
mu_s = 100;     % frequenza di campionamento 
Dt = 1/mu_s;    % delta T: un campione ogni delta_T
t = -0.5:Dt:0.5-Dt;  % prendo un secondo di durata
N = length(t);  % numero di campioni

f = sin(2*pi*mu*t); % segnale sinusoidale

figure
subplot(221)
plot(t,f,'-b.','MarkerSize',9)
xlabel ('tempo (sec.)')
ylabel ('f(t)')
title('Segnale campionato');

% Calcolo la trasformata di Fourier e definisco il vettore delle frequenze
F = fft(f);           % Fast Fourier Transform è l'implementazione della DFT
% Se il segnale originale ha N punti ho N bin in frequenza: 
% da 0 alla frequenza di campionamento (mu_s - step) con step mu_s/N
mu_sampling = mu_s/N; % passo
mu = 0:mu_sampling:mu_s-mu_sampling; % campioni nello spazio delle frequenze

subplot(222)
stem(mu,abs(F));
xlabel ('frequenza (Hz)')
ylabel ('|F|')
grid
title('DFT (abs) senza riordinamento');

% Eseguo operazione di centratura dello spettro e visualizzo spettro centrato
Fs = fftshift(F); % centratura 
mu_max = mu_s/2;  % frequenza di Nyquist ? 
mu = -mu_max:mu_sampling:mu_max-mu_sampling; % nuovo vettore frequenze 

subplot(223)
stem(mu,abs(Fs))
xlabel ('frequenza (Hz)')
ylabel ('|Fs|')
grid
title('DFT (abs) con riordinamento');

% Eseguo pulizia per eliminare le componenti con magnitudo bassa e calcolo la fase 
th = 1e-6;
Fs(abs(Fs) < th) = 0; 

subplot(224)
stem(mu,angle(Fs)/pi) % Posso moltiplicare per 180 per avere gradi 
xlabel ('frequenza (Hz)')
ylabel ('fase/\pi')
grid
title('DFT (fase) con riordinamento');


%%%%%%%% RIASSUNTO:
% Passi:
% calcolo il vettore dei tempi e delle frequenze (N valori da -mu_s/2 a mu_s/2 -step)
% calcolo la fft e la fft riordinata
% calcolo il vettore frequenze: 
%       fft riordinata: (N valori da -mu_s/2 a mu_s/2-step)
%       fft non riordinata: (N valori da 0 a mu_s-step)
%       step = mu_s/N
% visualizzo lo spettro di ampiezza
% Se segnale rumoroso: pulisco lo spettro e tolgo le frequenze troppo basse
% visualizzo lo spettro di fase
%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%
% Altro esempio con il seguente segnale: 
% f = cos(2*pi*10*t) - sin(2*pi*40*t)
% cosa ottengo?

f = cos(2*pi*10*t) - sin(2*pi*40*t); % segnale sinusoidale

figure
subplot(221)
plot(t,f,'-b.','MarkerSize',9)
xlabel ('tempo (sec.)')
ylabel ('f(t)')
title('Segnale campionato');

% Calcolo la trasformata di Fourier e definisco il vettore delle frequenze
F = fft(f);           % Fast Fourier Transform è l'implementazione della DFT
mu_sampling = mu_s/N; % passo
mu = 0:mu_sampling:mu_s-mu_sampling; % campioni nello spazio delle frequenze

subplot(222)
stem(mu,abs(F));
xlabel ('frequenza (Hz)')
ylabel ('|F|')
grid
title('DFT (abs) senza riordinamento');

% Eseguo operazione di centratura dello spettro e visualizzo spettro centrato
Fs = fftshift(F); % centratura 
mu_max = mu_s/2;  % frequenza di Nyquist ? 
mu = -mu_max:mu_sampling:mu_max-mu_sampling; % nuovo vettore frequenze 

subplot(223)
stem(mu,abs(Fs))
xlabel ('frequenza (Hz)')
ylabel ('|Fs|')
grid
title('DFT (abs) con riordinamento');

% Eseguo pulizia per eliminare le componenti con magnitudo bassa e calcolo la fase 
th = 1e-6;
Fs(abs(Fs) < th) = 0; 

subplot(224)
stem(mu,angle(Fs)/pi) % Posso moltiplicare per 180 per avere gradi 
xlabel ('frequenza (Hz)')
ylabel ('fase/\pi')
grid
title('DFT (fase) con riordinamento');




%% Esercizio 1
% Analizzare tramite la Trasformata di Fourier Discreta  un segnale BOX
%   - Creare un'onda rettangolare di 1 secondo con una frequenza di 
%     campionamento di 500 Hz e una lunghezza di 0.2 s 
%     (funzione rectpuls – si veda l’help)
%   - Calcolare la DFT e visualizzarne lo spettro di ampiezza e di fase 
%     (con riordinamento)
%   - Controllare che il risultato ottenuto per lo spettro di ampiezza 
%     corrisponda a quanto spiegato in teoria
%
% (se si vuole): Provare ad effettuare la stessa analisi su un segnale audio 
% registrato direttamente in MATLAB, della durata di 4 secondi
% (si veda la seconda lezione)

% Funzione BoX

clear all
close all

% Fissare la frequenza di campionamento e la lunghezza del box
% Generare il vettore dei tempi: 
%    - 1 secondo di lunghezza, centrato nello zero
%    - il deltaT si ricava dalla frequenza di campionamento
% Utilizzare rectpuls
% 
% ...








%% Esercizio 2
% Verificare il fenomeno dell'aliasing.
% In particolare: 
% - partire dal segnale sinusoidale sin(2*pi*fsig*t), dove fsig = 10 è la
%   frequenza del segnale
% - campionare un secondo di segnale ad una determinata frequenza ed effettuare
%   l'analisi di Fourier
% - Provare con le seguenti frequenze: 
%  [200, 100, 40, 30, 20, 15, 10]
% Per quali di queste avviene il fenomeno dell'aliasing?
% E' corretto rispetto alla teoria?


clear all
close all
clc

% creo il segnale campionato con frequenza Fs
% Suggerimento:
% Fisso Fs
% Calcolo DeltaT (1/Fs)
% Creo un vettore t per i tempi (1 secondo) con passo DeltaT
% creo il segnale con fsig = 10
% y = sin(2*pi*fsig*t);

% ...


