function [ map ] = get_index_pairs( mask, kernel )
%GET_INDEX_PAIRS Returns the index pairs corresponding to kernel
%   Input:
%   mask: array indicating elements to be processed
%   kernel: array marking the neighborhood
%
%   Output:
%   map: sparse matrix marking which elements in the mask are paired
%   through the kernel

% Find all connected element pairs
[neighbors_up, center, neighbors_down] = get_index_nhood(mask, kernel);

% Process core elements:
% Mark index pairs in lower diagonal part of map
% Initialize map as an empty sparse matrix
V = numel(mask);
long_center = repmat(center,1,size(neighbors_up,2));
ii = [long_center(:); neighbors_down(:)];
long_center = repmat(center,1,size(neighbors_down,2));
jj = [neighbors_up(:); long_center(:)];
vv = true(size(ii));
pairs = unique([ii jj vv],'rows');
map = sparse(pairs(:,1),pairs(:,2),pairs(:,3),V,V);

end

