import sys
from numpy import double, int, zeros

if __name__=="__main__":
    if len(sys.argv)!=3:
        print 'usage: msh2off.py name.msh name.off'
    else:
        rawfile = sys.argv[1]
        offfile = sys.argv[2]

    fin = open(rawfile,'r')
    fout = open(offfile,'w')

    fout.write('OFF\n')
    s = fin.readline().split()
    nv = int(s[0])
    ne = int(s[1])
    fout.write('%d %d\n'%(nv,ne))
    for i in range(0,nv):
        s = fin.readline()
        fout.write('%s'%(s))
    for i in range(0,ne):
        s = fin.readline()
        fout.write('4 %s'%(s))
