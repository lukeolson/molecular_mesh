//
// Make molecule
//
//Merge "1VII.msh";
//Merge "cube.msh";
//Merge "small1VII.msh";
//Merge "sphere.msh";
Merge "surf_HLS_32size_10iter_10taubsmooth_recenter.msh";
cl = 1;   // cylinder
cl2 = 10;    //top, bottom, sides
CreateTopology;
ll[] = Line "*";
ss[] = Surface "*";
ms = news;
mv = newv;
Surface Loop(ms) = {ss[]};
Volume(mv) = {ms};
Physical Surface("Molecule Surface") = {ms};
Physical Volume("Molecule") = {mv};

xmin = General.MinX;
xmax = General.MaxX;
ymin = General.MinY;
ymax = General.MaxY;
zmin = General.MinZ;
zmax = General.MaxZ;

If(1)
//
// Make Top-Channel-Bottom (\Omega_s)
//           l15
//     c16------- c15
//     /          /
// l16/   l13    / l14
//  c13------- c14
//
//           l11
//     c12------- c11
//     /          /
// l12/   l9     / l10
//  c9 ------- c10
//
//           l7
//     c8 ------- c7
//     /          /
// l8 /   l5     / l6
//  c5 ------- c6
//
//           l3
//     c4 ------- c3
//     /          /
// l4 /   l1     / l2
//  c1 ------- c2
//
//
// cylinder [radius, 2*halfheight]
//
radius = 1.2*ymax;
halfheight = 0.5*(zmax-zmin);
i = newp;
Point(i+1) = {      0,      0,-halfheight, cl}; // center
Point(i+2) = { radius,      0,-halfheight, cl};
Point(i+3) = {      0, radius,-halfheight, cl};
Point(i+4) = {-radius,      0,-halfheight, cl};
Point(i+5) = {      0,-radius,-halfheight, cl};
l = newl;
Circle(l+1) = {i+2,i+1,i+3};
Circle(l+2) = {i+3,i+1,i+4};
Circle(l+3) = {i+4,i+1,i+5};
Circle(l+4) = {i+5,i+1,i+2};
cylinderbottomloop = newll;
Line Loop(cylinderbottomloop) = {l+1,l+2,l+3,l+4};
out[] = Extrude {0,0,2*halfheight} { Line{l+1}; }; s1 = out[1]; l1 = out[0];
out[] = Extrude {0,0,2*halfheight} { Line{l+2}; }; s2 = out[1]; l2 = out[0];
out[] = Extrude {0,0,2*halfheight} { Line{l+3}; }; s3 = out[1]; l3 = out[0];
out[] = Extrude {0,0,2*halfheight} { Line{l+4}; }; s4 = out[1]; l4 = out[0];
cylindertoploop = newll;
Line Loop(cylindertoploop) = {l1,l2,l3,l4};
cylinders = news;
Surface Loop(cylinders) = {s1,s2,s3,s4};

// [-bx,bx,-by,by,-bz,bz] Bottom, BottomMid, TopMid, Top
bx = 2*radius;
by = 2*radius;
bz = 3*halfheight;
i = newp;
c1  = i+1;  c2  = i+2;  c3  = i+3;  c4  = i+4;
c5  = i+5;  c6  = i+6;  c7  = i+7;  c8  = i+8;
c9  = i+9;  c10 = i+10; c11 = i+11; c12 = i+12;
c13 = i+13; c14 = i+14; c15 = i+15; c16 = i+16;
Point(c1) = {-bx,-by,-bz, cl2}; Point(c5) = {-bx,-by,-halfheight, cl2}; Point(c9)  = {-bx,-by,halfheight, cl2}; Point(c13) = {-bx,-by,bz, cl2};
Point(c2) = { bx,-by,-bz, cl2}; Point(c6) = { bx,-by,-halfheight, cl2}; Point(c10) = { bx,-by,halfheight, cl2}; Point(c14) = { bx,-by,bz, cl2};
Point(c3) = { bx, by,-bz, cl2}; Point(c7) = { bx, by,-halfheight, cl2}; Point(c11) = { bx, by,halfheight, cl2}; Point(c15) = { bx, by,bz, cl2};
Point(c4) = {-bx, by,-bz, cl2}; Point(c8) = {-bx, by,-halfheight, cl2}; Point(c12) = {-bx, by,halfheight, cl2}; Point(c16) = {-bx, by,bz, cl2};
i = newl;
l1  = i+1;  l2  = i+2;  l3  = i+3;  l4 = i+4;
l5  = i+5;  l6  = i+6;  l7  = i+7;  l8 = i+8;
l9  = i+9;  l10 = i+10; l11 = i+11; l12 = i+12;
l13 = i+13; l14 = i+14; l15 = i+15; l16 = i+16;
Line(l1) = {c1,c2}; Line(l5) = {c5,c6}; Line(l9)  = {c9,c10};  Line(l13) = {c13,c14};
Line(l2) = {c2,c3}; Line(l6) = {c6,c7}; Line(l10) = {c10,c11}; Line(l14) = {c14,c15};
Line(l3) = {c3,c4}; Line(l7) = {c7,c8}; Line(l11) = {c11,c12}; Line(l15) = {c15,c16};
Line(l4) = {c4,c1}; Line(l8) = {c8,c5}; Line(l12) = {c12,c9};  Line(l16) = {c16,c13};
ll1 = newll; s1 = news;
Line Loop(ll1) = {l1,l2,l3,l4};
Plane Surface(s1) = {ll1};
ll5 = newll; s5 = news;
Line Loop(ll5) = {l5,l6,l7,l8};
Plane Surface(s5) = {ll5,cylinderbottomloop};
ll9 = newll; s9 = news;
Line Loop(ll9) = {l9,l10,l11,l12};
Plane Surface(s9) = {ll9,cylindertoploop};

