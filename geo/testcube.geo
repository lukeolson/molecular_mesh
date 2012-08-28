cl1 = 1;

//Merge "cubesmall.msh";
Merge "1VII.pqr.output.surf.msh";
ss[] = Surface "*";
CreateTopology;
ms = news;
mv = newv;
Surface Loop(ms) = {ss[]};
Volume(mv)={ms};

dim = 15;
p=newp;
Point(p+1) = {-dim, -dim, -dim, cl1};
Point(p+2) = {dim, -dim, -dim, cl1};
Point(p+3) = {dim, dim, -dim, cl1};
Point(p+4) = {-dim, dim, -dim, cl1};
Point(p+5) = {-dim, -dim, dim, cl1};
Point(p+6) = {dim, -dim, dim, cl1};
Point(p+7) = {dim, dim, dim, cl1};
Point(p+8) = {-dim, dim, dim, cl1};

l=newl;
Line(l+1)  = {p+5, p+6};
Line(l+2)  = {p+6, p+2};
Line(l+3)  = {p+2, p+1};
Line(l+4)  = {p+1, p+5};
Line(l+5)  = {p+5, p+8};
Line(l+6)  = {p+8, p+4};
Line(l+7)  = {p+4, p+1};
Line(l+8)  = {p+4, p+3};
Line(l+9)  = {p+3, p+7};
Line(l+10) = {p+7, p+8};
Line(l+11) = {p+3, p+2};
Line(l+12) = {p+7, p+6};

ll=newll;
Line Loop(ll+14) = {l+11, l+3, -(l+7), l+8};
Line Loop(ll+16) = {l+8, l+9, l+10, l+6};
Line Loop(ll+18) = {l+9, l+12, l+2, -(l+11)};
Line Loop(ll+20) = {l+2, l+3, l+4, l+1};
Line Loop(ll+22) = {l+4, l+5, l+6, l+7};
Line Loop(ll+24) = {l+1, -(l+12), l+10, -(l+5)};

s=news;
Plane Surface(s+14) = {ll+14};
Plane Surface(s+16) = {ll+16};
Plane Surface(s+18) = {ll+18};
Plane Surface(s+20) = {ll+20};
Plane Surface(s+22) = {ll+22};
Plane Surface(s+24) = {ll+24};
Surface Loop(s+26) = {s+14, s+16, s+18, s+20, s+22, s+24};

Printf("%g",s+14);
Printf("%g",s+16);
Printf("%g",s+18);
Printf("%g",s+20);
Printf("%g",s+22);
Printf("%g",s+24);
Volume(newv) = {s+26};
