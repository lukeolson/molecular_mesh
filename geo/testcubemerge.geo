Merge "cube.msh";
ss[] = Surface "*";
CreateTopology;
Printf("%g",#ss[]);
Surface Loop(1) = {ss[]};
Volume(1)={1};
