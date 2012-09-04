# scale_pqr.py in.pqr out.pqr
# this does one thing: scales the xyz coords of a pqr file
#
# this will also only change the columns 31-54 as (x,y,z) below:
#                               123456781234567812345678
#                               xxxxxxxxyyyyyyyyzzzzzzzz
#          1         2         3         4         5         6         7
# 1234567890123456789012345678901234567890123456789012345678901234567890
# ATOM      1  O5' DC      1      18.935  34.195  25.617 -0.6600 1.7700
# 
import sys
import numpy as np
import scipy as sp
from scipy.linalg import norm

scalefactor = 0.1

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "scale_pqr.py in.pqr out.pqr"
    else:
        infile = sys.argv[1]
        outfile = sys.argv[2]

    fin = open(infile,'r')
    fout = open(outfile,'w')

    # first read the REMARK lines
    while True:
        line = fin.readline()
        if line[:6] == 'REMARK':
            fout.write(line)
        else:
            break

    frontstr = []
    x = []
    y = []
    z = []
    backstr = []

    # now read in everything else, but cache it in [frontstr, x, y, z, backstr]
    # to preserve spacing
    while True:
        if line[:3] == 'TER':
            fout.write(line)
        elif line[:3] == 'END':
            fout.write(line)
            break
        else:
            fout.write(line[:30]) # columns 1-30
            s = line[30:54].split() # columns 31-54
            x = scalefactor * np.double(s[0])
            y = scalefactor * np.double(s[1])
            z = scalefactor * np.double(s[2])
            fout.write('%-8.3F%-8.3F%-8.3F'%(x,y,z))
            fout.write(line[54:]) #columns 55++
        line = fin.readline()
    fin.close()
    fout.close()

    # check charge
    for f in [infile,outfile]:
        fin = open(f,'r')
        while True:
            line = fin.readline()
            if line[:6] == 'REMARK':
                pass
            else:
                break
        charge = 0.0
        while True:
            if line[:3] == 'TER':
                pass
            elif line[:3] == 'END':
                break
            else:
                charge += np.double(line.split()[-2])
            line = fin.readline()
        fin.close()
        print "File %s has total charge %10.10F"%(f,charge)
