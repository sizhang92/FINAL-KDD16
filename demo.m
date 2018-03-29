%% run flickr-lastfm
alpha = 0.3; maxiter = 30; tol = 1e-4;
S = FINAL(flickr, lastfm, flickr_node_label, lastfm_node_label, flickr_edge_label, ...
        lastfm_edge_label, H, alpha, maxiter, tol);
    
M = greedy_match(S);
[row, col] = find(M);
acc = size(intersect([col row], gndtruth, 'rows'), 1)/size(gndtruth, 1);

%% run douban
alpha = 0.82; maxiter = 30; tol = 1e-4;
S = FINAL(online, offline, online_node_label, offline_node_label, online_edge_label, ...
        offline_edge_label, H, alpha, maxiter, tol);

M = greedy_match(S);
[row, col] = find(M);
acc = size(intersect([col row], ground_truth, 'rows'), 1)/size(ground_truth, 1);   