from dolfin import *
import sys
import glob
if __name__=='__main__':
    meshnamestart=sys.argv[1]
    fs = glob.glob(meshnamestart+'*.xml')
    for meshname in fs:
        pvdname = meshname[:-4]
        print meshname
        print pvdname
        mesh = Mesh(meshname)
        out = File(pvdname+'.pvd')
        out << mesh

    #subd = MeshFunction('uint',mesh,'%s_physical_region.xml'%meshname)
    #subd = MeshFunction(mesh)
    #out << subd
