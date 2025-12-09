function [dist] = euclidean_distance(v1, v2)
  sum = 0;
  for i = 1:length(v1)
    sum = sum + power(v2(i) - v1(i), 2);
  end
  dist = sqrt(sum);
end
