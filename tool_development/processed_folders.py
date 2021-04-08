#!/usr/bin/python
import csv

#this function is used to recover the list of folder that were not processed in case the marco c++ code fails in extracting the unmappend reads from the bam and stacks
# it reads the ls.txt file created running ls * in the folder where marco code stacks. The output file ls_to-be-processed.txt contains the folders to be still processed by marco program.
with open('ls.txt', 'r') as f:
    reader = csv.reader(f, dialect='excel', delimiter='\n')
    data = list(reader)
    data_len = len(data)
    #print(data_len)

with open('ls_to-be-processed.txt','w') as file:
    for i in range(len(data)):
        #    print(data[i])
        str2 = ':'
        myrow = str(data[i])
        myrow.find(str2)
        if myrow.find(str2) > -1:
            new_index = i + 4
            if new_index <= (len(data) - 1):
                non_processed = str(data[new_index])
                #          print(non_processed)
                non_processed_pos = non_processed.find('met.sam')
                #           print(non_processed_pos)
                if non_processed_pos == -1:
                    myrow = myrow[:(len(myrow) - 3)]
                    myrow = myrow[2:]
                    file.write(myrow)
                    file.write('\n')


#for row in data:
#    str2 = ':'
#    myrow = str(row)
#    myrow.find(str2)
#    if myrow.find(str2) > -1:
#        print(row + 1)
    
#str2 = ':';
#yesno = row.find(str2)
#print(yesno)
#        if row.find(str2) > -1:
#            print(row)


# Legge un file.
#in_file = open("/Users/raffaelecalogero/Desktop/ls.txt","r", delimiter="\n")
#text = in_file.read()
#in_file.close()

#for i in range(len(text)) :
    #if()


#new_path = '/Users/raffaelecalogero/Desktop/new_ls.txt'
#out_file = open(new_path,'w')



#out_file.write(text)

