function s = cross_query(A, B, H, node_label1, node_label2, l_node, alpha, r, p, idx)

% This function computes the similarity vector s, for the scenario that
% only categorical node attributes are available in two networks. And this
% is for the application that we want to query the corss-network
% similarities for a query node in one network.
% 
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
%   - p: the rank for SVD on the prior knowledge matrix H. 
%   - idx: the index of the query node in network G1.
% Output: an n*1 vector measuring the similarities between the query node
%         in network G1 and all the nodes in network G2.

m=size(A,1);
n=size(B,1);

% compute the degree matrix of A and B, as well as their inverse
d1 = sum(A,2);d2 = sum(B,2);
D1 = 1./d1; D2 = 1./d2;
D1(D1 == Inf) = 0; D2(D2 == Inf) = 0;

% low-rank approximation on A, B, and H'
[U1,Lambda1]=eigs(A,r);
[U2,Lambda2]=eigs(B,r);
H = H./sum(sum(H)); [U,S,V]=svds(H',p);

% compute the matrix g by the equations in the paper
sigma = []; g = zeros(r^2,1);
for i = 1:l_node
    [rn1,cn1,~] = find(node_label1 == i);
    [rn2,cn2,~] = find(node_label2 == i);
    N1 = sparse(rn1, cn1, 1, m, 1);
    N2 = sparse(rn2, cn2, 1, n, 1);
    T1 = N1.*D1; T2 = N2.*D2;  
    if isempty(sigma), sigma = kron(U1'*(bsxfun(@times,T1,U1)),U2'*(bsxfun(@times,T2,U2)));
    else sigma = sigma + kron(U1'*(bsxfun(@times,T1,U1)),U2'*(bsxfun(@times,T2,U2))); end 
    for j = 1:p
        g = g + S(j,j)*kron(U1'*(N1.*sqrt(D1).*V(:,j)),U2'*(N2.*sqrt(D2).*U(:,j)));
    end
end

% compute the matrix /Lambda by the equations in the paper
Lambda = inv(kron(diag(1./diag(Lambda2)), diag(1./diag(Lambda1)))-alpha*sigma);

% query the cross-network similarity vector for the node-idx in network G1
Da = (d1(idx)*d2).^(-0.5);
Da(Da == Inf) = 0;
N1=node_label1(idx);
N2=node_label2;
N2(N2~=N1)=0;
N2(N2==N1)=1; Na=N2;
s = (1-alpha)*H(idx,:)' + alpha*(1-alpha)*(Da.*Na).*(kron(U1(idx,:),U2)*Lambda*g);


