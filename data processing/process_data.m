clear; clc;

% generate the whole network and attributes
ACM_node = importACMnode('ACM-node.txt');
ACM_node_feature = importACMnodeF('ACM-node.txt');
ACMedges = importACMedge('ACM-edge.txt');
ACMedge = ACMedges(:, 1:2);
ACM = spconvert([[ACMedge;fliplr(ACMedge)],ones(2*length(ACMedge),1)]);
ACM_edge_feature = cell(17, 1);

DBLP_node = importDBLPnode('DBLP-node.txt');
DBLP_node_feature = importDBLPnodeF('DBLP-node.txt');
DBLPedges = importDBLPedge('DBLP-edge.txt');
DBLPedge = DBLPedges(:, 1:2);
DBLP = spconvert([[DBLPedge;fliplr(DBLPedge)],ones(2*length(DBLPedge),1)]);
DBLP_edge_feature = cell(17, 1);
for i = 1: 17
    ACM_edge_feature{i}=spconvert([[ACMedge, ACMedges(:, i+2)];[fliplr(ACMedge),ACMedges(:,i+2)]]);
    DBLP_edge_feature{i}=spconvert([[DBLPedge, DBLPedges(:, i+2)];[fliplr(DBLPedge),DBLPedges(:,i+2)]]);
end

% generate the subnetworks
d1 = sum(ACM, 1); d2 = sum(DBLP, 1);
[~, id1] = sort(d1, 'descend');
[~, id2] = sort(d2, 'descend');
i1 = id1(1:10000); i2 = id2(1:10000);
A = ACM(i1, i1); B = DBLP(i2, i2);
dd1 = sum(A, 1); dd2 = sum(B, 1);
idx1 = i1(dd1 > 0)'; idx2 = i2(dd2 > 0)';
ACM_sub = ACM(idx1, idx1); DBLP_sub = DBLP(idx2, idx2);
n1 = size(ACM_sub, 1); n2 = size(DBLP_sub, 1);
P = speye(n2); idx = randperm(n2); P = P(idx, :);
[row, col] = find(P == 1);
idx22 = zeros(n2, 1);
for i = 1: n2
    idx22(row(i)) = idx2(i);
end
idx2 = idx22;

% generate groundtruth
ACM_names = cell(n1, 1); DBLP_names = cell(n2, 1);
ACM_node_sub = cell(n1, 2); DBLP_node_sub = cell(n2, 2);
for i = 1: n1
    ACM_names{i} = ACM_node{idx1(i), 2};
    ACM_node_sub{i, 1} = ACM_node{idx1(i), 1};
    ACM_node_sub{i, 2} = ACM_node{idx1(i), 2};
end

for i = 1: n2
    DBLP_names{i} = DBLP_node{idx2(i), 2};
    DBLP_node_sub{i, 1} = DBLP_node{idx2(i), 1};
    DBLP_node_sub{i, 2} = DBLP_node{idx2(i), 2};
end
[C,iA,iB] = intersect(ACM_names, DBLP_names, 'stable');
groundtruth = [iA, iB];

% generate attributes of subnetworks
ACM_node_feature_sub = ACM_node_feature(idx1, :);
DBLP_node_feature_sub = DBLP_node_feature(idx2, :);
ACM_edge_feature_sub = cell(17, 1); DBLP_edge_feature_sub = cell(17, 1);
[r1, c1] = find(ACM_sub == 1); [r2, c2] = find(DBLP_sub == 1);
v1 = sub2ind([n1, n1], r1, c1);
v2 = sub2ind([n2, n2], r2, c2);
for i = 1: 17
    ACM_edge_feature_sub{i} = spconvert(full([[r1, c1, ACM_edge_feature{i}(v1)]; [n1, n1, 0]]));
    DBLP_edge_feature_sub{i} = spconvert(full([[r2, c2, DBLP_edge_feature{i}(v2)]; [n2, n2, 0]]));
end

% generate node categorical attributes
ACM_node_feature_cat = zeros(n1, 1); DBLP_node_feature_cat = zeros(n2, 1);
temp1 = zeros(n1, 4); temp2 = zeros(n2, 4);
for i = 1: n1
    temp1(i, 1) = sum(ACM_node_feature_sub(i, 1:4));
    temp1(i, 2) = sum(ACM_node_feature_sub(i, 5:8));
    temp1(i, 3) = sum(ACM_node_feature_sub(i, 9:13));
    temp1(i, 4) = sum(ACM_node_feature_sub(i, 14:17));
    ii = find(temp1(i, :) == max(temp1(i, :)));
    ACM_node_feature_cat(i) = ii(1);
end

for i = 1: n2
    temp2(i, 1) = sum(DBLP_node_feature_sub(i, 1:4));
    temp2(i, 2) = sum(DBLP_node_feature_sub(i, 5:8));
    temp2(i, 3) = sum(DBLP_node_feature_sub(i, 9:13));
    temp2(i, 4) = sum(DBLP_node_feature_sub(i, 14:17));
    ii = find(temp2(i, :) == max(temp2(i, :)));
    DBLP_node_feature_cat(i) = ii(1);
end
ACM_node_feature_sub1 = zeros(n1, 4);
DBLP_node_feature_sub1 = zeros(n2, 4);
for i = 1: n1
    ACM_node_feature_sub1(i, ACM_node_feature_cat(i)) = 1;
