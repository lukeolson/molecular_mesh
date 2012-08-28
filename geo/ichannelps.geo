//
// Make molecule
//
//Geometry.Tolerance = 1e-9 ;
//Geometry.AutoCoherence = 0;
cl = 1;   // cylinder
cl2 = 10;    //top, bottom, sides
layersize=6;
//Merge "1VII.msh";
//Merge "small1VII.msh";
//Merge "sphere.msh";
If(1)
  Merge "surf_HLS_32size_10iter_10taubsmooth_recenter.msh";
  CreateTopology;
  ll[] = Line "*";
  ss[] = Surface "*";
  smolecule = newsl; Surface Loop(smolecule) = {ss[]};
  Physical Surface("Molecule Surface") = {smolecule};
  vmolecule = newv; Volume(vmolecule) = {smolecule};
  Physical Volume("Molecule") = {vmolecule};

  // first get the dimensions
  xmin = General.MinX;
  xmax = General.MaxX;
  ymin = General.MinY;
  ymax = General.MaxY;
  zmin = General.MinZ;
  zmax = General.MaxZ;
EndIf
If(0)
  xmin = -10;
  xmax = 10;
  ymin = -10;
  ymax = 10;
  zmin = -20;
  zmax = 20;
EndIf
radmax = -ymin;
radius = radmax + 6;
halfheight = zmax + 10;
//halfheight = 0.5*(zmax-zmin);
Printf("halfheight = %g", halfheight);
Printf("zmax + 10 = %g", halfheight);
Printf("xmmin = %g", xmin);
Printf("xmmax = %g", xmax);
Printf("ymmin = %g", ymin);
Printf("ymmax = %g", ymax);
Printf("zmmin = %g", zmin);
Printf("zmmax = %g", zmax);
Printf("radius = %g",radius);
bx = 30;
by = 30;
bz = 60;
// cylinder [radius, 2*halfheight]

// Make Top-Channel-Bottom (\Omega_s)
//      .----------.
//     /          /
//    /          /
//  c8 ------- c7
//
//      .----------.
//     /          /
//    /          /
//  c5 ------- c6
//            
//      .----------.
//     /          /
//    /          /
//  c4 ------- c3
//
//      .----------.
//     /          /
//    /          /
//  c1 ------- c2
//
// notation
//sfb (side-front-bottom)
//sbb (side-back-bottom)
//srb (side-right-bottom)
//slb (side-left-bottom), same for mid and top
//bot (bottom)
//top (top)
If(1)
////////////////////////////////////////////////////////////
// bottom cube
////////////////////////////////////////////////////////////
  c1=newp; Point(c1) = {-bx,-by,-bz, cl2};
  c2=newp; Point(c2) = { bx,-by,-bz, cl2};
  c3=newp; Point(c3) = { bx,-by,-halfheight, cl2}; 
  c4=newp; Point(c4) = {-bx,-by,-halfheight, cl2}; 
  l1=newl; Line(l1) = {c1,c2};
  l2=newl; Line(l2) = {c2,c3};
  l3=newl; Line(l3) = {c3,c4};
  l4=newl; Line(l4) = {c4,c1};
// front
  llsfb=newl; Line Loop(llsfb) = {l1, l2, l3, l4};
  sfb=news; Plane Surface(sfb) = {llsfb};
