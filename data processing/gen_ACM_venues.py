import re
import cPickle as pickle

def ACM_author(file_path):
    venue = set()
    with open(file_path) as filelines:
        for line in filelines:
            info = line.replace('\n', '')
            if re.match('\#c', info):
                venue.add(info.replace('#c', ''))

    venue_KDD = check_KDD(venue)
    venue_ICDM = check_ICDM(venue)
    # venue_SDM = check_SDM(venue)
    venue_PKDD = check_PKDD(venue) + check_ECML(venue)
    venue_PAKDD = check_PAKDD(venue)
    venue_ICML = check_ICML(venue)
    # venue_NIPS = check_NIPS(venue)
    venue_AAAI = check_AAAI(venue)
    venue_IJCAI = check_IJCAI(venue)
    venue_UAI = check_UAI(venue)
    venue_VLDB = check_VLDB(venue)
    venue_SIGMOD = check_SIGMOD(venue)
    venue_ICDE = check_ICDE(venue)
    venue_EDBT = check_EDBT(venue)
    venue_PODS = check_PODS(venue)
    venue_SIGIR = check_SIGIR(venue)
    venue_WWW = check_WWW(venue)
    venue_ECIR = check_ECIR(venue)
    venue_CIKM = check_CIKM(venue)

    venue_dict = {}
    for v in venue_KDD:
        venue_dict[v] = 'KDD'
    for v in venue_ICDM:
        venue_dict[v] = 'ICDM'
    # for v in venue_SDM:
    #     venue_dict[v] = 'SDM'
    for v in venue_PKDD:
        venue_dict[v] = 'PKDD'
    for v in venue_PAKDD:
        venue_dict[v] = 'PAKDD'
    for v in venue_ICML:
        venue_dict[v] = 'ICML'
    # for v in venue_NIPS:
        # venue_dict[v] = 'NIPS'
    for v in venue_AAAI:
        venue_dict[v] = 'AAAI'
    for v in venue_IJCAI:
        venue_dict[v] = 'IJCAI'
    for v in venue_UAI:
        venue_dict[v] = 'UAI'
    for v in venue_VLDB:
        venue_dict[v] = 'VLDB'
    for v in venue_SIGMOD:
        venue_dict[v] = 'SIGMOD'
    for v in venue_ICDE:
        venue_dict[v] = 'ICDE'
    for v in venue_EDBT:
        venue_dict[v] = 'EDBT'
    for v in venue_PODS:
        venue_dict[v] = 'PODS'
    for v in venue_SIGIR:
        venue_dict[v] = 'SIGIR'
    for v in venue_WWW:
        venue_dict[v] = 'WWW'
    for v in venue_ECIR:
        venue_dict[v] = 'ECIR'
    for v in venue_CIKM:
        venue_dict[v] = 'CIKM'



    venue_selected = set(venue_KDD+venue_ICDM+venue_PKDD+venue_PAKDD+venue_ICML+\
                         venue_AAAI+venue_IJCAI+venue_UAI+venue_VLDB+venue_SIGMOD+venue_ICDE\
                         +venue_EDBT+venue_PODS+venue_SIGIR+venue_WWW+venue_ECIR+venue_CIKM)

    return list(venue_selected), venue_dict


def check_KDD(venue):
    venue_KDD = []
    for v in venue:
        if 'tutorial' not in v.lower() and 'workshop' not in v.lower():
            if 'ACM SIGKDD international conference on Knowledge discovery'.lower() in v.lower():
                venue_KDD.append(v.lower())
            elif 'KDD ''99 Proceedings of the fifth ACM SIGKDD'.lower() in v.lower():
                venue_KDD.append(v.lower())

    return venue_KDD

def check_ICDM(venue):
    venue_ICDM = []
    for v in venue:
        if 'ICDM'.lower() in v.lower() and 'workshop' not in v.lower():
            if 'International Conference on Data Mining'.lower() in v.lower():
                venue_ICDM.append(v.lower())

    return venue_ICDM

def check_SDM(venue):
    venue_SDM = []
    for v in venue:
        if 'SIAM International Conference on Data Mining'.lower() in v.lower():
            venue_SDM.append(v.lower())
        elif 'SDM '''.lower() in v.lower():
            venue_SDM.append(v.lower())

    return venue_SDM

def check_PKDD(venue):
    venue_PKDD = []
    for v in venue:
        if 'Proceedings of'.lower() in v.lower() and 'European'.lower() in v.lower() and 'PKDD' in v and 'workshop' not in v.lower():
            venue_PKDD.append(v.lower())

    return venue_PKDD

def check_PAKDD(venue):
    venue_PAKDD = []
    for v in venue:
        if 'Proceedings of'.lower() in v.lower() and 'PAKDD' in v and 'workshop' not in v.lower():
            venue_PAKDD.append(v.lower())

    return venue_PAKDD

