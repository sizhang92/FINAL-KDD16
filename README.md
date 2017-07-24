# FINAL: Fast Attributed Network Alignment
## Overview
The package contains the following files:
- final_NE.m: attributed network alignment algorithm on networks with both node and edge attributes available
- final_N.m: attributed network alignment algorithm on networks with only node attributes available
- final_E.m: attributed network alignment algorithm on networks with only edge attributes available
- finalN_low.m: fast full attributed network alignment on networks with node attributes available
- cross_query.m: FINAL on-query algorithm to compute the similarity vector between a query node in network G1 and all the nodes in G2
- greedy_match.m: greedy matching algorithm to get the one-to-one mappings based on the similarity matrix returned by FINAL
- run.m: a demo code file 

## Usage
Please refer to the demo code file run.m and the comments in each file for the detailed information

## Reference
Si Zhang, Hanghang Tong. FINAL: Fast Attributed Network Alignment. 22nd ACM SIGKDD Conference on Knowledge Discovery and Data Mining (KDD), 2016. (Oral Presentation)
