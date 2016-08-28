function S=final_NE(A, B, H, node_label1, node_label2, edge_label1, edge_label2, l_node, l_edge, alpha, max_iter, relax)

% This function computes the similarity matrix S, for the scenario that
% both categorical node attributes and edge attributes are available in two
% networks.
% To explain, categorical node attributes can be taken examples as gender
% (including two different attributes, male and female), locations
% (including different countries, and so on). Categorical edge attributes
% can be taken examples as different levels of communication closeness
% between two users, such as 'contacts' and 'friends'.
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
%   - edge_label1, edge_label2: edge categorical attribute matrices of two
%       networks. Each of them has the same size as their corresponding
%       adjacency matrix. All non-zero entries represent the edge attribute
%       values.
%   - l_node, l_edge: the number of node attribute values, and the number of edge
%       attribute values.
%   - alpha: a parameter that controls the importance of the consistency
%       principles, that is, 1-alpha controls the importance of prior
%       knowledge.
%   - max_iter: the number of iterations
%   - relax: either 0 or 1. If relax == 1, then we relax the degree matrix
%       (a vector) of the resultant attributed Kronecker product graph to deg =
%       kron(d1,d2). 
% Output: an m*n matrix measuring the similarities between two nodes across
%         networks.

m = size(A,1);
n = size(B,1);

% compute the kronecker products and construct the node attribute matrix N
N = []; deg = [];
for i = 1:l_node
    [rn1, cn1, ~] = find(node_label1 == i);
    [rn2, cn2, ~] = find(node_label2 == i);
    N1 = sparse(rn1, cn1, 1, m, 1);
    N2 = sparse(rn2, cn2, 1, n, 1);
    if isempty(N), N = kron(N2, N1);
    else N = N + kron(N2, N1); end 
end

% compute the degree matrix of the kronecker product matrix \tilde{W}
E1 = cell(l_edge, 1); E2 = cell(l_edge, 1);
for i = 1:l_edge
    [re1, ce1, ~] = find(edge_label1 == i);
    [re2, ce2, ~] = find(edge_label2 == i);
    E1{i} = sparse(re1, ce1, 1, m, m);
    E2{i} = sparse(re2, ce2, 1, n, n);
    if relax == 0
        for j = 1:l_node
            [rn1, cn1, ~] = find(node_label1 == j);
            [rn2, cn2, ~] = find(node_label2 == j);
            N1 = sparse(rn1, cn1, 1, m, 1);
            N2 = sparse(rn2, cn2, 1, n, 1);
            if isempty(deg), deg = kron((B.*E2{i})*N2,(A.*E1{i})*N1);
            else deg = deg + kron((B.*E2{i})*N2,(A.*E1{i})*N1); end
        end
    end 
end

if relax == 1, deg = kron(sum(B,2),sum(A,2)); end
    
D = 1./sqrt(deg);
D(D == Inf) = 0;
H = H./sum(sum(H)); y = H(:); % normalize the preference matrix H

fprintf('iteration begins.\n');

% update of the fixed-point solution
for i = 1:max_iter
    tic;
    temp = zeros(m,n);
    S = reshape(D.*N.*y,m,n); x = y;
    for k = 1:l_edge
        W1 = E1{k}.*A; W2 = E2{k}.*B;
        for j = 1:n
            temp(:,j) = temp(:,j) + W1*(S*W2(:,j));
        end
    end
    y = alpha*(D.*N).*reshape(temp,m*n,1) + (1-alpha)*H(:);
    y = y./sum(y);
    delta = norm(x-y,1);
    fprintf('iteration %d, delta=%f, running time=%f\n',i, delta, toc);
end
% reshape the result to the similarity matrix S
S = reshape(y,m,n);
