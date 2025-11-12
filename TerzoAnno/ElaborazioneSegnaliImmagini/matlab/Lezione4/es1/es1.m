%  Usare la cross-correlazione 2D per trovare la posizione del template nell'immagine 
%    In particolare si richiede di calcolare di quanto (righe-colonne) il template
%     è stato traslato  rispetto all’angolo in alto a sinistra dell’immagine 
%  Suggerimento:
%    calcolare la cross-correlazione (xcorr2) tra l'immagine e il template (kernel)
%    estrarre le coordinate del massimo
%    recuperare la posizione del kernel 
%  Controllare l'help della funzione xcorr2 

%%
template = 0.2*ones(55);
template(29:31,15:45) = 0.6;
template(15:45,29:31) = 0.6;

img = 0.2*ones(111);
offset = [10 40];
img(offset(1):offset(1)+size(template,1)-1,offset(2):offset(2)+size(template,2)-1) = template;

figure;
subplot(1,3,1);
imshow(template,[]);
title('Template');

subplot(1,3,2);
imshow(img,[]);
title('Immagine');

subplot(1,3,3);
corr = xcorr2(template, img);
imagesc(corr);

max_corr = max(corr, [], "all");
[max_corr_y, max_corr_x] = find(corr == max_corr);

template_size = size(template);
offset = [max_corr_y - template_size(1) + 1, max_corr_x - template_size(2) + 1];
disp("Posizione del template nell'immagine:")
disp(offset);
%%
