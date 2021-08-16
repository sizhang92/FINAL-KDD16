%% run douban
load('Douban.mat');
alpha = 0.82; maxiter = 30; tol = 1e-4;
S = FINAL(online, offline, online_node_label, offline_node_label, online_edge_label, ...
        offline_edge_label, H, alpha, maxiter, tol);

M = greedy_match(S);
[row, col] = find(M);
acc = size(intersect([col row], ground_truth, 'rows'), 1)/size(ground_truth, 1);   