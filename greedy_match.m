function [M, dt] = greedy_match(X)
% greedy_match Computes a bipartite matching based on the scores in input
% matrix
%
% Input arguments:
% - X: the matrix with the similarity scores (similarity matrix).
%     Note that element X(i,j) is the similarity score of node i in B 
%     and node j in A; if B has m nodes and A has n nodes then X is an 
%     m x n matrix.
% Output arguments:
% - M: the sparse matrix with the matches: M(i,j) = 1.0 iff node i in B
%     matches with node j in A. m x n matrix (same dimensions with X) -
%     called also "matching matrix".
% - dt: the time in seconds for the operation.

[m, n] = size(X);
N = m * n;
t0 = clock;

x = X(:);
clear X

minSize = min(m, n);
usedRows = zeros(m, 1);
usedCols = zeros(n, 1);

maxList = zeros(minSize, 1);
row = zeros(minSize, 1);
col = zeros(minSize, 1);

[y, ix] = sort(x, 'descend');
% fprintf('matching stage 1\n');
% y = x(x~=0);
% idx = find(x==0);
% fprintf('matching stage 2\n');
% [~,id] = sort(x(x~=0), 'descend');
% ix = [id; idx];
% clear y

matched = 1;
index = 1;
% fprintf('matching stage 3\n');
while (matched <= minSize)
%     fprintf('\t\t matched = %d\n',matched);
%     fprintf('\t\t index = %d\n',index);
    
    ipos = ix(index); % position in the original vectorized matrix
    jc = ceil(ipos / m);   
    ic = ipos - (jc - 1) * m;
    if ic == 0, ic = 1; end
    if (usedRows(ic) ~= 1 && usedCols(jc) ~= 1) 
        matched;
        row(matched) = ic;
        col(matched) = jc;
		maxList(matched) = x(index);
		usedRows(ic) = 1;
		usedCols(jc) = 1;
        
		matched = matched + 1;
    end
    
    index = index + 1;
end
data = ones(minSize, 1);

M = sparse(row, col, data, m, n);
dt = etime(clock, t0); 


end

