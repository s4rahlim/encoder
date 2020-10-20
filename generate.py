import random

def xor(a, b):
    if(a!=b):
        return 1
    else:
        return 0

K = 16
seed = 500

random.seed(seed)
p = [random.randint(1, 1) for _ in range(K)]


x = []
z = []
xp = []
zp = []
dl = []
dc = []
dr = []

d0 = 0
d1 = 0
d2 = 0
for j in range(K+3):
    if(j < K):
        if(j != 0):
              d2 = d1
              d1 = d0
              d0 = xor1
        i = p[j]
        
        x.append(i)
        xor2 = xor(d1, d2)
        xor1 = xor(xor2, i)
        xor3 = xor(xor1, d0)
        xor4 = xor(xor3, d2)
        print("xor2: ", xor2, "xor1: ", xor1, "xor3: ", xor3, "xor4: ", xor4)
	
        z.append(xor4)
        
        
        dr.append(d2)
        dc.append(d1)
        dl.append(d0)
        print("inp: ", i)
        print("d0: ", d0, " d1: ", d1, "d2: ", d2)
    else:
        d2 = d1
        d1 = d0
        d0 = xor1
        
        xor2 = xor(d1, d2)
        i = 0
        x.append(i)
        xor1 = xor(xor1, xor1) # should be 0
        xor3 = xor(xor1, d0)
        xor4 = xor(xor3, d2)
        z.append(xor4)
        
        dr.append(d2)
        dc.append(d1)
        dl.append(d0)

with open("inp.txt", "w") as f:
    for item in p:
        f.write("%s\n" % item)

with open("x.txt", "w") as f:
    for item in x:
        f.write("%s\n" % item)

with open("z.txt", "w") as f:
    for item in z:
        f.write("%s\n" % item)

#print("inp: ", p)
#print("x: ", x)
#print("z: ", z)
#print("xp: ", xp)
#print("zp: ", zp)
print("dl: ", dl)
print("dc: ", dc)
print("dr: ", dr)
