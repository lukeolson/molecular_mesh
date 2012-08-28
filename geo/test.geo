Mesh.Algorithm3D = 4;

// Generate a mesh for a box which is periodic in x and y
// Parameters used when reading the mesh later
periodicBoundaryBaseNo=80;
periodicInX=0;
periodicInY=2;
periodicInZ=4;

// pitch
p = 1.0;
// lc mesh (bulk) parameter
lcm = 0.2;
// cell thickness
d = 1.5;

Point (1) = {0, 0, 0, lcm};
Point (2) = {p, 0, 0, lcm};
Point (3) = {p, 0, d, lcm};
Point (4) = {0, 0, d, lcm};

Line (1) = {1,2};
Line (2) = {2,3};
Line (3) = {3,4};
Line (4) = {4,1};
Line Loop (newll) = {1, 2, 3, 4};
surfy0 = news; Plane Surface (news) = {newll-1};

out[]=Extrude {0,p,0} {
    Surface{surfy0}; Layers{1};
};
surfy1 = out[0];

For kk In {0:#out[]-1}
  Printf("Y out[%g] = %g", kk, out[kk]);
EndFor

// Delete unwanted entities - leaving the two surfaces periodic in Y and lines 
// in the YoZ plane, which will now be used to form a new Plane Surface to be
// extruded.

Printf("%g", surfy0);
Printf("%g", surfy1);
bnd2[] = Boundary {Surface{out[#out[]-1]};}; //X
bnd3[] = Boundary {Surface{out[2]};}; //Z0

For kk In {0:#bnd2[]-1}
  Printf("Y bnd2[%g] = %g", kk, bnd2[kk]);
EndFor
For kk In {0:#bnd3[]-1}
  Printf("Y bnd3[%g] = %g", kk, bnd3[kk]);
EndFor

Delete{
   Volume{out[1]};
    Surface{ out[{2:#out[]-1}] };
 }
 
 Line Loop(newll) = {bnd3[]};
 surfz0 = news ; Plane Surface(news) ={newll-1};
 out[]= Translate {0,0,d} {
 Duplicata{ Surface{surfz0}; }  
 };
 surfz1 = out[0];
 
Periodic Surface surfz1 { Boundary{Surface{out[0]};} } = surfz0 { bnd3[] } ;
 
// Form the new Plane Surface and extrude it in the X direction.
Line Loop(newll) = {bnd2[]};
surfx0 = news ; Plane Surface(news) ={newll-1};

out[]= Translate {p,0,0} {
  Duplicata{ Surface{surfx0}; }  
};
surfx1 = out[0] ;
Periodic Surface surfx1 { Boundary{Surface{out[0]};} } = 
                 surfx0 { bnd2[] };

Surface Loop(newsl) = {surfx0,surfx1,surfy0,surfy1,surfz0,surfz1} ;
Volume(100) = {newsl-1};


// Define the physical entities
pbNo=periodicBoundaryBaseNo+periodicInX;
Physical Surface(pbNo) = {surfx0};    // left periodic
Physical Surface(pbNo+1) = {surfx1}; // right periodic
pbNo=periodicBoundaryBaseNo+periodicInY;
Physical Surface(pbNo) = {surfy0};    // front periodic
Physical Surface(pbNo+1) = {surfy1}; // back periodic

Physical Surface(0)={surfz0};   // Bottom surface
Physical Surface(1)={surfz1};   // Top surface

Physical Volume(0)={100};       // Single region
