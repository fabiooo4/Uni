%  Estendere l’esercizio 2 al caso di immagini a colori, in
%   particolare utilizzando l’immagine “peppers.png” 
%    Calcolare l’istogramma per ogni canale di colore. 
%    Domanda: qual’è il canale con più valori diversi?
%     Suggerimento: contare i valori dell'istogramma diversi da zero 

%%
img = imread("../assets/peppers.png");
color_count = count_colored_pixels(img);

figure;
subplot(1,3,1);
bar(color_count(:,1));
title("Red count")

subplot(1,3,2);
bar(color_count(:,2));
title("Green count")

subplot(1,3,3);
bar(color_count(:,3));
title("Blue count")

red_num = numel(find(color_count(:,1) ~= 0));
green_num = numel(find(color_count(:,2) ~= 0));
blue_num = numel(find(color_count(:,3) ~= 0));
[max_num, channel] = max([red_num, green_num, blue_num]);

if (channel == 1)
  disp("Red has the most number of different values: " + red_num);
end
if (channel == 2)
  disp("Green has the most number of different values: " + green_num);
end
if (channel == 3)
  disp("Blue has the most number of different values: " + blue_num);
end
%%
