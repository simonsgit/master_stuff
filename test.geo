// Gmsh project created on Mon Nov 12 14:59:06 2018


w = 10;
h = 5;
m = 1;

Point(1) = {-w/2,-h/5,0,m};
Point(2) = {w/2,-h/5,0,m};
Point(3) = {w/2,h/5,0,m};
Point(4) = {-w/2,h/5,0,m};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

Line Loop(1) = {1,2,3,4};

Surface(1) = {1};

Physical Surface("Tissue", 1) = {1};