// Gmsh project created on Mon Nov 26 11:16:46 2018
nmsh = 1;
mmsh = 3;
fmsh = 46;
smsh = 175;

ln = 1;
lm = 3;
lf = 46;
ls = 175;

Point(1) = {0,0,0,nmsh};
Point(2) = {2.0,0,0,mmsh};
Point(3) = {26.5,0,0,fmsh};
Point(4) = {137,0,0,smsh};
Point(5) = {312,0,0,smsh};
Point(6) = {487,0,0,smsh};
Point(7) = {662,0,0,smsh};
Point(8) = {837,0,0,smsh};
Point(9) = {1012,0,0,smsh};
Point(10)= {1122.5,0,0,fmsh};
Point(11)= {1147,0,0,mmsh};
Point(12)= {1149,0,0,nmsh};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,5};
Line(5) = {5,6};
Line(6) = {6,7};
Line(7) = {7,8};
Line(8) = {8,9};
Line(9) = {9,10};
Line(10) = {10,11};
Line(11) = {11,12};

Physical Point("Node", 1) = {1,12};
Physical Point("MYSA", 2) = {2,11};
Physical Point("FLUT", 3) = {3,10};
Physical Point("STIN", 4) = {4,5,6,7,8,9};

Physical Line("Node", 1) = {1,12};