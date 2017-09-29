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

## Usage
Please refer to the demo code file demo.m and the descriptions in each file for the detailed information

## Reference
Zhang, Si, and Hanghang Tong. "FINAL: Fast Attributed Network Alignment." Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining. ACM, 2016.
