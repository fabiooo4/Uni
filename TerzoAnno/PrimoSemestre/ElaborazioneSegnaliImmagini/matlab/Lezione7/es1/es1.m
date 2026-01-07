% ● Applicare un flitraggio di smoothing alle
%   immagini reali defniite nello script
%   Lezione7_EserciziPrincipali.m
% ● Variare il tipo di flitro (media, Gaussiano,
%   mediano) e variare la dimensione della
%   maschera – Per il flitro Gaussiano: fare attenzione a stimare
%   correttamente la deviazione standard del flitro
%   con la regola K = 5*sigma
% ● Confrontare i risultati in modo qualitativo e
%   rispondere, per ogni
%   immagine, alle seguenti
%   domande:
%     – In generale, funziona meglio un flitro
%     Media, un flitro Gaussiano o un flitro
%     Mediana?
%     – Considerando il flitro ottimale: cosa
%     succede quando cambio la dimensione della
%     maschera? Qual è la dimensione ottimale?
% ● Nota: l'obiettivo è cercare di eliminare la
%   maggior quantità possibile di rumore
%   cercando però di mantenere al massimo i
%   dettagli

%%
kernels = [
  [3, 3];
  [5, 5];
  [10, 10];
  ];

for img = 1:5
  switch img
    case 1
      original_img = imread('../assets/peppers.png');
      noise_img = imread('../assets/peppers_Noise1.png');
    case 2
      original_img = imread('../assets/peppers.png');
      noise_img = imread('../assets/peppers_Noise2.png');
    case 3
      original_img = imread('../assets/peppers.png');
      noise_img = imread('../assets/peppers_Noise3.png');
    case 4
      original_img = imread('../assets/saturn2.png');
      noise_img = imread('../assets/saturn2_Noise1.png');
    case 5
      original_img = imread('../assets/saturn2.png');
      noise_img = imread('../assets/saturn2_Noise2.png');
  end

  figure;

  subplot(1 + length(kernels),3,1)
  imshow(original_img);
  colormap gray;
  axis image;
  colorbar;
  title("Originale")

  subplot(1 + length(kernels),3,2)
  imshow(noise_img);
  colormap gray;
  axis image;
  colorbar;
  title("Con rumore")

  for filter = 1:3
    for k = 1:size(kernels,1)
      kernel_size = kernels(k, :);
      switch filter
        case 1
          filter_name = "Media";
          kernel = fspecial('average', kernel_size);
          filtered_img = imfilter(noise_img, kernel, 'replicate');
        case 2
          filter_name = "Gaussiana";
          sigma = mean(kernel_size)/5;
          kernel = fspecial('gaussian', kernel_size, sigma);
          filtered_img = imfilter(noise_img, kernel, 'replicate');
        case 3
          filter_name = "Mediana";
          filtered_img = medfilt2(noise_img, kernel_size);
      end

      % Img view
      subplot(1 + length(kernels),3,4 + (filter - 1) + 3 * (k - 1))
      imshow(filtered_img);
      colormap gray;
      axis image;
      colorbar;
      title(filter_name + " Kernel = [" + kernel_size(1) + " " + kernel_size(1) + "]")
    end
  end
end

%%
