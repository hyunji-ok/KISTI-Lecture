class tableCell:
    def __init__(self):
        self.value = 0
        self.fromUp = False
        self.fromLeft = False
        self.fromDiagonal = False
        
def initDynaicTable(table):
    for rowIndex in range(len(table[0])):
        if rowIndex == 0:
            continue

        currentCell = table[0][rowIndex]
        leftCell = table[0][rowIndex-1]

        if leftCell.fromLeft == False:
            currentCell.value = leftCell.value-5
            currentCell.fromLeft = True
        else:
            currentCell.value = leftCell.value-2
            currentCell.fromLeft = True

    for colIndex in range(len(table)):
        if colIndex == 0:
            continue

        currentCell = table[colIndex][0]
        upCell = table[colIndex-1][0]

        if upCell.fromUp == False:
            currentCell.value = upCell.value-5
            currentCell.fromUp = True
        else:
            currentCell.value = upCell.value-2
            currentCell.fromUp = True

            
    return table

def dynamicProgramming(t1,t2):
    #match = 5, substitution = -3, gap = -3 -2x

    table = []
    for i in range(len(t2)+1):
        row = []
        for j in range(len(t1)+1):
            row.append(tableCell())
        table.append(row)

    #init table
    table = initDynaicTable(table)

    #Fill in table
    for rowIndex in range(1,len(table)):
        for colIndex in range(1,len(row)):
            #Calculate 3 value
            left_cell = table[rowIndex][colIndex-1]
            up_cell = table[rowIndex-1][colIndex]
            dig_cell = table[rowIndex-1][colIndex-1]

            if left_cell.fromLeft:
                from_Left_Value = left_cell.value -2
            else:
                from_Left_Value = left_cell.value -5
            
            if up_cell.fromUp:
                from_Up_Value = up_cell.value -2
            else:
                from_Up_Value = up_cell.value -5

            if t1[colIndex-1] == t2[rowIndex-1]:
                from_Dig_Value = dig_cell.value +5
            else:
                from_Dig_Value = dig_cell.value -3

            #Find max btw 3 value
            maxValue = max(from_Left_Value,from_Up_Value,from_Dig_Value)
            
            current_cell = table[rowIndex][colIndex]
            current_cell.value = maxValue
            
            #Find where from max value
            if from_Left_Value == maxValue:
                current_cell.fromLeft = True
            if from_Up_Value == maxValue:
                current_cell.fromUp = True
            if from_Dig_Value == maxValue:
                current_cell.fromDiagonal = True

    for rowIndex in range(len(table)):
        for colIndex in range(len(row)):
            
            print(table[rowIndex][colIndex].value, end=' ')
        print()

    #Backtracking
    t1_output = ''
    t2_output = ''
    
    t1_index = len(t1)-1
    t2_index = len(t2)-1
    
    while t1_index > -1 and t2_index > -1:
        if table[t2_index+1][t1_index+1].fromDiagonal == True:
            t1_output += t1[t1_index]
            t2_output += t2[t2_index]
            t1_index -= 1
            t2_index -= 1
        elif table[t2_index+1][t1_index+1].fromLeft == True:
            t1_output += '-'
            t2_output += t2[t2_index]
            t1_index -= 1
        elif table[t2_index+1][t1_index+1].fromUp == True:
            t1_output += t1[t1_index]
            t2_output += '-'
            t2_index -= 1
    print(t1_output[::-1])
    print(t2_output[::-1])
            
text1 = 'ATAGC'
text2 = 'ATATTGC'

dynamicProgramming(text1, text2)
