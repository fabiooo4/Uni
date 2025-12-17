% ● Implementare l'operazione puntuale di
% stretching/shrinking e applicarla all'immagine "fog.png"
%   – caricare l’immagine "fog.png" (auto nella nebbia)
%   – visualizzare l'immagine e il corrispondente
%     istogramma
%   – individuare i limiti rmin,rmax per l'operazione di
%     stretching/shrinking
%   – costruire la LUT (Look Up Table) per l’operazione
%     di stretching/shrinking
%   – applicare la LUT all'immagine originale e
%     visualizzare il risultato ottenuto: come cambia? Si
%     riescono a visualizzare meglio i numeri della targa?
%   – visualizzare l'istogramma dell'immagine risultato:
%     come cambia rispetto all'istogramma
%     dell'immagine originale?
% Nota: non utilizzare il comando matlab “imadjust”
%
% Suggerimenti:
% ● Fare attenzione che in matlab gli array partono da 1,
%   mentre i livelli di grigio vanno da 0 a 255 (La LUT è un
%   array con elementi in posizione da 1 a 256 ma con
%   valori da 0 a 255).
% ● Attenzione al tipo:
%   – Le immagini sono uint8, occorre trasformarle in
%   double prima di fare operazioni matematiche,
%   altrimenti le operazioni sono fra interi

%%
img = imread("../assets/fog.png");

figure;
subplot(221);
imshow(img);
colorbar;
title('Immagine Originale');

subplot(222);
imhist(img);
title('Hist Immagine Originale');

% Create Look Up Table
min_gray = min(img, [], "all");
max_gray = max(img, [], "all");

range_min = 0;
range_max = 255;
lut = zeros(255, 1);
for gray = 0:255
  if gray >= min_gray && gray <= max_gray
    lut(gray + 1) = (gray - min_gray)/(max_gray - min_gray) * (range_max - range_min) + range_min;
  else
    lut(gray + 1) = gray;
  end
end

% Apply Look Up Table
new_img = uint8(lut(img+1));

subplot(223);
imshow(new_img);
colorbar;
title('Immagine Stretching/Shrinking');

subplot(224);
imhist(new_img);
title('Hist Immagine Stretching/Shrinking');

figure;
plot(0:255, lut);
xlim([0 255]);
ylim([0 255]);
grid on, title('Stretching/Shrinking LUT')
xlabel('Valori originali')
ylabel('Valori per Stretching/Shrinking LUT')
%%
