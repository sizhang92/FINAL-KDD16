load('ACM-DBLP.mat');
alpha = 0.9;

%% run FINAL algorithm with numerical attributes
S1 = FINAL(ACM_sub, DBLP_sub, ACM_node_feature_sub, DBLP_node_feature_sub,...
    ACM_edge_feature_cat, DBLP_edge_feature_cat, H_sparse, alpha, 50, 1e-7);
[M1, ~] = greedy_match(S1);
[row, col] = find(M1 == 1);
res = [col row];
mapped_FINAL_num = intersect(res, groundtruth, 'rows');

%% run FINAL algorithm with categorical attributes
S2 = FINAL(ACM_sub, DBLP_sub, ACM_node_feature_cat, DBLP_node_feature_cat,...
    ACM_edge_feature_cat, DBLP_edge_feature_cat, H_sparse, alpha, 50, 1e-7);
[M2, ~] = greedy_match(S2);
[row, col] = find(M2 == 1);
res = [col row];
mapped_FINAL_cat = intersect(res, groundtruth, 'rows');

%% run IsoRank algorithm
S3 = IsoRank(ACM_sub, DBLP_sub, H_sparse, alpha, 50, 1e-7);
[M3, ~] = greedy_match(S3);
[row, col] = find(M3 == 1);
res = [col row];
mapped_IsoRank = intersect(res, groundtruth, 'rows');

%% run UniAlign algorithm
S4 = UniAlign(ACM_node_feature_sub, DBLP_node_feature_sub, 0.1);
[M4, ~] = greedy_match(S4);
[row, col] = find(M4 == 1);
res = [col row];
mapped_UniAlign = intersect(res, groundtruth, 'rows');
