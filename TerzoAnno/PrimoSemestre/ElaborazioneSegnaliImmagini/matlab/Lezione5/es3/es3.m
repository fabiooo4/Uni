%  Caricare il segnale in Voice.mat (f è il segnale, fs la frequenza di campionamento)
%  Efefttuare un’analisi di Fourier (calcolare e visualizzare lo  spettro di ampiezza)
%  Operare un sottocampionamento
%    Suggerimento: per fare sottocampionamento con
%     fattore D si può prendere solo un sottoinsieme di punti, uno ogni D
%    Exe: f segnale originale, f(1:2:end) segnale in cui prendo
%     un punto ogni due (cioè con un fattore di sottocampioamento D=2)
%    La frequenza di campionamento corrispondente è fs/D
%
%  Effettuare nuovamente l'analisi di Fourier,
%   visualizzando lo spettro di ampiezza risultante
%  A che livello di sottocampionamento si avverte un  aliasing sonoro?
%    Utilizzare la funzione sound per ascoltare il segnale
%     originale e il segnale sottocampionato
%    Confrontare gli spettri di ampiezza del segnale
%     originale e del segnale sottocampionato

%%
[signal,fs]=audioread('../assets/Voice.wav');
% Se non funziona usare load('Voice.mat')

sound(signal,fs)
pause(2);

% Sub-sample
fs_sub = 30;

mu_s = fs/fs_sub;
dt = 1/mu_s;    % Delta T: 1 sample every delta_T
signal_sub = signal(1:fs_sub:length(signal));
sound(signal_sub,mu_s)


% Calculate DFT
dft = fft(signal_sub);
signal_new = ifft(dft);

pause(2);
sound(signal_new, mu_s);
%%
