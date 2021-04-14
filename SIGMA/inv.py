import numpy as np

A = []

for j in range(5):#row iter
    row = []
    for i in range(16): #column iter
        if(j == 3):
            row.append(1.5)
        elif(j == 4):
            row.append(2)
        else:
            row.append(1)
        
        # elif(i == 3):
        #     row.append(2)
    A.append(row)

B = []
for i in range(2):#row iter
    row = []
    for j in range(16): #column iter
        # if((i == 0) or (i == 1)):
            row.append(1.0)
        # # elif(i == 2):
        #     row.append(1.5)
        # elif(i == 3):
        #     row.append(2.0)
    B.append(row)

numA = np.array(A).transpose()
# print np.shape(numA)
print "numA: \n" , numA
print

numB = np.array(B)
# print np.shape(numB)

print "numB : \n" , numB
print

numC = np.matmul(numB,numA)
# print np.shape(numC)

print "numC : \n" , numC
print
# print np.linalg.det(numA)
# print(A[0])
