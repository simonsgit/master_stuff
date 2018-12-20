// Gmsh project created on Mon Sep 17 16:49:22 2018
ms = 0.1;


SetFactory("OpenCASCADE");
Ellipse(1) = {0, -0, -0, 2, 1, 0, 2*Pi};
//+
Circle(2) = {-0.5, 0, 0, 0.2, 0, 2*Pi};
//+
Circle(3) = {-0.5, 0, 0, 0.18, 0, 2*Pi};
//+
Circle(4) = {0.4, -0.4, 0, 0.3, 0, 2*Pi};
//+
Circle(5) = {0.4, -0.4, 0, 0.28, 0, 2*Pi};

Line Loop(1) = {1};
//+
Line Loop(2) = {2};
//+
Line Loop(3) = {3};
//+
Line Loop(4) = {4};
//+
Line Loop(5) = {5};
//+
Plane Surface(1) = {1,2,3,4,5};
//+
Plane Surface(2) = {2,3};
//+
Plane Surface(3) = {3};
//+
Plane Surface(4) = {4,5};
//+
Plane Surface(5) = {5};
//+
vol1[] = Extrude {{1, 0, 0} , {0, -2, 0.7} , Pi/20 } {Surface{1}; Surface{2}; Surface{3}; Surface{4}; Surface{5}; };
//+
Printf("vol %g", vol1[0]);
//+
Printf("vol %g", vol1[1]);
//+
Printf("vol %g", vol1[2]);
//+
Printf("vol %g", vol1[3]);
//+
Printf("vol %g", vol1[4]);
//+
Printf("vol %g", vol1[5]);

Extrude {0, 0, -0.8} {Surface{1}; Surface{2}; }
//+
Physical Volume("Epineurium", 1) = {1,3};
//+
Physical Volume("Endoneurium", 2) = {2,4};
//+
Cylinder(5) = {0, 0.3, -0.3, 1, -0.4, 0, 0.05, 2*Pi};
//+
Physical Volume("Electrode", 3) = {5};
