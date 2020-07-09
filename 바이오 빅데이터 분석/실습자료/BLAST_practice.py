blast_file = open('BALST_practice_result.txt')

#practice 1
best_hit_dic = {}
for line in blast_file:
    if line.startswith('#'):
        continue

    line = line.rstrip("\r\n")

    if len(line) == 0:
        continue
    
    temp = line.split()

    qName = temp[0]
    eValue = float(temp[-2])

    if qName not in best_hit_dic:
        best_hit_dic[qName] = eValue
    else:
        if best_hit_dic[qName] > eValue:
            best_hit_dic[qName] = eValue

    #practice 2
    if eValue < 1.0e-70:
        print(line)



print(best_hit_dic)
blast_file.close()
