function [ map ] = get_index_pairs( mask, kernel )
%GET_INDEX_PAIRS Returns the index pairs corresponding to kernel
%   Input:
%   mask: array indicating elements to be processed
%   kernel: array marking the neighborhood
%
%   Oouput:
%   map: sparse matrix marking which elements in the mask are paired
%   through the kernel

% Convert mask to logical and capture its dimensions
mask = logical(mask);
sz = size(mask);

% Create a boundary mask to differentiate core from bdry elements
boundary = false(sz);
boundary(1,:,:) = true;
boundary(end,:,:) = true;
boundary(:,1,:) = true;
boundary(:,end,:) = true;
boundary(:,:,1) = true;
boundary(:,:,end) = true;

% Create separate masks for core and boundary elements
core_mask = mask & (~boundary);
bdry_mask = mask & boundary;

% Get element indexes
core_indexes = find(core_mask(:));
bdry_indexes = find(bdry_mask(:));

% Use kernel dimensions to build a N-dimensional grid
szk = size(kernel);
for dd = 1:length(szk)
    dim{dd} = 1:szk(dd);
end
N = length(sz);
[c1{1:N}] = ndgrid(dim{:});

% Get kernel central element coordinates
c2(1:N) = num2cell(ceil(szk/2));%,1,ones(1,N));

% Get linear index offsets:
% Convert ndgrid elements into liner indexes and
% subtract linear index value of kernel central coordinates
offsets = sub2ind(sz,c1{:}) - sub2ind(sz,c2{:});
L = ceil(length(offsets(:))/2);

% Initialize map as an empty sparse matrix
V = prod(sz);
map = sparse(V,V);

% Find all connected element pairs by adding the 
nhood = bsxfun(@plus, core_indexes, offsets(:)');

% Split linear indexes wrt center indexes
neighbors_up = nhood(:,1:(L-1));
neighbors_down = nhood(:,(L+1):end);
center = nhood(:,L);

% Process core elements:
% Mark index pairs in lower diagonal part of map
long_center = repmat(center,1,size(neighbors_up,2));
map(sub2ind(size(map),long_center(:),neighbors_up(:))) = true;
long_center = repmat(center,1,size(neighbors_down,2));
map(sub2ind(size(map),neighbors_down(:),long_center(:))) = true;

end

