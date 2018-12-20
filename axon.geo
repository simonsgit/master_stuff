// Gmsh project created on Mon Sep 24 10:44:45 2018
SetFactory("OpenCASCADE");
//+
Circle(1) = {0, 0, 0, 0.1, 0, 2*Pi};
//+
Circle(2) = {0, 0, 0, 1, 0, 2*Pi};
//+
Line Loop(1) = {1};
//+
Line Loop(2) = {2};
//+
Plane Surface(1) = {1};
//+
Plane Surface(2) = {1,2};
//+
axon[] = Extrude {0,0,1.15} {Surface{1}; Layers{11};};
//+
Physical Volume("Axon",1) = {1};
//+
endo[] = Extrude {0,0,1.15} {Surface{2}; };
//+
Physical Volume("Endoneurium", 2) = {endo[1]};
//+
Cylinder(3) = {-1, 0.5, 0.5, 2, 0, 0, 0.05, 2*Pi};
//+
Physical Volume("Electrode", 3) = {3};//+
Line Loop(12) = {1};
//+
Plane Surface(11) = {12};
//+
Line Loop(13) = {2};
//+
Line Loop(14) = {1};
//+
Plane Surface(12) = {13, 14};
