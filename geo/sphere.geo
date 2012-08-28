radius = 5.0;
cellSize=2.0;

// create inner 1/8 shell
Point(1) = {0, 0, 0, cellSize};
Point(2) = {-radius, 0, 0, cellSize};
Point(3) = {0, radius, 0, cellSize};
Point(4) = {0, 0, radius, cellSize};
Circle(1) = {2,1,3};
Circle(2)= {3,1,4};
Circle(3)= {4,1,2};
Line Loop(1) = {1, 2, 3};
Ruled Surface (1) = {1};
rs2[] = Rotate {{0,0,1},{0,0,0},  Pi/2} {Duplicata{Surface{1};}};
rs3[] = Rotate {{0,0,1},{0,0,0},2*Pi/2} {Duplicata{Surface{1};}};
rs4[] = Rotate {{0,0,1},{0,0,0},3*Pi/2} {Duplicata{Surface{1};}};
rs5[] = Rotate {{0,1,0},{0,0,0}, -Pi/2} {Duplicata{Surface{1};}};
rs6[] = Rotate {{0,0,1},{0,0,0},  Pi/2} {Duplicata{Surface{rs5[0]};}};
rs7[] = Rotate {{0,0,1},{0,0,0},2*Pi/2} {Duplicata{Surface{rs5[0]};}};
rs8[] = Rotate {{0,0,1},{0,0,0},3*Pi/2} {Duplicata{Surface{rs5[0]};}};
Surface Loop(1) = {1,rs2[0],rs3[0],rs4[0],rs5[0],rs6[0],rs7[0],rs8[0]};
Volume(1) = {1};
