import sys
import itertools
from numpy import double, int, zeros
from xml.dom.minidom import parse

if __name__=='__main__':
    if len(sys.argv)!=2:
        print 'usage: xmlinspect.py test.xml'
    else:
        xmlfile = sys.argv[1]

    d = parse(xmlfile)

    nv = int(d.getElementsByTagName('vertices')[0].getAttribute('size'))
    ne = int(d.getElementsByTagName('cells')[0].getAttribute('size'))
    xyz = zeros((nv,3))
    tet = zeros((ne,4),dtype=int)

    for v in d.getElementsByTagName('vertex'):
        i = int(v.getAttribute('index'))
        x = double(v.getAttribute('x'))
        y = double(v.getAttribute('y'))
        z = double(v.getAttribute('z'))
        xyz[i,:] = [x,y,z]

    for e in d.getElementsByTagName('tetrahedron'):
        i = int(e.getAttribute('index'))
        v0 = int(e.getAttribute('v0'))
        v1 = int(e.getAttribute('v1'))
        v2 = int(e.getAttribute('v2'))
        v3 = int(e.getAttribute('v3'))
        tet[i,:] = [v0,v1,v2,v3]

    # get max y coord
    alle = tet.ravel()
    allx = xyz[alle,0]
    ally = xyz[alle,1]
    allz = xyz[alle,2]
    print 'xmax = %.17g'%allx.max()
    print 'xmin = %.17g'%allx.min()
    print 'ymax = %.17g'%ally.max()
    print 'ymin = %.17g'%ally.min()
    print 'zmax = %.17g'%allz.max()
    print 'zmin = %.17g'%allz.min()
