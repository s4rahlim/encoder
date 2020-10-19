import random

def xor(a, b):
    if(a!=b):
        return 1
    else:
        return 0

K = 40
seed = 50

random.seed(seed)
p = [random.randint(0, 1) for _ in range(K)]


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
        i = p[j]
        x.append(i)
        xor2 = xor(d1, d2)
        xor1 = xor(xor2, i)
        xor3 = xor(xor1, d0)
        xor4 = xor(xor3, d2)

        z.append(xor4)
        d2 = d1
        d1 = d0
        d0 = xor1
        dr.append(d2)
        dc.append(d1)
        dl.append(d0)
    else:
        xor2 = xor(d1, d2)
        i = xor2
        x.append(i)
        xor1 = xor(xor1, xor1) # should be 0
        xor3 = xor(xor1, d0)
        xor4 = xor(xor3, d2)
        z.append(xor4)
        d2 = d1
        d1 = d0
        d0 = xor1
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
#print("dl: ", dl)
#print("dc: ", dc)
#print("dr: ", dr)
