from dolfin import *
import sys
if __name__=='__main__':
    if len(sys.argv)>1:
        meshname=sys.argv[1]
        mesh = Mesh('%s.xml'%meshname)
        out = File('%s.pvd'%meshname)
        out << mesh
    else:
        for meshname in ('ichannelps__Molecule',
                         'ichannelps__Omega_s',
                         'ichannelps__Omega_m',
                         'ichannelps__Molecule_Omega_s',
                         'ichannelps__Molecule_Omega_m',
                         'ichannelps__Omega_s_Omega_m',
                         'ichannelps__Molecule_Omega_s_Omega_m'):
            print meshname
            mesh = Mesh('%s.xml'%meshname)
            out = File('%s.pvd'%meshname)
            out << mesh

    #subd = MeshFunction('uint',mesh,'%s_physical_region.xml'%meshname)
    #subd = MeshFunction(mesh)
    #out << subd
