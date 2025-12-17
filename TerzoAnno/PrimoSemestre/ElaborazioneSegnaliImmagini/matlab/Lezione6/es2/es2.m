% ● Caricare l'immagine 'noisy.png' 
% ● Visualizzare l'immagine e il relativo istogramma 
% ● Cercare di migliorare l'immagine riducendo il
%   rumore con un'operazione puntuale: qual'è
%   l'operazione più adatta? 

%%
img = imread("../assets/noisy.png");

figure;
subplot(221);
imshow(img);
colorbar;
title('Immagine Originale');

subplot(222);
imhist(img);
title('Hist Immagine Originale');

% Create Look Up Table

lut = zeros(255, 1);
threshold = 90;
for gray = 0:255
  if gray > threshold
    lut(gray + 1) = threshold;
  else
    lut(gray + 1) = gray;
  end
end

new_img = uint8(lut(img + 1));

subplot(223);
imshow(new_img);
colorbar;
title('Immagine Clamping');

subplot(224);
imhist(new_img);
title('Hist Immagine Clamping');

figure;
plot(0:255, lut);
xlim([0 255]);
ylim([0 255]);
grid on, title('Clamping LUT')
xlabel('Valori originali')
ylabel('Valori per Clamping LUT')
%%
