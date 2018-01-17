function out = indexNDArray(in, dim, page)
% Index page in arbitrary dimension of input ND array
% Obtained from this answer in MATLAB central:
%  https://www.mathworks.com/matlabcentral/answers/179926-indexing-one-particular-dimension-regardless-of-number-of-dimensions
%
   validateattributes(dim, {'numeric'}, {'scalar', 'positive', '<=', ndims(in)});
   validateattributes(page, {'numeric'}, {'scalar', 'positive', '<=', size(in, dim)});
   alldims = arrayfun(@(d) 1:d, size(in), 'UniformOutput', false);
   alldims{dim} = page;
   out = in(alldims{:});
end