def check_NIPS(venue):
    venue_NIPS = []
    for v in venue:
        if 'Advances in neural information processing systems'.lower() in v.lower() and 'workshop' not in v.lower():
            venue_NIPS.append(v.lower())

    return venue_NIPS

def check_ICML(venue):
    venue_ICML = []
    for v in venue:
        if re.match('(.*)International Conference on Machine Learning$', v, re.IGNORECASE):
            venue_ICML.append(v.lower())
        elif re.match('(.*)International Conference on Machine Learning\:+', v, re.IGNORECASE):
            venue_ICML.append(v.lower())

    return venue_ICML

def check_AAAI(venue):
    venue_AAAI = []
    for v in venue:
        if 'AAAI' in v and 'proceedings of' in v.lower():
            venue_AAAI.append(v.lower())

    return venue_AAAI

def check_IJCAI(venue):
    venue_IJCAI = []
    for v in venue:
        if re.match('(.*)international joint conference on Artificial Intelligence(.*)', v, re.IGNORECASE):
            venue_IJCAI.append(v.lower())

    return venue_IJCAI

def check_UAI(venue):
    venue_UAI = []
    for v in venue:
        if re.match('(.*)Uncertainty in artificial intelligence(.*)', v, re.IGNORECASE):
            venue_UAI.append(v.lower())

    return venue_UAI

def check_ECML(venue):
    venue_ECML = []
    for v in venue:
        if 'European Conference on Machine Learning'.lower() in v.lower() and 'PKDD' not in v:
            venue_ECML.append(v.lower())

    return venue_ECML

def check_VLDB(venue):
    venue_VLDB = []
    for v in venue:
        if 'Very Large Data Bases'.lower() in v.lower() and 'workshop' not in v.lower() and 'comparative' not in v.lower() and 'conjunction' not in v.lower():
            venue_VLDB.append(v.lower())

    return venue_VLDB

def check_SIGMOD(venue):
    venue_SIGMOD = []
    for v in venue:
        if 'ACM SIGMOD'.lower() in v.lower() and 'international' in v.lower() and 'proceedings of' in v.lower():
            venue_SIGMOD.append(v.lower())
    return venue_SIGMOD

def check_ICDE(venue):
    venue_ICDE = []
    for v in venue:
        if re.match('International Conference on Data Engineering$', v, re.IGNORECASE):
            venue_ICDE.append(v.lower())
        elif 'ICDE' in v and 'workshop' not in v.lower():
            venue_ICDE.append(v.lower())
    return venue_ICDE

def check_ICDT(venue):
    venue_ICDT = []
    for v in venue:
        if 'workshop' not in v.lower():
            if 'EDBT/ICDT' in v or ('database theory' in v.lower() and 'international conference' in v.lower()):
                venue_ICDT.append(v.lower())
    return venue_ICDT

def check_EDBT(venue):
    venue_EDBT = []
    for v in venue:
        if 'workshop' not in v.lower() and 'EDBT' in v and 'Advances in Database Technology'.lower() in v.lower():
            venue_EDBT.append(v.lower())
    return venue_EDBT

def check_PODS(venue):
    venue_PODS = []
    for v in venue:
        if 'workshop' not in v.lower() and 'PODS' in v and 'database' in v.lower():
            venue_PODS.append(v.lower())
    return venue_PODS

def check_SIGIR(venue):
    venue_SIGIR = []
    for v in venue:
        if 'workshop' not in v.lower() and 'tutorial' not in v.lower() and 'sigir' in v.lower() and 'information retrieval' in v.lower():
            venue_SIGIR.append(v.lower())
    return venue_SIGIR

def check_WWW(venue):
    venue_WWW = []
    for v in venue:
        if 'workshop' not in v.lower():
            if 'International World Wide Web Conference'.lower() in v.lower() and 'network' not in v.lower():
                venue_WWW.append(v.lower())
            elif 'international conference on World Wide Web'.lower() in v.lower() and 'companion' not in v.lower() and 'proceedings' in v.lower():
                venue_WWW.append(v.lower())
    return venue_WWW


def check_ECIR(venue):
    venue_ECIR = []
    for v in venue:
        if 'workshop' not in v.lower() and 'ecir' in v.lower() and 'european conference' in v.lower():
            venue_ECIR.append(v.lower())
    return venue_ECIR


def check_CIKM(venue):
    venue_CIKM = []
    for v in venue:
        if 'workshop' not in v.lower() and 'conference on information and knowledge management' in v.lower() and 'selected' not in v.lower():
            venue_CIKM.append(v.lower())
    return venue_CIKM


if __name__ == '__main__':
    venue_selected, venue_dict = ACM_author('citation-acm-v8.txt')
    file1 = open('ACM-venue-selected.txt', 'wb')
    for v in venue_selected:
        file1.write(v + '\n')
    with open('ACM-venue-dict.p', 'wb') as fp:
        pickle.dump(venue_dict, fp)