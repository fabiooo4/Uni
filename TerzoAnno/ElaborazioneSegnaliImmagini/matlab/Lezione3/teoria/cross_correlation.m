%% Calculates 1D cross correlation
vec1 = rand(100, 1);
vec2 = rand(100, 1);
[correlation, lag] = xcorr(vec1, vec2);
disp('Cross-correlation:');
disp(correlation);
disp('Lags:');
disp(lag);
%%
