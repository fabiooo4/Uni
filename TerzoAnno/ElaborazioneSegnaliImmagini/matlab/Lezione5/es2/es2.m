%  Verifciare il fenomeno dell'aliasing. In particolare:
%    partire dal segnale sinusoidale
%     sin(2*pi*fsig*t), dove fsig = 10 è la frequenza del segnale
%    campionare un secondo di segnale ad una
%     determinata frequenza ed effettuare l'analisi di
%     Fourier (provare con le seguenti frequenze: [200, 100, 40, 30, 20, 15, 10])
%    Per quali di queste avviene il fenomeno dell'aliasing
%     (cioè non riesco a ricostruire lo spettro)? E' corretto rispetto alla teoria?

%%
frequencies = [200, 100, 40, 30, 20, 15, 10];

for mu_s = frequencies
  dt = 1/mu_s;    % Delta T: 1 sample every delta_T
  t = -0.5:dt:0.5-dt; % 1 sec
  fsig = 10;
  signal = sin(2*pi*fsig*t);
  
  figure('NumberTitle', 'off', 'Name', string(mu_s));
  subplot(2,2,1);
  plot(t,signal,'-b.','MarkerSize',9);
  xlabel ('tempo (sec.)');
  ylabel ('box(t)');
  title('Segnale campionato');

  % Calculate DFT
  dft = fft(signal);

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
end
%%
