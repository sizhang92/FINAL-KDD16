
ACM_nodes = open('ACM-node.txt')
DBLP_nodes = open('DBLP-node.txt')
ACM_node_dict = {}
DBLP_node_dict = {}

for node in ACM_nodes:
    idx, n = node.replace('\n', '').split()[0:2]
    ACM_node_dict[n] = idx

for node in DBLP_nodes:
    idx, n = node.replace('\n', '').split()[0:2]
    DBLP_node_dict[n] = idx

common_set = set.intersection(set(ACM_node_dict.keys()), set(DBLP_node_dict.keys()))
common_idx = [(ACM_node_dict[idx], DBLP_node_dict[idx]) for idx in common_set]

file_out = open('ground-truth.txt', 'wb')
file_out.write('ACM DBLP\n')
for idx in common_idx:
    file_out.write(str(idx[0])+' '+str(idx[1])+'\n')

