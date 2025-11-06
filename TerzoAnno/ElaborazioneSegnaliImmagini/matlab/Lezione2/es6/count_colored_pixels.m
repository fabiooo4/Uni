function [color_count] = count_colored_pixels(img)
  if (ndims(img) > 3)
    error("Input image must be a truecolor image");
  end
  [~, ~, num_channels] = size(img);
  if (num_channels > 3)
    error("Input image must be a truecolor image with 3 color channels");
  end

  color_count = zeros(256,3);
  for color_channel = 1:num_channels
    for color_value = 1:256
      color_count(color_value, color_channel) = numel(find(img(:,:,color_channel) == color_value - 1));
    end
  end
end
