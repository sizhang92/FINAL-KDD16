function P = UniAlign(N1, N2, lambda)
% Description:
%   The alogrithm is a variant of BigAlign which is for bipartite graph.
%   The alogrithm converts unipartite graph to bipartite graph where the
%   other set of nodes represent the node attributes.
%
% Input:
%   - N1, N2: node attribute matrix, where each row represents a node and
%   each column represents an attribute, i.e., (r, c, v) represents that
%   the r-th node has a value of v on the attribute c
% Output:
%   - P: the n2*n1 alignment matrix
%
% Reference:
%   Koutra, Danai, Hanghang Tong, and David Lubensky. 
%   Big-align: Fast bipartite graph alignment.
%   Data Mining (ICDM), 2013 IEEE 13th International Conference on. IEEE, 2013.

n2 = size(N2, 1); d = size(N2, 2);
[U, S, ~] = svds(N1, d);
for i = 1: size(S, 2)
    S(i, i) = 1 ./ S(i, i)^2;
end
X = N1'*U*S*U';
Y = lambda/2*sum(U*S*U', 1);
P = N2*X - repmat(Y, [n2, 1]);

