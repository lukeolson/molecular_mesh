from dolfin import *
mesh = Mesh('twodomain.xml')
#subd = MeshFunction('uint',mesh,'twodomain_physical_region.xml')
subd = MeshFunction('uint',mesh,'twodomain_physical_region.xml')
out = File('test.pvd')
out << subd
