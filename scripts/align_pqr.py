# align_pqr.py in.pqr out.pqr
# this does two things:
#   1. recenters on the center of mass
#   2. rotates about a least-squares fitted line
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

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "align_pqr.py in.pqr out.pqr"
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
            frontstr.append(line)
        elif line[:3] == 'END':
            frontstr.append(line)
            break
        else:
            frontstr.append(line[:30]) # columns 1-30
            s = line[30:54].split() # columns 31-54
            x.append(np.double(s[0]))
            y.append(np.double(s[1]))
            z.append(np.double(s[2]))
            backstr.append(line[54:]) #columns 55++
        line = fin.readline()
    fin.close()
    x = np.array(x)
    y = np.array(y)
    z = np.array(z)
    nv = len(x)

    # center of mass
    mass = np.array([x.sum(),y.sum(),z.sum()])/nv

    # line through the middle
    uu,dd,vv = np.linalg.svd(np.vstack((x,y,z)).T-mass)
    linepts = vv[0] * np.mgrid[-7:7:2j][:, np.newaxis]
    linepts += mass

    # plot two double check
    if 0:
        import matplotlib.pyplot as plt
        import mpl_toolkits.mplot3d as m3d
        ax = m3d.Axes3D(plt.figure())
        ax.scatter3D(xs=x,ys=y,zs=z)
        ax.hold(True)
        ax.plot(linepts[:,0],linepts[:,1],linepts[:,2],'r-',linewidth=4)
        ax.set_aspect('equal')
        plt.show()

    # shift
    x -= mass[0]
    y -= mass[1]
    z -= mass[2]

    # now rotate
    p = linepts[-1,:] - mass
    P = p/norm(p)
    u = p[0]
    v = p[1]
    w = p[2]
    a = np.sqrt(u**2 + v**2)
    Txz = np.array([[u/a, v/a, 0],[-v/a, u/a, 0],[0,0,1]])
    b = np.sqrt(u**2 + v**2 + w**2)
    Tz = np.array([[w/b, 0, -a/b],[0,1,0],[a/b,0,w/b]])

    for i in range(0,nv):
        xyz = np.array([x[i], y[i], z[i]])
        xyz = Tz.dot(Txz.dot(xyz))
        x[i] = xyz[0]
        y[i] = xyz[1]
        z[i] = xyz[2]

    zshift = (z.max() + z.min())/2.0
    z -= zshift
    
    # plot two double check
    if 0:
        import matplotlib.pyplot as plt
        import mpl_toolkits.mplot3d as m3d
        ax = m3d.Axes3D(plt.figure())
        ax.scatter3D(xs=x,ys=y,zs=z)
        ax.hold(True)
        zax = np.array([[0,0,z.min()],[0,0,z.max()]])
        ax.plot(zax[:,0],zax[:,1],zax[:,2],'r-',linewidth=4)
        ax.set_aspect('equal')
        plt.show()

    i = 0
    j = 0
    while True:
        if frontstr[i][:3] == 'TER':
            fout.write(frontstr[i])
            i += 1
        elif frontstr[i][:3] == 'END':
            fout.write(frontstr[i])
            i += 1
            break
        else:
            fout.write(frontstr[i])
            fout.write('%-8.3F%-8.3F%-8.3F'%(x[j],y[j],z[j]))
            fout.write(backstr[j])
            i += 1
            j += 1
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
