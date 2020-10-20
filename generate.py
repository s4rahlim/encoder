import random

def xor(a, b):
    if(a!=b):
        return 1
    else:
        return 0

def encoder(p):
    x = []
    z = []
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

            z.append(xor4)


            dr.append(d2)
            dc.append(d1)
            dl.append(d0)
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

    return x, z, dl, dc, dr

K = 6144
seed = 500

random.seed(seed)
p = [random.randint(1, 1) for _ in range(K)]
#p = [1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0]
pi = [-1 for _ in range(K)]

x = []
z = []
xp = []
zp = []
dl = []
dc = []
dr = []

# interleaver definition
f1 = 0
f2 = 0
if K == 6144:
    f1 = 263
    f2 = 480
elif K == 1056:
    f1 = 17
    f2 = 66
elif K == 16:
    f1 = 2
    f2 = 8

for i in range(K):
    pi_index = (f1 * i + f2 * i * i) % K
    pi[i] = p[pi_index]

# generate outputs for 1st level encoder
x, z, dl, dc, dr = encoder(p)
# generate outputs for interleaver-encoder subsystem
xi, zi, dli, dci, dri = encoder(pi)


with open("p.txt", "w") as f:
    for item in p:
        f.write("%s\n" % item)
with open("pi.txt", "w") as f:
    for item in pi:
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
#print("xi: ", xi)
#print("zi: ", zi)
#print("dl: ", dl)
#print("dc: ", dc)
#print("dr: ", dr)
