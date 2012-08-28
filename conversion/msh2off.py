import sys
from numpy import double, int, zeros

if __name__=="__main__":
    if len(sys.argv)!=3:
        print 'usage: msh2off.py name.msh name.off'
    else:
        mshfile = sys.argv[1]
        offfile = sys.argv[2]

    fin = open(mshfile,'r')
    fout = open(offfile,'w')

    while True:
        if fin.readline().strip()=='$Nodes':
            break
    s = fin.readline()
    nv = int(s)
    xyz = zeros((nv,3))

    n=1
    while True:
        s = fin.readline().split()
        xyz[n-1,:] = [double(s[1]),double(s[2]),double(s[3])]
        n+=1
        if n>nv:
            break

    fin.readline() # $EndNodes
    fin.readline() # $Elements
    nemax = int(fin.readline()) # total of all elements

    el = zeros((nemax,4))
    n=0
    while True:
        s = fin.readline().split()
        if s[0]=='$EndElements':
            break
        if s[1]=='4':
            el[n,:] = [int(s[-4]),int(s[-3]),int(s[-2]),int(s[-1])]
            n+=1
    ne = n
    el = el[0:ne,:]
    
    fout.write('OFF\n')
    fout.write('%d %d\n'%(nv,ne))
    for i in range(0,nv):
        fout.write('%0.8F  %0.8F  %0.8F\n'%(xyz[i,0],xyz[i,1],xyz[i,2]))
    for i in range(0,ne):
        fout.write('4 %d %d %d %d\n'%(el[i,0]-1,el[i,1]-1,el[i,2]-1,el[i,3]-1))
