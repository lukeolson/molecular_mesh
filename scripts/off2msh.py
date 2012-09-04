import sys
from numpy import double, int

if __name__=="__main__":
    if len(sys.argv)!=3:
        print 'usage: off2msh.py name.off name.msh'
    else:
        offfile = sys.argv[1]
        mshfile = sys.argv[2]

    fin = open(offfile,'r')
    fout = open(mshfile,'w')

    fin.readline()
    s = fin.readline().split()
    nv = int(s[0])
    ne = int(s[1])

    fout.write('$MeshFormat\n2.2 0 8\n$EndMeshFormat\n')
    fout.write('$PhysicalNames\n1\n3 1 "Molecule"\n$EndPhysicalNames\n')

    fout.write('$Nodes\n%d\n'%nv)
    n = 1
    for line in fin:
        s = line.split()
        fout.write('%d  %0.8F  %0.8F  %0.8F\n'%(n,double(s[0]),double(s[1]),double(s[2])))
        n+=1
        if n>nv:
            break
    fout.write('$EndNodes\n')

    fout.write('$Elements\n%d\n'%ne)
    n = 1
    for line in fin:
        s = line.split()
        fout.write('%d 2 2 1 0 %s %s %s\n'%(n,int(s[1])+1,int(s[2])+1,int(s[3])+1))
        n+=1
        if n>ne:
            break
    fout.write('$EndElements\n')