// now the top.  extrude to preserve meshing for periodicity
out[] = Extrude{0,0,2*bz} { Surface{s1}; Layers{1}; };
s13 = out[0];
Delete {Volume {out[1]}; Surface{out[2]}; Surface{out[3]}; Surface{out[4]}; Surface{out[5]};}

//bottom/middle/top sides
i = newl;
sl1 = i+1; sl5 = i+5; sl9  = i+9;
sl2 = i+2; sl6 = i+6; sl10 = i+10;
sl3 = i+3; sl7 = i+7; sl11 = i+11;
sl4 = i+4; sl8 = i+8; sl12 = i+12;
Line(sl1)  = {c1,c5}; Line(sl5)  = {c5,c9};  Line(sl9)  = {c9,c13};
Line(sl2)  = {c2,c6}; Line(sl6)  = {c6,c10}; Line(sl10) = {c10,c14};
Line(sl3)  = {c3,c7}; Line(sl7)  = {c7,c11}; Line(sl11) = {c11,c15};
Line(sl4)  = {c4,c8}; Line(sl8)  = {c8,c12}; Line(sl12) = {c12,c16};
i=newll; j=news;
llside1 = i+1; llside5 = i+5; llside9  = i+9;
llside2 = i+2; llside6 = i+6; llside10 = i+10;
llside3 = i+3; llside7 = i+7; llside11 = i+11;
llside4 = i+4; llside8 = i+8; llside12 = i+12;
side1 = j+1; side5 = j+5; side9  = j+9;
side2 = j+2; side6 = j+6; side10 = j+10;
side3 = j+3; side7 = j+7; side11 = j+11;
side4 = j+4; side8 = j+8; side12 = j+12;
//
Line Loop(llside1) = {l1,sl2,-l5,-sl1}; Plane Surface(side1) = {llside1};
Line Loop(llside2) = {l2,sl3,-l6,-sl2}; Plane Surface(side2) = {llside2};
Line Loop(llside3) = {l3,sl4,-l7,-sl3}; Plane Surface(side3) = {llside3};
Line Loop(llside4) = {l4,sl1,-l8,-sl4}; Plane Surface(side4) = {llside4};
//
Line Loop(llside5) = {l5,sl6,-l9, -sl5}; Plane Surface(side5) = {llside5};
Line Loop(llside6) = {l6,sl7,-l10,-sl6}; Plane Surface(side6) = {llside6};
Line Loop(llside7) = {l7,sl8,-l11,-sl7}; Plane Surface(side7) = {llside7};
Line Loop(llside8) = {l8,sl5,-l12,-sl8}; Plane Surface(side8) = {llside8};
//
Line Loop(llside9)  = {l9, sl10,-l13,-sl9};  Plane Surface(side9)  = {llside9};
Line Loop(llside10) = {l10,sl11,-l14,-sl10}; Plane Surface(side10) = {llside10};
Line Loop(llside11) = {l11,sl12,-l15,-sl11}; Plane Surface(side11) = {llside11};
Line Loop(llside12) = {l12,sl9, -l16,-sl12}; Plane Surface(side12) = {llside12};

// now the volume
channels = news;
channelv = newv;
Surface Loop(channels) = {s1,side1,side2,side3,side4,s5,s9,side9,side10,side11,side12,s13};
Volume(channelv) = {channels,cylinders,ms};
Physical Surface("Omega_s Surface") = {channels,cylinders,ms};
Physical Volume("Omega_s") = {channelv};

// \Omega_m
sides = news;
sidev = newv;
Surface Loop(sides) = {side5,side6,side7,side8,s5,s9};
Volume(sidev) = {sides,cylinders};
Physical Surface("Omega_m Surface") = {sides,cylinders};
Physical Volume("Omega_m") = {sidev};
EndIf

Mesh.Algorithm3D = 4; //for frontal algorithm to preserve periodicity
Mesh.RemeshAlgorithm = 1; // (0) no split (1) automatic (2) automatic only with metis
Mesh.RemeshParametrization = 1; // (0) harmonic (1) conformal 
