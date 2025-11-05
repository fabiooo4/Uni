%%
% Implement by hand 1D cross-correlation, starting
% from the following script
clear all
close all
clc

% Calculate the cross-correlation of the
% two signals x1 and x2 (same as the ones in example 1)

x1 = [1 1 1 1 1 1 1 1]; % Box 
x2 = [1 2 3 4 5 6 7 8]; % Triangle

x1_len = length(x1);
x2_len = length(x2);

% Visualization
figure; set(gcf,'name','Segnali originali','IntegerHandle','off');
subplot(311); stem(x1); title('x1')
subplot(312); stem(x2); title('x2')


% COMPLETE WITH THE MISSING STEPS:
% Option 2: vector initialization, cross-correlation calculation, shifting

% Add zeroes to both vectors
x1_padding = x2_len - 1 + x1_len - 1;
x2_padding = x1_len - 1;

x1_padded = zeros(x1_len + x1_padding, 1);
x2_padded = zeros(x2_len + 2*(x2_padding), 1);

% Fill padded vectors with original values
x1_padded(1:x1_len) = x1;
x2_padded(x2_padding + 1:x2_len + x2_padding) = x2;

% Circular shift vector and calculate correlation
correlation = zeros(x1_len + x2_len - 1, 2);
for lag = 0:x1_len + x2_len - 1
  x1_shifted = circshift(x1_padded, lag);
  corr = sum(times(x1_shifted, x2_padded));
  if corr > 0
    correlation(lag+1,1) = corr;
  end
    correlation(lag+1,2) = lag - x1_len + 1;
end

x1x2 = correlation(:,1);
lag = correlation(:,2);

subplot(313); 
plot(lag,x1x2,'Linewidth',2); 
hold on; 
stem(lag,x1x2,'Markersize',5,'MarkerFaceColor','r','Linewidth',1.1);
title('Cross-correlation');
xlabel('Lags');
ylabel('Corr Values');

% Check the resulting vector with the one obtained in example 1
%%
