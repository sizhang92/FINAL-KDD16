%% run flickr-lastfm
load('flickr-lastfm.mat');
alpha = 0.4; maxiter = 30; tol = 1e-4;
H = full(H);
S = FINAL(flickr, lastfm, flickr_node_label, lastfm_node_label, flickr_edge_label, ...
        lastfm_edge_label, H, alpha, maxiter, tol);
    
M = greedy_match(S);
[row, col] = find(M);
acc = size(intersect([col row], gndtruth, 'rows'), 1)/size(gndtruth, 1);
