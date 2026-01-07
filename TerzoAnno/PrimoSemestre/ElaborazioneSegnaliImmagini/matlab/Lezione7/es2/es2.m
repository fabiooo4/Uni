% ● Applicare il flitraggio di sharpening
%   all'immagine “Pavone” corrotta con rumore Gaussiano
% ● Provare ad applicarlo direttamente
%   all'immagine con rumore oppure dopo aver
%   applicato un flitraggio media o gaussiano. Che
%   difefrenza si nota?

%%
kernels = [
  [3, 3];
  [5, 5];
  [10, 10];
  ];

original_img = imread('../assets/peacock.jpg');
noise_img = imread('../assets/peacock_Noise.png');

figure;

subplot(1,2,1)
imshow(original_img);
colormap gray;
axis image;
colorbar;
title("Originale")

subplot(1,2,2)
imshow(noise_img);
colormap gray;
axis image;
colorbar;
title("Con rumore")

figure;
set(gcf,'name','Originale');

alpha = 0.2;
sharp_kernel = fspecial('laplacian', alpha);
sharpened_img = imfilter(original_img, sharp_kernel);

cost = -1;
sharpened_img = original_img + cost * sharpened_img;

subplot(1,2,1)
imshow(original_img);
colormap gray;
axis image;
colorbar;
title("Originale")

subplot(1,2,2)
imshow(sharpened_img);
colormap gray;
axis image;
colorbar;
title("Sharpened")


for filter = 1:3
  switch filter
    case 1
      filter_name = "Media";
    case 2
      filter_name = "Gaussiana";
    case 3
      filter_name = "Mediana";
  end

  figure;
  set(gcf,'name',filter_name);

  for k = 1:size(kernels,1)
    kernel_size = kernels(k, :);
    switch filter
      case 1
        kernel = fspecial('average', kernel_size);
        filtered_img = imfilter(noise_img, kernel, 'replicate');
      case 2
        sigma = mean(kernel_size)/5;
        kernel = fspecial('gaussian', kernel_size, sigma);
        filtered_img = imfilter(noise_img, kernel, 'replicate');
      case 3
        filtered_img = medfilt2(noise_img, kernel_size);
    end

    % Sharpening
    sharpened_img = imfilter(filtered_img, sharp_kernel);
    sharpened_img = filtered_img + cost * sharpened_img;

    % Img view
    subplot(length(kernels),2,1 + 2 * (k - 1))
    imshow(filtered_img);
    colormap gray;
    axis image;
    colorbar;
    title("Filtrato Kernel = [" + kernel_size(1) + " " + kernel_size(1) + "]")

    subplot(length(kernels),2,2 + 2 * (k - 1))
    imshow(sharpened_img);
    colormap gray;
    axis image;
    colorbar;
    title("Sharpened Kernel = [" + kernel_size(1) + " " + kernel_size(1) + "]")
  end
end
%%
