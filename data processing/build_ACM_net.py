import re, itertools
import cPickle as pickle
import numpy as np

def extract_papers(venue_path, acm_path):
    p1 = re.compile('\#\*(.*)\n')
    p2 = re.compile('\#\@(.*)\n')
    p3 = re.compile('\#c(.*)\n')
    with open(venue_path, 'rb') as fp:
        venue_dict = pickle.load(fp)
    papers, paper_authors = {}, []
    paper_title, paper_venue = '', ''

    with open(acm_path) as lines:
        for line in lines:
            if len(line.replace('\n', '')) == 0 and paper_venue in venue_dict:
                papers[paper_title] = (paper_authors, venue_dict[paper_venue])
            else:
                if p1.search(line):
                    paper_title = p1.search(line).group(1).lower()
                elif p2.search(line):
                    paper_authors = p2.search(line).group(1).lower()
                    cc = [author.strip() for author in paper_authors.split(',')]
                    cc_new = []
                    ii = 0
                    while ii < len(cc):
                        if ii == 0 and cc[ii] == 'jr.':
                            cc_new.append(' '.join(cc[ii+1::-1]))
                            ii += 1
                        elif ii > 0 and cc[ii] == 'jr.':
                            cc_new.append(' '.join(cc[ii-1:ii+1]))
                        elif ii > 0 and cc[ii] != 'jr.' and cc[min(ii+1, len(cc)-1)] != 'jr.':
                            cc_new.append(cc[ii])
                        ii += 1
                    paper_authors = [re.sub('00\d+', '', c).strip() for c in cc_new]
                elif p3.search(line):
                    paper_venue = p3.search(line).group(1).lower()

    return papers


def extract_nodes_and_edges(papers, venues):
    author_dict = {}    # e.g., (idx, name, #of papers in venues)
    edge_dict = {}      # e.g., (idx1, idx2, # of papers for the venue where they published paper)
    venue_num = {}
    for i in range(0, len(venues)):
        venue_num[venues[i]] = i
    count = 1
    for item in papers.values():
        authors, venue = item
        for author in authors:
            if author not in author_dict:
                node_feature = np.zeros((len(venues), ), dtype=np.int)
                node_feature[venue_num[venue]] = 1
                author_dict[author] = (count, ','.join(author.split()), node_feature)
                count += 1
            else:
                author_dict[author][2][venue_num[venue]] += 1

        author_comb1 = [(author_dict[aut[0]][0], author_dict[aut[1]][0]) for aut in itertools.combinations(authors, 2)]
        author_comb = []
        for comb in author_comb1:
            if comb[0] > comb[1]:
                author_comb.append((comb[1], comb[0]))
            elif comb[0] < comb[1]:
                author_comb.append(comb)

        for edge in author_comb:
            if edge not in edge_dict:
                edge_feature = np.zeros((len(venues)), dtype=np.int)
                edge_feature[venue_num[venue]] += 1
                edge_dict[edge] = (edge[0], edge[1], edge_feature)
            else:
                edge_dict[edge][2][venue_num[venue]] += 1

    return author_dict, edge_dict




if __name__ == '__main__':
    venue_path = 'ACM-venue-dict.p'
    acm_path = 'citation-acm-v8.txt'
    venues = ['KDD','ICDM','PKDD','PAKDD','ICML','AAAI','IJCAI','UAI', \
              'VLDB','SIGMOD','ICDE','EDBT','PODS','SIGIR','WWW','ECIR','CIKM']
    papers = extract_papers(venue_path, acm_path)
    author_dict, edge_dict = extract_nodes_and_edges(papers, venues)
    sorted_node = sorted(author_dict.items(), key=lambda i: i[1][0], reverse=False)
    sorted_edge = sorted(edge_dict.items(), key=lambda i: i[1][0], reverse=False)

    node_file = open('ACM-node.txt', 'wb')
    for node in sorted_node:
        node_file.write(str(node[1][0]) + ' ' + str(node[1][1]) + ' ' + ' '.join([str(a) for a in node[1][2]]) + '\n')
    edge_file = open('ACM-edge.txt', 'wb')
    for edge in sorted_edge:
        edge_file.write(str(edge[1][0]) + ' ' + str(edge[1][1]) + ' ' + ' '.join([str(a) for a in edge[1][2]]) + '\n')
