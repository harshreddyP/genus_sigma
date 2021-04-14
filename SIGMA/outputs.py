import struct
import math
def splitbinary(mylist,splitlen,changetodecimal,printlogornot):
    i = 0
    return_list = []
    return_string_list = []
    num_levels = (math.log((len(mylist))/(splitlen)+1))/(math.log(2))
    i = 0
    # print mylist
    while (i < (len(mylist))):
        if(changetodecimal == 0):
            # print  mylist[i: i+splitlen],"_",
            return_list.append(mylist[i: i+splitlen])
        else:
            # print struct.unpack('!f', mylist[i:(i+splitlen)].decode('hex'))[0] ,
            return_list.append(struct.unpack('!f', mylist[i:(i+splitlen)].decode('hex'))[0])
            return_string_list.append(mylist[i:(i+splitlen)])
        i = i+splitlen
    # print(return_list)
    if(printlogornot == 0):
        if(changetodecimal == 0):
            print "_".join(return_list)
            # print
        else:
            print " ".join(str(i) for i in return_list)
            # print " ".join(return_string_list)
            
    else:
        print
        printlistinbinary(return_list,num_levels)
    return return_list


def printlistinbinary(thislist,num_levels):
    levels = []
    # print "command list: "
    for i in range(int(num_levels)):
        levels.append([])
    for i in range(len(thislist)):
            if(i%16 == 15):
                levels[4].append(thislist[i])
            elif(i%8 == 7):
                levels[3].append(thislist[i])
            elif(i%4 == 3):
                levels[2].append(thislist[i])
            elif(i%2 == 1):
                levels[1].append(thislist[i])
            else:
                levels[0].append(thislist[i])
    for k in range(int(num_levels)):
        print " ".join(levels[k])


line_list = []
count = 0
with open("output_data.txt") as f_in:
    for line in f_in:
        
        if len(line.split()) == 0:
            continue
        else:
            line_list = line.split(", ")
            # if(line_list[1] != '00000000000000000000000000000000'):
            print
            print "time = " , line_list[0]

            #outputs
            print "output reduction network= ",
            for i in range(0,len(line_list[1])):
                if(line_list[1][i] == '1'):
                    # print(line_list[2][(i*8):(i*8+1*8)])
                    # print "output = " ,line_list[2]
                    print (struct.unpack('!f', line_list[2][(i*8):(i*8+1*8)].decode('hex'))[0]),
                    count = 0
                else: 
                    print '0.0',
                    count = count +1

            print

            #inputs
            # if(line_list[3] == '1'):
            #     print "input ",
            #     splitbinary(line_list[4],4)
                # print "dist out ", line_list[5]
            
            if(line_list[-1] == '1\r\n'):
                print "sel  of reduction network = "
                print line_list[10]
                print "add_en binary = " #, line_list[-2]
                printlistinbinary(line_list[-3],5)
                print "cmd log of reduction network = ",
                splitbinary(line_list[9],3,0,1)
                

            if(line_list[5] == '1'):    
                print "input to mult network = ",
                # print "len = ", len(line_list[-5]), 
                input_to_mat = []
                zeros = ['0','0','0','0']
                i = 0
                #bf16to fp32
                while i<len(line_list[6]):
                    input_to_mat.extend(line_list[6][i:i+4])
                    input_to_mat.extend(zeros)
                    i = i+4
                input_to_mat_string = "".join(input_to_mat)
                splitbinary(input_to_mat_string,8,1,0)
                print   
            if((line_list[-2] == '1')):
                print "output from mult network = ",
                splitbinary(line_list[-4],8,1,0)
                # print line_list[-2]
                # print line_list[-4]
            
                

            
                
            
            # if()
        count = 0
# if __name__ == "__main__":
#     splitbinary

