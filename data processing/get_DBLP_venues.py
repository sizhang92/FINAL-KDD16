import re
import cPickle as pickle

def DBLP_author(file_path):
    venue = set()
    with open(file_path) as filelines:
        for line in filelines:
            info = line.replace('\n', '')
            if re.match('\#c', info):
                venue.add(info.replace('#c', ''))

    venue_KDD = check_KDD(venue)
    venue_ICDM = check_ICDM(venue)
    # venue_SDM = check_SDM(venue)
    venue_PKDD = check_PKDD(venue)
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
    #     venue_dict[v] = 'NIPS'
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


def check_KDD(venues):
    venue_KDD = []
    for v in venues:
        if 'SIGKDD' in v and 'Explorations' not in v:
            venue_KDD.append(v.lower())
        elif v == 'KDD':
            venue_KDD.append(v.lower())
    return venue_KDD

def check_ICDM(venues):
    venue_ICDM = [v.lower() for v in venues if v == 'ICDM']
    return venue_ICDM

def check_SDM(venues):
    venue_SDM = [v.lower() for v in venues if v == 'SDM']
    return venue_SDM

def check_PKDD(venues):
    venue_PKDD = [v.lower() for v in venues if 'PKDD' in v and '@' not in v]
    venue_PKDD.append('ecml')
    return venue_PKDD

def check_PAKDD(venues):
    p = re.compile('PAKDD\s?(\([0-9]\))?$')
    venue_PAKDD = [v.lower() for v in venues if p.match(v)]
    return venue_PAKDD

def check_NIPS(venues):
    venue_NIPS = [v.lower() for v in venues if v == 'NIPS']
    return venue_NIPS

def check_ICML(venues):
    p = re.compile('ICML\s?(\([0-9]\))?$')
    venue_ICML = [v.lower() for v in venues if p.match(v)]
    return venue_ICML

def check_AAAI(venues):
    venue_AAAI = [v.lower() for v in venues if v == 'AAAI']
    return venue_AAAI

def check_IJCAI(venues):
    p = re.compile('IJCAI\s?(\([0-9]\))?$')
    venue_IJCAI = [v.lower() for v in venues if p.match(v)]
    return venue_IJCAI

def check_UAI(venues):
    venue_UAI = [v.lower() for v in venues if v == 'UAI']
    return venue_UAI

def check_VLDB(venues):
    venue_VLDB = [v.lower() for v in venues if v == 'VLDB']
    return venue_VLDB

def check_SIGMOD(venues):
    venue_SIGMOD = [v.lower() for v in venues if v == 'SIGMOD Conference']
    return venue_SIGMOD

def check_ICDE(venues):
    venue_ICDE = [v.lower() for v in venues if v == 'ICDE']
    return  venue_ICDE

def check_ICDT(venues):
    venue_ICDT = [v.lower() for v in venues if v == 'ICDT']
    return venue_ICDT

def check_EDBT(venues):
    venue_EDBT = [v.lower() for v in venues if v == 'EDBT']
    return venue_EDBT

def check_PODS(venues):
    venue_PODS = [v.lower() for v in venues if v == 'PODS']
    return  venue_PODS

def check_SIGIR(venues):
    venue_SIGIR = [v.lower() for v in venues if v == 'SIGIR']
    return venue_SIGIR

def check_WWW(venues):
    p = re.compile('WWW\s?(\(.*track.*\))?$', re.IGNORECASE)
    venue_WWW = [v.lower() for v in venues if p.match(v)]
    return  venue_WWW

def check_ECIR(venues):
    venue_ECIR = [v.lower() for v in venues if v == 'ECIR']
    return venue_ECIR

def check_CIKM(venues):
    venue_CIKM = [v.lower() for v in venues if v == 'CIKM']
    return  venue_CIKM

if __name__ == '__main__':
    venue_selected, venue_dict = DBLP_author('dblp.txt')
    file1 = open('DBLP-venue-selected.txt', 'wb')
    for v in venue_selected:
        file1.write(v + '\n')
    with open('DBLP-venue-dict.p', 'wb') as fp:
        pickle.dump(venue_dict, fp)


