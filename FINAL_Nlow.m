function S = FINAL_Nlow(A1, A2, N1, N2, H, alpha, r)
% Description:
%   This function computes the similarity matrix S, for the scenario that
%   only categorical/numerical node attributes are available in two
%   networks.
%   To explain, categorical node attributes can be taken examples as gender
%   (including two different attributes, male and female), locations
%   (including different countries, and so on). Numerical node attributes
%   can be the number of papers published in different venues by an author.
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
%         
%   - H: an n2*n1 prior node similarity matrix, e.g., degree similarity. H
%        should be normalized, e.g., sum(sum(H)) = 1.
%   - alpha: a parameter that controls the importance of the consistency
%            principles, that is, 1-alpha controls the importance of prior
%            knowledge.
%   - r: the rank of the low-rank approximations on matrices A1 and A2.
%
% Output:
%   - S: an n2*n1 alignment matrix, entry (x,y) represents to what extend node-
%        x in A2 is aligned to node-y in A1
% Reference:
%   Zhang, Si, and Hanghang Tong. "FINAL: Fast Attributed Network Alignment." 
%   Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining. ACM, 2016.


n1 = size(A1, 1); n2 = size(A2, 1);
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

% Compute the Kronecker degree vector
d = spconvert([n1*n2, 1, 0]);
for k = 1: K 
    d = d + kron(A1 * N1(:, k), A2 * N2(:,k));
end
DD = N .* d; D = DD.^(-0.5);
D(DD == 0) = 0;     % define inf to 0

% Low-rank approximation on A1 and A2 by eigenvalue decomposition
[U1,Lambda1]=eigs(A1,r);
[U2,Lambda2]=eigs(A2,r);

% compute the matrix \Lambda by the equations in the paper
U = kron(U1, U2);
eta = U'*bsxfun(@times, D.*N, U);
Lambda = kron(diag(1./diag(Lambda2)), diag(1./diag(Lambda1))) - alpha*eta;

h = H(:);

% compute the approximate closed-form solution
x = alpha*(1-alpha)*N.*D.*h;
s = (1-alpha)*h + D.*N.*(U*(Lambda\(U'*x)));
S = reshape(s,n2,n1);
