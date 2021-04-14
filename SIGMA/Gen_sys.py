# for i in range(1,17):
#     print "input [DATA_WIDTH-1:0] in" + str(i) + ","

# print
# for i in range(1,17):
#     print "output [DATA_WIDTH-1:0] out" + str(i) + ","

# for j in range(1,5):
#     for i in range(1,5):
#         print "pe #(.DATA_WIDTH(DATA_WIDTH))"
#         print " pe"+str(i)+str(j)
#         print "(    .reset_accumulator(reset),"
#         print "     .clk(clk),"
#         print "     .input_top(in1),"
#         print "     .input_left(in3),"
#         print "     .output_accumulator(out"+str((j+(i-1)*4))+"),"
#         print "     .output_bottom(penet[1]),"
#         print "     .output_right(penet[0])"
#         print ");"

# for i in range(1,17):
#     # print ".in"+str(i)+"(in"+str(i)+"),"
#     print ".out"+str(i)+"(out"+str(i)+"),"

with open("sracthpad.txt") as f_in:
    for line in f_in:
        # print "line = ", line.split()
        for value in line.split():
            if(value != " "):
                print hex(int(value)),

print
with open("scratchpad2.txt") as f_in:
    for line in f_in:
        # print "line = ", line.split()
        for value in line.split():
            if(value != " "):
                print hex(int(value)),                