import sys
import os

fname = sys.argv[1];
fin = open(fname,'r');

while True:
    line = fin.readline()
    if line[1:9] == 'Elements':
        nelmts = int(fin.readline().strip())
        break

print nelmts

name = fname[:-4]
newfname = "%s_%d.msh"%(name,nelmts)
print "copying %s to %s"%(fname,newfname)
os.system("cp %s %s"%(fname,newfname))

name += "_%d"%nelmts
print "running: python msh2xmlparts.py %s %s"%(newfname,name)
os.system("python msh2xmlparts.py %s %s"%(newfname,name))

print "running: python testxmlwithdolfin.py %s"%name
os.system("python testxmlwithdolfin.py %s"%name)

print "running: python prepforparaview.py %s"%name
os.system("python prepforparaview.py %s"%name)
