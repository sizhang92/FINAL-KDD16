function S = finalN_low(A, B, H, node_label1, node_label2, l_node, alpha, r, relax)


% This function computes the similarity matrix S, for the scenario that
% only categorical node attributes are available in two
% networks.
% To explain, categorical node attributes can be taken examples as gender
% (including two different attributes, male and female), locations
% (including different countries, and so on). 
% To use this code:
% Input:
%   - A, B: adjacency matrices of two networks G1 and G2;
%   - H: prior knowledge of preference alignment matrix, such as name
%       similarity matrix between two users' name, degree similarity matrix,
%       or even a uniform probability matrix.
%   - node_label1, node_label2: node categorical attribute vectors of two
%       networks. If there are three different categories, such as China,
%       America and India, then these two vectors can take values from either
%       1, 2, or 3.
%   - l_node: the number of node attribute values.
%   - alpha: a parameter that controls the importance of the consistency
%       principles, that is, 1-alpha controls the importance of prior
%       knowledge.
%   - r: the rank of the low-rank approximations on matrices A, and B.
%   - relax: either 0 or 1. If relax == 1, then we relax the degree matrix
%       (a vector) of the resultant attributed Kronecker product graph to deg =
%       kron(d1,d2). 
% Output: an m*n matrix measuring the similarities between two nodes across
%         networks.

m = size(A,1);
n = size(B,1);

% compute the degree matrix of the kronecker product matrix \tilde{W}
N = []; deg = [];
for i = 1:l_node
    [rn1,cn1,~] = find(node_label1 == i);
    [rn2,cn2,~] = find(node_label2 == i);
    N1 = sparse(rn1, cn1, 1, m, 1);
    N2 = sparse(rn2, cn2, 1, n, 1);
    if isempty(N), N = kron(N2, N1);
    else N = N + kron(N2, N1); end 
    if relax == 0
        if isempty(deg), deg = kron(B*N2, A*N1);
        else deg = deg + kron(B*N2, A*N1); end
    end
end

if relax == 1, deg = kron(sum(B,2),sum(A,2)); end

% low-rank approximation on two adjacency matrices A and B
[U1,Lambda1]=eigs(A,r);
[U2,Lambda2]=eigs(B,r);

% compute the matrix \Lambda by the equations in the paper
D = 1./(N.*deg); D(D == Inf) = 0;
U = kron(U2, U1);
eta = U'*bsxfun(@times, D.*N, U);
Lambda = inv(kron(diag(1./diag(Lambda2)), diag(1./diag(Lambda1))) - alpha*eta);
% normalize the preference matrix H and vectorize
h = H(:)./sum(sum(H));

% compute the approximate closed-form solution
x = alpha*(1-alpha)*N.*D.*h;
s = (1-alpha)*h + D.*N.*((U*Lambda)*(U'*x));
S = reshape(s,m,n);
toc