end
for i = 1: n2
    DBLP_node_feature_sub1(i, DBLP_node_feature_cat(i)) = 1;
end
ACM_node_feature_cat = ACM_node_feature_sub1;
DBLP_node_feature_cat = DBLP_node_feature_sub1;

% generate edge categorical attributes
ACM_edge_DM = spconvert([n1, n1, 0]); ACM_edge_ML = spconvert([n1 n1 0]);
ACM_edge_DB = spconvert([n1 n1 0]); ACM_edge_IR = spconvert([n1 n1 0]);
DBLP_edge_DM = spconvert([n2 n2 0]); DBLP_edge_IR = spconvert([n2 n2 0]);
DBLP_edge_ML = spconvert([n2 n2 0]); DBLP_edge_DB = spconvert([n2 n2 0]);
for i = 1:4
    ACM_edge_DM = ACM_edge_DM + ACM_edge_feature_sub{i};
    DBLP_edge_DM = DBLP_edge_DM + DBLP_edge_feature_sub{i};
end
for i = 5: 8
    ACM_edge_ML = ACM_edge_ML + ACM_edge_feature_sub{i};
    DBLP_edge_ML = DBLP_edge_ML + DBLP_edge_feature_sub{i};
end
for i = 9:13
    ACM_edge_DB = ACM_edge_DB + ACM_edge_feature_sub{i};
    DBLP_edge_DB = DBLP_edge_DB + DBLP_edge_feature_sub{i};
end
for i = 14:17
    ACM_edge_IR = ACM_edge_IR + ACM_edge_feature_sub{i};
    DBLP_edge_IR = DBLP_edge_IR + DBLP_edge_feature_sub{i};
end
[r1, c1] = find(ACM_sub); [r2, c2] = find(DBLP_sub);
X = zeros(length(r1), 4); Y = zeros(length(r2), 4);
id1 = zeros(length(r1), 1); id2 = zeros(length(r2), 1);
for i = 1: length(r1)
    X(i, 1) = ACM_edge_DM(r1(i), c1(i));
    X(i, 2) = ACM_edge_ML(r1(i), c1(i));
    X(i, 3) = ACM_edge_DB(r1(i), c1(i));
    X(i, 4) = ACM_edge_IR(r1(i), c1(i));
    a = find(X(i, :) == max(X(i, :)));
    id1(i) = a(1);
end
for i = 1: length(r2)
    Y(i, 1) = DBLP_edge_DM(r2(i), c2(i));
    Y(i, 2) = DBLP_edge_ML(r2(i), c2(i));
    Y(i, 3) = DBLP_edge_DB(r2(i), c2(i));
    Y(i, 4) = DBLP_edge_IR(r2(i), c2(i));
    a = find(Y(i, :) == max(Y(i, :)));
    id2(i) = a(1);
end
ACM_edge_feature_cat = spconvert([[r1 c1 id1]; [n1 n1 0]]);
DBLP_edge_feature_cat = spconvert([[r2 c2 id2]; [n2 n2 0]]);
ACM_edge_feature_sub1 = cell(4, 1); DBLP_edge_feature_sub1 = cell(4, 1);
for i = 1: 4
    ACM_edge_feature_sub1{i} = ACM_edge_feature_cat;
    ACM_edge_feature_sub1{i}(ACM_edge_feature_sub1{i}~=i) = 0;
    ACM_edge_feature_sub1{i}(ACM_edge_feature_sub1{i}==i) = 1;
    DBLP_edge_feature_sub1{i} = DBLP_edge_feature_cat;
    DBLP_edge_feature_sub1{i}(DBLP_edge_feature_sub1{i}~=i) = 0;
    DBLP_edge_feature_sub1{i}(DBLP_edge_feature_sub1{i}==i) = 1;
end
ACM_edge_feature_cat = ACM_edge_feature_sub1; 
DBLP_edge_feature_cat = DBLP_edge_feature_sub1;

% compute the degree similarity
H = zeros(n2, n1); d1 = sum(ACM_sub, 1); d2 = sum(DBLP_sub, 1);
for i = 1: n2
    H(i, :) = abs(d2(i)-d1)./max(d2(i), d1);
end
idx = randsample(n2*n1, round(0.9996*n2*n1));
H = H./sum(sum(H)); H_sparse = H;
H_sparse(idx) = 0; id = sub2ind([n2,n1],groundtruth(:,2), groundtruth(:,1));
H_sparse(id) = H(id);

save('ACM-DBLP.mat', 'ACM','DBLP','ACM_node','DBLP_node','ACM_node_feature','DBLP_node_feature',...
    'ACM_edge_feature','DBLP_edge_feature','ACM_node_sub','DBLP_node_sub','ACM_node_feature_sub',...
    'DBLP_node_feature_sub','ACM_edge_feature_sub','DBLP_edge_feature_sub','idx1','idx2', 'ACM_sub',...
    'DBLP_sub', 'idx1', 'idx2', 'groundtruth', 'P', 'H_sparse', 'ACM_node_feature_cat', 'DBLP_node_feature_cat', ...
    'ACM_edge_feature_cat', 'DBLP_edge_feature_cat');
