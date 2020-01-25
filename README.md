# FINAL: Fast Attributed Network Alignment
## Overview
The package contains the following files:
- FINAL.m: attributed network alignment algorithm on networks with categorical/numerical attributes on nodes and/or edges or none
- FINAL_Nlow.m: fast low-rank approximation attributed network alignment on networks with categorical/numerical node attributes
- cross_query.m: FINAL on-query algorithm to compute the similarity vector between a query node in network G1 and all the nodes in G2
- greedy_match.m: greedy matching algorithm to get the one-to-one mappings based on the alignment matrix
- IsoRank.m: IsoRank algorithm based on matrix computation
- UniAlign.m: a variant alignment algorithm of BigAlign on unipartite networks
- demo.m: a demo code file 

## Use with training data
FINAL can be easily extend to the semi-supervised setting by constructing the prior matrix H based on the prior labeled node alignment. For example, if we know node-i in G1 is aligned with node-j in G2 a priori, we can set H(j,:)=H(:,i)=0 except H(j,i)=1. Note that in the code, H is an n2-by-n1 matrix.

## Usage
Please refer to the demo code file demo.m and the descriptions in each file for the detailed information. The code can be only used for academic purpose and please kindly cite our published paper.

## Reference
Zhang, Si, and Hanghang Tong. "FINAL: Fast Attributed Network Alignment." Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining. ACM, 2016.
