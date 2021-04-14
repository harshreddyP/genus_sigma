import numpy as np
import struct
# a1 = input()
t1 = "0.75 0.75 0.75 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0"
a1 = [float(i) for i in t1.split(" ")]# a2 = input()
t2 = "1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5 1.5"
a2 = [float(i) for i in t2.split(" ")]
out = np.multiply(np.array(a1),np.array(a2))
print out

print(struct.unpack('!f',"3fc00000".decode('hex'))[0])