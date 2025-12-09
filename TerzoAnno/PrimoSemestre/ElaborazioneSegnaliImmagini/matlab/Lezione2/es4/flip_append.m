function [flipped] = flip_append(vec)
  [height, width] = size(vec);
  if (height > 1 & width > 1)
    error("Input must be a vector");
  end
  if (height > 1)
    error("Input must be a row vector");
  end

  flipped = [flip(vec) vec];
end
