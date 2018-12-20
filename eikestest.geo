mesh_size = .1;
length = 2;

//+
Point(1) = {0, 0, 0, mesh_size};
//+
Point(2) = {length, 0, 0, mesh_size};
//+
//+
Point(4) = {0, 1, 0, mesh_size};
//+
Line(1) = {4, 1};
Line(3) = {1, 2};
//+
Ellipse(4) = {4, 1, 2, 2}; // Hallo
//+
Line Loop(1) = {1, 3, -4};
//+
Plane Surface(17) = {1};
//+
Point(5) = {0, 0, 1.3, 0.1};
//+
Line(5) = {5, 1};
//+
Line(6) = {4, 5};
//+
Line(7) = {5, 2};
//+
Line Loop(2) = {5, -1, 6};
//+
Plane Surface(18) = {2};
//+
Line Loop(3) = {5, 3, -7};
//+
Plane Surface(19) = {3};
//+
Line Loop(4) = {6, 7, -4};
//+
Surface(20) = {4};
//+
Surface Loop(1) = {20, 18, 19, 17};
//+
Volume(1) = {1};
