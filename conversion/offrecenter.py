import sys
from numpy import double, int, zeros, array
from scipy import sqrt

if __name__=="__main__":
    if len(sys.argv)!=3:
        print 'usage: msh2off.py name.off name.off'
    else:
        offinfile = sys.argv[1]
        offoutfile = sys.argv[2]

    fin = open(offinfile,'r')
    fout = open(offoutfile,'w')
    s = fin.readline()

    s = fin.readline().split()
    nv = int(s[0])
    ne = int(s[1])
    xyz = zeros((nv,3))
    for n in range(0,nv):
        s = fin.readline().split()
        xyz[n,:] = [double(s[0]),double(s[1]),double(s[2])]

    ######
    # center of mass
    import numpy as np
    from scipy.linalg import norm
    mass = array([xyz[:,0].sum()/nv,xyz[:,1].sum()/nv,xyz[:,2].sum()/nv])
    uu,dd,vv = np.linalg.svd(xyz-mass)
    linepts = vv[0] * np.mgrid[-7:7:2j][:, np.newaxis]
    linepts += mass

    p = linepts - mass
    p = p[-1,:]/norm(p[-1,:])
    u = p[0]
    v = p[1]
    w = p[2]

    a = sqrt(u**2 + v**2)
    Txz = array([[u/a, v/a, 0],[-v/a, u/a, 0],[0,0,1]])
    b = sqrt(u**2 + v**2 + w**2)
    Tz = array([[w/b, 0, -a/b],[0,1,0],[a/b,0,w/b]])

    for n in range(0,nv):
        xyz[n,:] = Tz.dot(Txz.dot(xyz[n,:]-mass))

    zshift = (xyz[:,2].max() + xyz[:,2].min())/2.0

    xyz[:,2] -= zshift

    if 0:
        import matplotlib.pyplot as plt
        import mpl_toolkits.mplot3d as m3d
        ax = m3d.Axes3D(plt.figure())
        ax.scatter3D(*xyz.T)
        #ax.plot3D(*linepts.T)
        plt.show()

    fout.write('OFF\n')
    fout.write('%d %d\n'%(nv,ne))
    for i in range(0,nv):
        fout.write('%0.8F  %0.8F  %0.8F\n'%(xyz[i,0],xyz[i,1],xyz[i,2]))
    for i in range(0,ne):
        s = fin.readline()
        fout.write(s)

    # recenter pqr file too
    pin = open('1BNA.pqr','r')
    pout = open('1BNA_recenter.pqr','w')

    for n in range(0,7):
        s = pin.readline()
        pout.write(s)

    theend = False
    pts = zeros((3,))
    while not theend:
        s = pin.readline().split()
        if len(s)>1:
            pts[:] = [double(s[-5]),double(s[-4]),double(s[-3])]
            pts = Tz.dot(Txz.dot(pts-mass))
            pts *= 0.1
            tmpstr = '%s %s %s %s %s %0.8F %0.8F %0.8F %s %s\n' % (s[0],s[1],s[2],s[3],s[4],pts[0],pts[1],pts[2],s[-2],s[-1])
            pout.write(tmpstr)
        else:
            theend=True
    pout.write('TER\n')
    pout.write('END\n')
    pout.close()
    pin.close()
