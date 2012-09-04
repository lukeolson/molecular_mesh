from dolfin import *
import sys
import os
import glob
if __name__=='__main__':
    meshnamestart=sys.argv[1]
    mol = meshnamestart + '_Molecule000000.vtu'
    mem = meshnamestart + '_Omega_m000000.vtu'
    sol = meshnamestart + '_Omega_s000000.vtu'

    os.system("cp %s Molecule.vtu"%mol)
    os.system("cp %s Omega_m.vtu"%mem)
    os.system("cp %s Omega_s.vtu"%sol)
