// Gmsh project created on Thu Sep 20 11:35:03 2018
SetFactory("OpenCASCADE");
nx[] = {0.8, -0.8};
ny[] = {0.5, -0.5};
nz[] = {0, 0};
nr[] = {0.4, 0.4};
perid = 0.01;

No = 2;

Circle(0) = {0, 0, 0, 5, 0, 2*Pi};
loops[0] = 0;

For N In {1:No}
	newaxon = newc;
	Printf("newcircle %g", newaxon);
	Circle(newaxon) = {nx[N-1], ny[N-1], nz[N-1], nr[N-1], 0, 2*Pi};
	
	newloop = newaxon+1;
	Line Loop(newloop) = {newaxon};
	Plane Surface(newaxon) = {newloop};
	axons[] = Extrude {0,0,0.8} {Surface{newaxon}; };
	Printf("Volume no %g %g", N, axons[1]);
	Physical Volume("Axon",N+1) = {axons[1]};
	loops[N] = newloop;
EndFor

Printf("surfaces %g %g %g", loops[]);
//axons[] = Extrude {0,0,0.8} {Surface{1}; };
//+
//Printf("Volume %g", axons[4]);
//Physical Volume("Axons", 1) = {1,3};
//+


Plane Surface(3000) = {0};
endon[] = Extrude {0,0,0.8} {Surface{3000}; };
Physical Volume("Endoneurium", 2) = {endon[1]};
Printf("vols %g", endon[4]);