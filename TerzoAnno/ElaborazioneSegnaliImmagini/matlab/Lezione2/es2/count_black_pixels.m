function [black_count] = count_black_pixels(img)
  if (~ismatrix(img))
    error("Input image must be a 2D matrix");
  end
  if (ndims(img) > 2) %#ok<ISMAT>
    error("Input image must be grayscale");
  end

  black_count = zeros(256,1);
  for black_value = 1:256
    black_count(black_value) = numel(find(img == black_value - 1));
  end
end
