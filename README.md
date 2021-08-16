# FINAL: Fast Attributed Network Alignment
## Overview
The package contains the following files:
- FINAL.m: attributed network alignment algorithm on networks with categorical/numerical attributes on nodes and/or edges or none
- greedy_match.m: greedy matching algorithm to get the one-to-one mappings based on the alignment matrix
- run_ACM_DBLP.m: demo code to run on ACM-DBLP networks
- run_Douban.m: demo code to run on Douban online-offline networks
- run_flickr_lastfm.m: demo code to run on Flickr-Lastfm networks
- run_flickr_myspace.m: demo code to run on Flickr-Myspace networks
- run_foursquare_twitter.m: demo code to run on Foursquare-Twitter networks

## Use with training data
FINAL can be easily extend to the semi-supervised setting by constructing the prior matrix H based on the prior labeled node alignment. For example, if we know node-i in G1 is aligned with node-j in G2 a priori, we can set H(j,:)=H(:,i)=0 except H(j,i)=1. Note that in the code, H is an n2-by-n1 matrix.

### Semi-Supervised Alignment Examples with 20% training data (i.e., anchor links)
- Foursquare-Twitter: run_foursquare_twitter.m
- ACM-DBLP: run_ACM_DBLP.m

## Use without training data
In the unsupervised setting, one can leverage the prior alignment matrix if provided. If the prior alignment matrix H is not given, one can manually construct by some similarity measure heuristics. Options include: (1) node attribute based similarity matrix (e.g., cosine similarity), (2) degree-based similarity matrix, etc. In addition, one can also filter out some small values of the full matrix computed by setting some threshold.

### Unsupervised Alignment Examples
- Douban online-offline: run_Douban.m
- Flickr-Lastfm: run_flickr_lastfm.m
- Flickr-Myspace: run_flickr_myspace.m

## Reference
- Zhang, Si, and Hanghang Tong. "FINAL: Fast Attributed Network Alignment." Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining. ACM, 2016.

- Zhang, Si, and Hanghang Tong. "Attributed network alignment: Problem definitions and fast solutions." IEEE Transactions on Knowledge and Data Engineering 31.9 (2018): 1680-1692.
