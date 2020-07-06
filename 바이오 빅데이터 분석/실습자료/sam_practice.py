class ReadMap:
    def __init__(self, read):
        temp = read.split()

        self.qname = temp[0]
        self.flag = bin(int(temp[1]))[2:].zfill(8)
        self.rname = temp[2]
        self.pos = int(temp[3])
        self.mapq = int(temp[4])
        self.cigar = temp[5]

        self.info = read
        


in_file = open("COVID19_SARS.sam")

position_1000_data = []
reverse_data = []
err_map = []
indel_data = []
for line in in_file:

    if line.startswith('@'):
        continue
    
    mapping = ReadMap(line)

#    if mapping.rname == '*':
    if mapping.flag[-3] == '1':
        continue


    # position 1-1000
    if 1 <= mapping.pos <= 1000:
        position_1000_data.append(mapping)

    # Reverse mapping
    if mapping.flag[-5] == '1':
        reverse_data.append(mapping)

    # 0.1% mapping error
    if mapping.mapq < 30:
        err_map.append(mapping)

    # Indel mapping
    if 'I' in mapping.cigar or 'D' in mapping.cigar :
        indel_data.append(mapping)


print 'position_1000_data: ',
print len(position_1000_data)
print 'reverse_data: ',
print len(reverse_data)
print 'err_map: ',
print len(err_map)
print 'indel_data: ',
print len(indel_data)




in_file.close()
