%% run flickr-myspace
load('flickr-myspace.mat');
alpha = 0.4; maxiter = 30; tol = 1e-4;
H = full(H);
S = FINAL(flickr, myspace, flickr_node_label, myspace_node_label, flickr_edge_label, ...
        myspace_edge_label, H, alpha, maxiter, tol);
    
M = greedy_match(S);
[row, col] = find(M);
acc = size(intersect([col row], gndtruth, 'rows'), 1)/size(gndtruth, 1);
