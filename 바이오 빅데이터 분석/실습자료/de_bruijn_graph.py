
def make_kmer(read, k_len):
    return_list = []

    for i in range(len(read) - k_len + 1):
        return_list.append(read[i:i+k_len])

    return return_list
    
def build_de_bruijn_graph(kmers):
    nodes = list(set(kmers))
    edges = []
    for node in nodes:
        for kmer in nodes:
            if node[1:] == kmer[:-1]:
                edges.append((node, kmer))
    
    return nodes, edges

reads = ['HAPPI', 'INESS', 'HAPPI', 'INESS','HAPPI', 'INESS','APLIN', 'PINET']
k = 3

kmer_list = []
for r in reads:
    kmer_list += make_kmer(r, k)

#print(kmer_list)

graph_nodes, graph_edges = build_de_bruijn_graph(kmer_list)
print(graph_nodes)
print(graph_edges)
