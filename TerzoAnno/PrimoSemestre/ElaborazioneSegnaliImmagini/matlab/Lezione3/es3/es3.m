%  Provare la cross-correlazione con differenti segnali definiti a mano.
%    Analizzare l’help di xcorr per adottare anche la versione normalizzata
%  Provare a calcolare la cross-correlazione (normalizzata e
%   non) di (x1,x2) e di (x1,x3)
%     x1 = [1 1 1 1 1 1 1 1];
%     x2 = [1 2 3 4 5 6 7 8];
%     x3 = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];
%    Domanda: quando ha senso utilizzare la versione normalizzata?

%%
x1 = [1 1 1 1 1 1 1 1];
x2 = [1 2 3 4 5 6 7 8];
x3 = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];

[corr_1_2, ~] = xcorr(x1, x2);
[corr_1_3, ~] = xcorr(x1, x3);
[norm_corr_1_2, ~] = xcorr(x1, x2, 'normalized');
[norm_corr_1_3, ~] = xcorr(x1, x3, 'normalized');

disp("X1 X2 Correlation: " + corr_1_2);
disp("X1 X3 Correlation: " + corr_1_3);
disp("X1 X2 Normalized correlation: " + norm_corr_1_2);
disp("X1 X3 Normalized correlation: " + norm_corr_1_3);
%%
