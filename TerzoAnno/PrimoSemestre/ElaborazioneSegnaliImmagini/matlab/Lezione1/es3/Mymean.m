function [out] = Mymean(obj)
  size_obj = size(obj);
  is_vec = size_obj(1) == 1 || size_obj(2) == 1;
  if (is_vec)
    out = sum(obj) / numel(obj);
  else
    sums = sum(obj);
    out = sums / size_obj(1);
  end
end
