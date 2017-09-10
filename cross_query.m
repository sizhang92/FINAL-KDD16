function s = cross_query(A1, A2, N1, N2, H, alpha, r, p, idx)

% This function computes the similarity vector s, for the scenario that
% only node attributes are available in two networks. And this
% is for the application that we want to query the corss-network
% similarities for a specific query node in one network.
%
% Input:
%   - A1, A2: adjacency matrices of two networks G1 and G2;
%   - N1, N2: Node attributes matrices, N1 is an n1*K matrix, N2 is an n2*K
%         matrix, each row is a node, and each column represents an
%         attribute. If the input node attributes are categorical, we can
%         use one hot encoding to represent each node feature as a vector.
%         And the input N1 and N2 are still n1*K and n2*K matrices.
%         E.g., for node attributes as countries, including USA, China, Canada, 
%         if a user is from China, then his node feature is (0, 1, 0).
%   - H: an n2*n1 prior node similarity matrix, e.g., degree similarity. H
%        should be normalized, e.g., sum(sum(H)) = 1.
%   - alpha: a parameter that controls the importance of the consistency
%       principles, that is, 1-alpha controls the importance of prior
%       knowledge.
%   - r: the rank of the low-rank approximations on matrices A1, and A2.
%   - p: the rank for SVD on the prior knowledge matrix H. 
%   - idx: the index of the query node in network G1.
%
% Output: 
%   - s: an n2*1 vector measuring the similarities between the query node
%        in network G1 and all the nodes in network G2.

n1 = size(A1,1); n2 = size(A2,1);
K = size(N1, 2);
% Normalize node feature vectors
K1 = sum(N1.^2, 2).^(-0.5); K1(K1 == Inf) = 0;
K2 = sum(N2.^2, 2).^(-0.5); K2(K2 == Inf) = 0;
N1 = bsxfun(@times, K1, N1); % normalize the node attribute for A1
N2 = bsxfun(@times, K2, N2); % normalize the node attribute for A2
N = spconvert([n1*n2, 1, 0]);
for k = 1: K
    N = N + kron(N1(:, k), N2(:, k));   % compute N as a kronecker similarity
end

% compute the degree matrix of A1 and A2, as well as their inverse
d1 = sum(A1, 2); d2 = sum(A2, 2);
D1 = 1 ./ d1; D2 = 1 ./ d2;
D1(D1 == Inf) = 0; D2(D2 == Inf) = 0;

% low-rank approximation on A, B, and H'
[U1, Lambda1] = eigs(A1, r);
[U2, Lambda2] = eigs(A2, r);
[U, Sin, V] = svds(H, p);

% compute the matrix g by the equations in the paper
sigma = zeros(r^2, r^2); g = zeros(r^2, 1);
for i = 1: K 
    T1 = N1(:, i) .* D1; T2 = N2(:, i) .* D2;  
    sigma = sigma + kron(U1' * (bsxfun(@times, T1, U1)), U2' * (bsxfun(@times, T2, U2)));  
    for j = 1: p
        g = g + Sin(j,j)*kron(U1'*(N1(:, i).*sqrt(D1).*V(:,j)),U2'*(N2(:, i).*sqrt(D2).*U(:,j)));
    end
end

% compute the matrix /Lambda by the equations in the paper
Lambda = kron(diag(1./diag(Lambda1)), diag(1./diag(Lambda2)))-alpha*sigma;

% query the cross-network similarity vector for the node-idx in network G1
Da = (d1(idx)*d2).^(-0.5);
Da(Da == Inf) = 0;
Na = N1(idx, :);
NN = (Na * N2')';
s = (1-alpha) * H(:, idx) + alpha*(1-alpha) * (Da .* NN) .* (kron(U1(idx, :), U2)*(Lambda \ g));


