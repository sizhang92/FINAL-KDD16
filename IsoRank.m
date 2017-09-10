function S = IsoRank(A1, A2, H, alpha, maxiter, tol)
% Description:
%   The algorithm computes the alignment/similarity matrix by a random walk
%   based method. This algorithm is for non-attributed networks.
% Input: 
%   - A1, A2: adjacency matrices of two networks
%   - H: the prior node similarity matrix, e.g., degree similarity matrix
%   - alpha: decay factor, i.e., how important the global topology
%            consistency is
%   - maxiter: maximum number of iterations
%
% Output:
%   - S: an n2*n1 alignment matrix, entry (x,y) represents to what extend node-
%    x in A2 is aligned to node-y in A1
%
% Reference:
%   Singh, Rohit, Jinbo Xu, and Bonnie Berger. 
%   Global alignment of multiple protein interaction networks with application to functional orthology detection.
%   Proceedings of the National Academy of Sciences 105.35 (2008): 12763-12768.

n1 = size(A1, 1); n2 = size(A2, 1);
% Normalize the adjacency matrices
d1 = 1 ./ sum(A1, 2);
d2 = 1 ./ sum(A2, 2);
d1(d1 == Inf) = 0;
d2(d2 == Inf) = 0;

W1 = bsxfun(@times, d1, A1);
W2 = bsxfun(@times, d2, A2);

S = ones(n2, n1) ./ (n2*n1);
% IsoRank algorithm in matrix form
for iter = 1: maxiter   
    prev = S(:);
    S = alpha * W2' * S * W1 + (1-alpha) * H;
    delta = norm(S(:) - prev);
    fprintf('iteration %d with delta=%f\n',iter,delta);
    if delta < tol, break; end
end
