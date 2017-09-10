function S = FINAL(A1, A2, N1, N2, E1, E2, H, alpha, maxiter, tol)
% Description:
%   The algorithm is the generalized attributed network alignment algorithm.
%   The algorithm can handle the cases no matter node attributes and/or edge
%   attributes are given. If no node attributes or edge attributes are given,
%   then the corresponding input variable of the function is empty, e.g.,
%   N1 = [], E1 = {}.
%   The algorithm can handle either numerical or categorical attributes
%   (feature vectors) for both edges and nodes.
%
%   The algorithm uses cosine similarity to calculate node and edge feature
%   vector similarities. E.g., sim(v1, v2) = <v1, v2>/(||v1||_2*||v2||_2).
%   For categorical attributes, this is still equivalent to the indicator
%   function in the original published paper.
%
% Input:
%   A1, A2: Input adjacency matrices with n1, n2 nodes
%   N1, N2: Node attributes matrices, N1 is an n1*K matrix, N2 is an n2*K
%         matrix, each row is a node, and each column represents an
%         attribute. If the input node attributes are categorical, we can
%         use one hot encoding to represent each node feature as a vector.
%         And the input N1 and N2 are still n1*K and n2*K matrices.
%         E.g., for node attributes as countries, including USA, China, Canada, 
%         if a user is from China, then his node feature is (0, 1, 0).
%         If N1 and N2 are emtpy, i.e., N1 = [], N2 = [], then no node
%         attributes are input. 
%
%   E1, E2: a L*1 cell, where E1{i} is the n1*n1 matrix and nonzero entry is
%         the i-th attribute of edges. E2{i} is same. Similarly,  if the
%         input edge attributes are categorical, we can use one hot
%         encoding, i.e., E1{i}(a,b)=1 if edge (a,b) has categorical
%         attribute i. If E1 and E2 are empty, i.e., E1 = {} or [], E2 = {}
%         or [], then no edge attributes are input.
%
%   H: a n2*n1 prior node similarity matrix, e.g., degree similarity. H
%      should be normalized, e.g., sum(sum(H)) = 1.
%   alpha: decay factor 
%   maxiter, tol: maximum number of iterations and difference tolerance.
%
% Output: 
%   S: an n2*n1 alignment matrix, entry (x,y) represents to what extend node-
%    x in A2 is aligned to node-y in A1
%
% Reference:
%   Zhang, Si, and Hanghang Tong. "FINAL: Fast Attributed Network Alignment." 
%   Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining. ACM, 2016.


n1 = size(A1, 1); n2 = size(A2, 1);

% If no node attributes input, then initialize as a vector of 1
% so that all nodes are treated to have the save attributes which 
% is equivalent to no given node attribute.
if isempty(N1) && isempty(N2)
    N1 = ones(n1, 1);
    N2 = ones(n2, 1);
end

% If no edge attributes are input, i.e., E1 and E2 are empty, then
% initialize as a cell with 1 element, which is same as adjacency matrix
% but the entries that are nonzero in adjacency matrix are equal to 1 so 
% that all edges are treated as with the same edge attributes. This is 
% equivalent to no given edge attributes.
if isempty(E1) && isempty(E2)
    E1 = cell(1,1); E2 = cell(1,1);
    E1{1} = A1; E2{1} = A2;
    E1{1}(A1 > 0) = 1; E2{1}(A2 > 0) = 1;
end
    
K = size(N1, 2); L = size(E1, 2);
T1 = spconvert([n1, n1, 0]);
T2 = spconvert([n2, n2, 0]);

% Normalize edge feature vectors 

for l = 1: L
    T1 = T1 + E1{l}.^2; % calculate ||v1||_2^2
    T2 = T2 + E2{l}.^2; % calculate ||v2||_2^2
end
T1 = spfun(@(x) 1./sqrt(x), T1); T2 = spfun(@(x) 1./sqrt(x), T2);
for l = 1: L
   E1{l} = E1{l} .* T1; % normalize each entry by vector norm T1
   E2{l} = E2{l} .* T2; % normalize each entry by vector norm T2
end

% Normalize node feature vectors
K1 = sum(N1.^2, 2).^(-0.5); K1(K1 == Inf) = 0;
K2 = sum(N2.^2, 2).^(-0.5); K2(K2 == Inf) = 0;
N1 = bsxfun(@times, K1, N1); % normalize the node attribute for A1
N2 = bsxfun(@times, K2, N2); % normalize the node attribute for A2

% Compute node feature cosine cross-similarity
N = spconvert([n1*n2, 1, 0]);
for k = 1: K
    N = N + kron(N1(:, k), N2(:, k));   % compute N as a kronecker similarity
end

% Compute the Kronecker degree vector
d = spconvert([n1*n2, 1, 0]);
tic;
for l = 1: L
    for k = 1: K 
        d = d + kron((E1{l} .* A1) * N1(:, k), (E2{l} .* A2) * N2(:,k));
    end
end
fprintf('Time for degree: %.2f sec\n', toc);
D = N .* d; DD = D.^(-0.5);
DD(D == 0) = 0;     % define inf to 0

% fixed-point solution
q = DD .* N; 
h = H(:); s = h;

for i = 1: maxiter
    fprintf('iteration %d\n', i);
    tic;
    prev = s;
    M = reshape(q.*s, n2, n1);
    S = spconvert([n2, n1, 0]);
    for l = 1: L
        S = S + (E2{l} .* A2) * M * (E1{l} .* A1);    % calculate the consistency part
    end
    s = (1 - alpha) * h + alpha * q .* S(:);   % add the prior part
    diff = norm(s-prev);
    
    fprintf('Time for iteration %d: %.2f sec, diff = %.5f\n', i, toc, 100*diff);
    if diff < tol   % if converge
        break;
    end
end

S = reshape(s, n2, n1);   % reshape the similarity vector to a matrix
