%% two examples of final_NE
% Note that final_N and final_E can be modified correspondingly.
load('DBLP-CoAuthor.mat');
S1 = final_NE(A, B, H, node_label1, node_label2, edge_label1, edge_label2,...
            l_node, l_edge, alpha, 40, 1);
        
clear;

load('flickr-lastfm.mat')
S2 = final_NE(flickr, lastfm, H, flickr_gender_node_label, lastfm_gender_node_label, ...
            flickr_pagerank_edge_label, lastfm_pagerank_edge_label, l_node, l_edge, ...
            40, 0);

% To get the one-to-one mappings, we use greedy matching algorithm
[M1, ~] = greedy_match(S1);
[row, col] = find(M1 == 1);
accuracy1 = nnz(perm(row) == col')/length(perm);

[M2, ~] = greedy_match(S2);
[row, col] = find(M2 == 1);
res = [row, col];
accuracy2 = size(interset(res, gndtruth, 'rows'), 1)/size(gndtruth, 1);


%% one example of final on-query
clear;
load('flickr-lastfm.mat')
m = size(flickr, 1);
s = cross_query(flickr, lastfm, H, flickr_gender_node_label, lastfm_gender_node_label, ...
    l_node, alpha, r, 50, randsample(m, 1));
