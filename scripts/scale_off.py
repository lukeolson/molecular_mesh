# scale_off.py in.off out.off
# this does one thing: scales the xyz coords of a off file
#
import sys
import numpy as np
import scipy as sp
from scipy.linalg import norm

scalefactor = 0.1

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "scale_off.py in.off out.off"
    else:
        infile = sys.argv[1]
        outfile = sys.argv[2]

    fin = open(infile,'r')
    fout = open(outfile,'w')

    # OFF line
    line = fin.readline()
    fout.write(line)

    # nv nelmt nedges
    line = fin.readline()
    fout.write(line)
    s = line.split()
    nv = int(s[0])
    nelmt = int(s[1])
    nedge = int(s[2])

    for i in range(nv):
        line = fin.readline()
        s = line.split()
        x = scalefactor * np.double(s[0])
        y = scalefactor * np.double(s[1])
        z = scalefactor * np.double(s[2])
        fout.write('%10.10e %10.10e %10.10e\n'%(x,y,z))

    for i in range(nelmt):
        line = fin.readline()
        fout.write(line)

    fin.close()
    fout.close()
