%  Analizzare tramite la Trasformata di Fourier Discreta un segnale BOX
%    Creare un'onda rettangolare di 1 secondo con una
%     frequenza di campionamento di 500 Hz e una
%     lunghezza di 0.2 s (funzione rectpuls – si veda l’help)
%    Calcolare la DFT e visualizzarne lo spettro di ampiezza e di fase (con riordinamento)
%    Controllare che il risultato ottenuto per lo spettro
%     di ampiezza corrisponda a quanto spiegato in  teoria

%%
mu_s = 500;     % Sample frequency
dt = 1/mu_s;    % Delta T: 1 sample every delta_T
t = -0.5:dt:0.5-dt; % 1 sec
box = rectpuls(t,0.2);
figure;
subplot(2,2,1);
plot(t,box,'-b.','MarkerSize',9);
xlabel ('tempo (sec.)');
ylabel ('box(t)');
title('Segnale campionato');

% Calculate DFT
dft = fft(box);

N = length(t);
mu_sampling = mu_s/N;
mu = 0:mu_sampling:mu_s-mu_sampling; % Samples

subplot(2,2,2)
stem(mu,abs(dft));
xlabel ('frequenza (Hz)')
ylabel ('|dft|')
grid
title('DFT (abs) senza riordinamento');

% Center the DFT
dft_shift = fftshift(dft); % Centered DFT
mu_max = mu_s/2;  % Nyquist frequency
mu = -mu_max:mu_sampling:mu_max-mu_sampling;

subplot(223)
stem(mu,abs(dft_shift))
xlabel ('frequenza (Hz)')
ylabel ('|dfs_shift|')
grid
title('DFT (abs) con riordinamento');

% Clean
th = 1e-6;
dft_shift(abs(dft_shift) < th) = 0; 

subplot(224)
stem(mu,angle(dft_shift)/pi) % Posso moltiplicare per 180 per avere gradi 
xlabel ('frequenza (Hz)')
ylabel ('fase/\pi')
grid
title('DFT (fase) con riordinamento');
%%
