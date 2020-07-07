def naviveMatch(txt, pat):
    for index in range(len(txt)-len(pat)):
        isFound = True
        for patIndex in range(len(pat)):
            if txt[index+patIndex] == pat[patIndex]:
                continue
            else:
                isFound = False
                break

        if isFound:
            print("Pattern found at ", index)

def calcSPi(pat):
    spi_list = []

    spi_list.append(0)

    index = 1
    prev_sp = 0
    while index < len(pat):
        if pat[index] == pat[prev_sp]:
            prev_sp += 1
            spi_list.append(prev_sp)
            index += 1

        else:
            if prev_sp == 0:
                spi_list.append(0)
                index += 1
                    
            else:
                prev_sp = spi_list[prev_sp-1]
                
    return spi_list


def KMP(txt, pat, spi):

    txt_index = 0
    pat_index = 0
    
    while txt_index < len(txt):    

        if txt[txt_index] == pat[pat_index]:
            txt_index += 1
            pat_index += 1

        if pat_index == len(pat):
            print("Pattern found at ", txt_index - pat_index)
            pat_index = spi[pat_index-1]

        elif txt_index < len(txt) and txt[txt_index] != pat[pat_index]:
            if pat_index != 0:
                pat_index = spi[pat_index-1]
            else:
                txt_index += 1


        



    

text = 'abcabdabcabcabdbbacabcabdabcabdcab'
pattern = 'abcabdabcabd'

#print(calcSPi(pattern))
KMP(text, pattern, calcSPi(pattern))






















"""    
# practice 1
text = 'ATAGCAGAGGACT'
pattern = 'AG'


# practice 2
txt_file = open("Covid-19_genome.fa")
pat_file= open("GU280_gp11.fa")

text = ''
for line in txt_file:
    if line.startswith('>'):
        continue
    
    line = line.rstrip('\r\n')

    text += line

pattern = ''  
for line in pat_file:
    if line.startswith('>'):
        continue
    
    line = line.rstrip('\r\n')

    pattern += line
naviveMatch(text, pattern)

txt_file.close()
pat_file.close()
"""


