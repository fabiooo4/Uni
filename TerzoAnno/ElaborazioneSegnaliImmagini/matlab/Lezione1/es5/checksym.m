%% Returns 1 if a matrix is symmetric, 0 otherwise
function [res] = checksym(mat)
  sz = size(mat);
  if (sz > 1)
    if (sz(1) == sz(2))
      if (mat == mat')
        res = 1;
        return;
      end

    else
      error("Input must be a square matrix");
    end
  else
    error("Input must be a matrix");
  end
  res = 0;
end