// back
  out[]=Extrude {0,2*by,0} {Surface{sfb}; Layers{layersize};};
  sbb=out[0];
  bndsrb[]=Boundary {Surface{out[3]};};
  bndbot[]=Boundary {Surface{out[2]};};
  bndtopofbot[]=Boundary {Surface{out[4]};};
  //For kk In {0:#out[]-1}
  //  Printf("out[%g] = %g", kk, out[kk]);
  //EndFor
  Delete{Volume{out[1]};Surface{ out[{2:#out[]-1}] };}
// right
  llsrb=newll; Line Loop(llsrb) = {bndsrb[]};
  srb=news; Plane Surface(srb) = {llsrb};
// left
  out[]= Translate {-2*bx,0,0} {Duplicata{ Surface{srb};}};
  slb = out[0];
  Periodic Surface slb { Boundary{Surface{out[0]};} } = srb { bndsrb[] } ;
// bottom
  llbot=newll; Line Loop(llbot) = {bndbot[]};
  bot=news; Plane Surface(bot) = {llbot};
EndIf

If(1)
////////////////////////////////////////////////////////////
// top cube
////////////////////////////////////////////////////////////
// top
  c5=newp; Point(c5) = {-bx,-by,halfheight, cl2};
  c6=newp; Point(c6) = { bx,-by,halfheight, cl2};
  c7=newp; Point(c7) = { bx,-by,bz, cl2}; 
  c8=newp; Point(c8) = {-bx,-by,bz, cl2}; 
  l5=newl; Line(l5) = {c5,c6};
  l6=newl; Line(l6) = {c6,c7};
  l7=newl; Line(l7) = {c7,c8};
  l8=newl; Line(l8) = {c8,c5};
// front
  llsft=newl; Line Loop(llsft) = {l5, l6, l7, l8};
  sft=news; Plane Surface(sft) = {llsft};
// back
  out[]=Extrude {0,2*by,0} {Surface{sft}; Layers{layersize};};
  sbt=out[0];
  bndsrt[]=Boundary {Surface{out[3]};};
  bndtop[]=Boundary {Surface{out[4]};};
  bndbotoftop[]=Boundary {Surface{out[2]};};
  //For kk In {0:#out[]-1}
  //  Printf("out[%g] = %g", kk, out[kk]);
  //EndFor
  Delete{Volume{out[1]};Surface{ out[{2:#out[]-1}] };}
// right
  llsrt=newll; Line Loop(llsrt) = {bndsrt[]};
  srt=news; Plane Surface(srt) = {llsrt};
// left
  out[]= Translate {-2*bx,0,0} {Duplicata{ Surface{srt};}};
  slt = out[0];
  Periodic Surface slt { Boundary{Surface{out[0]};} } = srt { bndsrt[] } ;
// top
              //lltop=newll; Line Loop(lltop) = {bndtop[]};
              //lltop=newll; Line Loop(lltop) = {bndtop[0],bndtop[3],bndtop[2],bndtop[1]};
              //top=news; Plane Surface(top) = {lltop};
              //Periodic Surface top { Boundary{Surface{top[]};} } = bot { Boundary{Surface{bot[]};}};
  out[]= Translate {0,0,2*bz} {Duplicata{ Surface{bot};}};
  top = out[0];
  Periodic Surface top { Boundary{Surface{out[0]};} } = bot { Boundary{Surface{bot[]};}};
EndIf

If(1)
////////////////////////////////////////////////////////////
// cylinder
////////////////////////////////////////////////////////////
// cylinder
  cylp1 = newp; Point(cylp1) = {      0,      0,-halfheight+5, cl}; // center
  cylp2 = newp; Point(cylp2) = { radius,      0,-halfheight+5, cl};
  cylp3 = newp; Point(cylp3) = {      0, radius,-halfheight+5, cl};
  cylp4 = newp; Point(cylp4) = {-radius,      0,-halfheight+5, cl};
  cylp5 = newp; Point(cylp5) = {      0,-radius,-halfheight+5, cl};
  cyll1 = newl; Circle(cyll1) = {cylp2,cylp1,cylp3};
  cyll2 = newl; Circle(cyll2) = {cylp3,cylp1,cylp4};
  cyll3 = newl; Circle(cyll3) = {cylp4,cylp1,cylp5};
  cyll4 = newl; Circle(cyll4) = {cylp5,cylp1,cylp2};
  cylindermidbotloop = newll; Line Loop(cylindermidbotloop) = {cyll1,cyll2,cyll3,cyll4};
  // sides
  out[] = Extrude {0,0,2*halfheight-10} { Line{cyll1}; }; s1 = out[1]; cyll5 = out[0];
  out[] = Extrude {0,0,2*halfheight-10} { Line{cyll2}; }; s2 = out[1]; cyll6 = out[0];
  out[] = Extrude {0,0,2*halfheight-10} { Line{cyll3}; }; s3 = out[1]; cyll7 = out[0];
  out[] = Extrude {0,0,2*halfheight-10} { Line{cyll4}; }; s4 = out[1]; cyll8 = out[0];
  cylindermidtoploop = newll; Line Loop(cylindermidtoploop) = {cyll5,cyll6,cyll7,cyll8};
  // side top
  out[] = Extrude {0,0,5} { Line{cyll5}; }; s1top = out[1]; cyll1top = out[0];
  out[] = Extrude {0,0,5} { Line{cyll6}; }; s2top = out[1]; cyll2top = out[0];
  out[] = Extrude {0,0,5} { Line{cyll7}; }; s3top = out[1]; cyll3top = out[0];
  out[] = Extrude {0,0,5} { Line{cyll8}; }; s4top = out[1]; cyll4top = out[0];
  cylindertoploop = newll; Line Loop(cylindertoploop) = {cyll1top,cyll2top,cyll3top,cyll4top};
  // side bottom
  out[] = Extrude {0,0,-5} { Line{cyll1}; }; s1bot = out[1]; cyll1bot = out[0];
  out[] = Extrude {0,0,-5} { Line{cyll2}; }; s2bot = out[1]; cyll2bot = out[0];
  out[] = Extrude {0,0,-5} { Line{cyll3}; }; s3bot = out[1]; cyll3bot = out[0];
  out[] = Extrude {0,0,-5} { Line{cyll4}; }; s4bot = out[1]; cyll4bot = out[0];
  cylinderbotloop = newll; Line Loop(cylinderbotloop) = {cyll1bot,cyll2bot,cyll3bot,cyll4bot};
  // cyl top surface
  cyltops = news; Plane Surface(cyltops) = {cylindermidtoploop};
  // cyl bot surface
  cylbots = news; Plane Surface(cylbots) = {cylindermidbotloop};
  // cyl surface
  cyl = newsl; Surface Loop(cyl) = {s1,s2,s3,s4,cyltops,cylbots};
  // cyl sides surface
  cylsides = newsl; Surface Loop(cylsides) = {s1,s2,s3,s4};
  // top sides
  cyltop = newsl; Surface Loop(cyltop) = {s1top,s2top,s3top,s4top};
  // bottom sides
  cylbot = newsl; Surface Loop(cylbot) = {s1bot,s2bot,s3bot,s4bot};
EndIf

If(1)
// top of the bottom
  lltopofbot=newll; Line Loop(lltopofbot) = {bndtopofbot[]};
  topofbot=news; Plane Surface(topofbot) = {lltopofbot,cylinderbotloop};
EndIf
If(1)
// bottom of the top
  llbotoftop=newll; Line Loop(llbotoftop) = {bndbotoftop[]};
  botoftop=news; Plane Surface(botoftop) = {llbotoftop,cylindertoploop};
EndIf

// channeltop
channeltop = newsl; Surface Loop(channeltop) = {top,sft,srt,sbt,slt,botoftop,s1top,s2top,s3top,s4top,cyltops};
// channelbot
channelbot = newsl; Surface Loop(channelbot) = {bot,sfb,srb,sbb,slb,topofbot,s1bot,s2bot,s3bot,s4bot,cylbots};
//
Physical Surface("Omega_s Surface") = {channeltop,channelbot,cyl,smolecule};
//
vomegastop = newv; Volume(vomegastop) = {channeltop};
vomegasbot = newv; Volume(vomegasbot) = {channelbot};
vomegascyl = newv; Volume(vomegascyl) = {cyl};
Physical Volume("Omega_s") = {vomegastop,vomegasbot,vomegascyl};

If(1)
////////////////////////////////////////////////////////////
// membrane
////////////////////////////////////////////////////////////
  l45=newl; Line(l45) = {c4,c5};
  l36=newl; Line(l36) = {c3,c6};
//  c3b=newp; Point(c3b) = { bx,by,-halfheight, cl2}; 
//  c6b=newp; Point(c6b) = { bx,by, halfheight, cl2};
//  l3b=newl; Line(l3b) = {c3,c3b};
//  l6b=newl; Line(l6b) = {c6,c6b};
//  l3b6b=newl; Line(l3b6b) = {c3b,c6b};
// front
  llsfm=newl; Line Loop(llsfm) = {-l3,l36,-l5,-l45};
  sfm=news; Plane Surface(sfm) = {llsfm};
// back
  out[]=Translate {0,2*by,0} {Duplicata{ Surface{sfm};}};
  sbm=out[0];
  Periodic Surface sbm { Boundary{Surface{out[0]};} } = sfm { Boundary{Surface{sfm[]};}};
// right
  bndsbm = Boundary{Surface{sbm[]};};
  llsrm=newl; Line Loop(llsrm) = {-bndtopofbot[3],bndsbm[1],-bndbotoftop[1],-l36};
  srm=news; Plane Surface(srm) = {llsrm};
// left
  out[]=Translate {-2*bx,0,0} {Duplicata{ Surface{srm};}};
  slm=out[0];
  Periodic Surface slm { Boundary{Surface{out[0]};} } = srm { Boundary{Surface{srm[]};}};

// \Omega_m
  smside = newsl; Surface Loop(smside) = {botoftop,sfm,srm,sbm,slm,topofbot,s1,s2,s3,s4,s1top,s2top,s3top,s4top,s1bot,s2bot,s3bot,s4bot};
  Physical Surface("Omega_m Surface") = {smside};
  vmside = newv;       Volume(vmside) = {smside};
  Physical Volume("Omega_m") = {vmside};
EndIf

Mesh.Algorithm3D = 4; //for frontal algorithm to preserve periodicity
Mesh.RemeshAlgorithm = 1; // (0) no split (1) automatic (2) automatic only with metis
Mesh.RemeshParametrization = 1; // (0) harmonic (1) conformal 
