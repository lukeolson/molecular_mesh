import sys
import itertools
from numpy import double, int, zeros, vstack, unique, arange, ravel

if __name__=="__main__":
    scale = 0.1
    if len(sys.argv)!=3:
        print 'usage: msh2off.py name.msh name'
    else:
        mshfile = sys.argv[1]
        offfile = sys.argv[2]

    fin = open(mshfile,'r')

    phys = []
    physnames = []
    while True:
        s = fin.readline().strip()
        if s=='$PhysicalNames':
            nphys = int(fin.readline().strip())
            for i in range(nphys):
                 t, i, name = fin.readline().strip().split(' ',2)
                 if int(t)==3:
                     phys.append(int(i))
                     name=name.replace('\"','')
                     physnames.append(name)

        if s=='$Nodes':
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
    xyz *= scale

    fin.readline() # $EndNodes
    fin.readline() # $Elements
    nemax = int(fin.readline()) # total of all elements

    dat = {}
    cnt = {}
    for k in phys:
        dat[k]=zeros((nemax,4),dtype=int)
        cnt[k]=0

    while True:
        s = fin.readline().split()
        if s[0]=='$EndElements':
            break
        if int(s[1])==4:
            k = int(s[3])    # physical number
            dat[k][cnt[k],:] = [int(s[-4]),int(s[-3]),int(s[-2]),int(s[-1])]
            cnt[k]+=1

    for k in phys:
        dat[k] = dat[k][0:cnt[k],:]

    # what to print (every combo)
    a=zip(phys,physnames)
    meshes = itertools.chain.from_iterable(itertools.combinations(a,r) for r in range(1,len(phys)+1))

    val = 0
    #if 1:
    #    m = meshes.next()
    for m in meshes:
        val +=1
        s = ''
        idstr = ''

        totalne = 0
        for c in m:
            k=c[0]
            s += '_' + c[1]
            idstr += '%d' % k
            totalne += cnt[k]

        alldat=vstack(tuple([dat[c[0]] for c in m]))-1
        allverts = ravel(alldat).copy()
        allverts.sort()
        allverts=unique(allverts)
        vertlookup = zeros((nv,),dtype=int)
        for i in range(len(allverts)):
            vertlookup[allverts[i]]=i
        print totalne
        print alldat.shape
        print allverts.shape
        print xyz.shape
        print allverts.max()
        print allverts.min()
        allxyz = xyz[allverts,:]
        nvtmp = allxyz.shape[0]
        print allxyz.shape

        print '.....making [%s]  %s'%(idstr,s)
        fout = open(offfile+s+'.xml','w')
        fout.write('<dolfin xmlns=\"http://www.fenics.org/dolfin/\">\n')
        fout.write('<mesh celltype=\"tetrahedron\" dim=\"3\">\n')
        fout.write('<vertices size=\"%d\">\n'%nvtmp)

        for i in range(0,nvtmp):
            fout.write('<vertex index=\"%d\" x=\"%f\" y=\"%f\" z=\"%f\"/>\n'%(i,allxyz[i,0],allxyz[i,1],allxyz[i,2]))

        fout.write('</vertices>\n')

        fout.write('<cells size=\"%d\">\n'%totalne)

        for ii in range(totalne):
            newids = vertlookup[alldat[ii,:]]
            fout.write('<tetrahedron index=\"%d\" v0=\"%d\" v1=\"%d\" v2=\"%d\" v3=\"%d"/>\n'%(ii,newids[0],newids[1],newids[2],newids[3]))

        fout.write('</cells>\n')
        fout.write('<data>\n')
        fout.write('<data_entry name=\"material indicators\">\n')
        fout.write('<mesh_function type=\"uint\" size=\"%d\" dim=\"3\">\n'%totalne)

        for c in m:
            k = c[0]
            for i in range(0,cnt[k]):
                fout.write('<entity index=\"%d\" value=\"%d\"/>\n'%(i,k))

        fout.write('</mesh_function>\n')
        fout.write('</data_entry>\n')
        fout.write('</data>\n')
        fout.write('</mesh>\n')
        fout.write('</dolfin>\n')
        fout.close()
