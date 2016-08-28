function S = final_E(A, B, H, edge_label1, edge_label2, l_edge, alpha, max_iter, relax)


% This function computes the similarity matrix S, for the scenario that
% only categorical edge attributes are available in two
% networks.
% To explain, categorical edge attributes can be taken examples as different 
% levels of communication closeness between two users, such as 'contacts' 
% and 'friends'.
% To use this code:
% Input:
%   - A, B: adjacency matrices of two networks G1 and G2;
%   - H: prior knowledge of preference alignment matrix, such as name
%       similarity matrix between two users' name, degree similarity matrix,
%       or even a uniform probability matrix.
%   - edge_label1, edge_label2: edge categorical attribute matrices of two
%       networks. Each of them has the same size as their corresponding
%       adjacency matrix. All non-zero entries represent the edge attribute
%       values.
%   - l_edge: the number of edge attribute values.
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
deg = []; E1 = cell(l_edge, 1); E2 = cell(l_edge, 1);
for i=1:l_edge
    [re1, ce1, ~] = find(edge_label1 == i);
    [re2, ce2, ~] = find(edge_label2 == i);
    E1{i} = sparse(re1, ce1, 1, m, m);
    E2{i} = sparse(re2, ce2, 1, n, n);
    if relax == 0
        if isempty(deg), deg = kron(sum(B.*E2{i},2),sum(A.*E1{i},2));
        else deg=deg+kron(sum(B.*E2{i},2),sum(A.*E1{i},2)); end
    end 
end

if relax == 1, deg = kron(sum(B,2),sum(A,2)); end

D=1./sqrt(deg);
D(D==Inf)=0;
% normalize the preference matrix H
H=H./sum(sum(H)); y = H(:);

% update of the fixed-point solution
for i=1:max_iter
    tic;
    temp=zeros(m,n);
    S=reshape(D.*y,m,n); x = y;
    for k=1:l_edge
        W1 = E1{k}.*A; W2 = E2{k}.*B;
        for j=1:n
            temp(:,j)=temp(:,j)+W1*(S*W2(:,j));
        end
    end
    y=alpha*D.*reshape(temp,m*n,1)+(1-alpha)*H(:);
    y=y./sum(y);
    delta=norm(x-y,1);
    fprintf('iteration %d, delta=%f, running time=%f\n',i, delta, toc);
end
S=reshape(y,m,n);
