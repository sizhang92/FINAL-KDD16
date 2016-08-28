function S = final_N(A, B, H, node_label1, node_label2, l_node, alpha, max_iter, relax)

% This function computes the similarity matrix S, for the scenario that
% only categorical node attributes are available in two networks.
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
%   - max_iter: the number of iterations
%   - relax: either 0 or 1. If relax == 1, then we relax the degree matrix
%       (a vector) of the resultant attributed Kronecker product graph to deg =
%       kron(d1,d2). 
% Output: an m*n matrix measuring the similarities between two nodes across
%         networks.


m=size(A,1);
n=size(B,1);

% compute the degree matrix of the kronecker product matrix \tilde{W}
N = []; deg = [];
for i=1:l_node
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

D=1./sqrt(deg);
D(D==Inf)=0;
% normalize the preference matrix H
H=H./sum(sum(H)); y = H(:);

fprintf('iteration begins.\n');

% update of the fixed-point solution
for i=1:max_iter
    tic;
    temp=zeros(m,n);
    S=reshape(D.*N.*y,m,n); x = y;
    for j=1:n
        temp(:,j)=A*(S*B(:,j));
    end
    y=alpha*N.*D.*reshape(temp,m*n,1)+(1-alpha)*H(:);
    y=y./sum(y);
    delta=norm(x-y,1);
    fprintf('iteration %d, delta=%f, running time=%f\n',i, delta, toc);
end
S=reshape(y,m,n);
