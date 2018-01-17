function [ neighbors_up, center, neighbors_down ] = get_index_nhood( mask, kernel )
%GET_INDEX_NHOOD Returns the indexes of neighbor elements corresponding to kernel
%   Input:
%   mask: array indicating elements to be processed
%   kernel: array marking the neighborhood
%
%   Output:
%   neighbors_up: Upstream indexes wrt center indexes
%   center: centervoxel indexes
%   neighbors_down: Downstream indexes wrt center indexes

% Convert mask to logical and capture its dimensions
mask = logical(mask);
sz = size(mask);

% Determine boundary thinkness from kernel
bdry_thick = floor(size(kernel)/2);

% Create a boundary mask to differentiate core from bdry elements
boundary = false(sz);
alldims = arrayfun(@(d) 1:d, sz, 'UniformOutput', false);
for dim = 1:length(sz)
    ad = alldims;
    ad{dim} = [1:bdry_thick(dim), (sz(dim)-bdry_thick(dim)+1):sz(dim)];
    boundary(ad{:}) = true;
end
% boundary(1,:,:) = true;
% boundary(end,:,:) = true;
% boundary(:,1,:) = true;
% boundary(:,end,:) = true;
% boundary(:,:,1) = true;
% boundary(:,:,end) = true;

% Create separate masks for core and boundary elements
core_mask = mask & (~boundary);
bdry_mask = mask & boundary;

% Get element indexes
core_indexes = find(core_mask(:));
bdry_indexes = find(bdry_mask(:));

% Use kernel dimensions to build a N-dimensional grid
szk = size(kernel);
dim = {};
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

% Find all connected element pairs by adding the 
nhood = bsxfun(@plus, core_indexes, offsets(:)');

% Split linear indexes wrt center indexes
neighbors_up = nhood(:,1:(L-1));
neighbors_down = nhood(:,(L+1):end);
center = nhood(:,L);