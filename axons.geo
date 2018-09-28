// Gmsh project created on Tue Sep 25 11:32:57 2018
SetFactory("OpenCASCADE");

Include "tissue.geo";
//+

For n In {1:No}
	i = newp;
	Printf("Point no. %g", i);
	Point(i) = {axon_x[n], axon_y[n]+axon_rad[n], axon_z[n], axon_msh};
	Point(i+1) = {axon_x[n], axon_y[n], axon_z[n], axon_msh};
	Point(i+2) = {axon_x[n], axon_y[n]-axon_rad[n], axon_z[n], axon_msh};
	j = newc;
	Printf("Line no. %g", j);
	Circle(j) = {i, i+1, i+2};
	Circle(j+1) = {i+2, i+1, i};
	Line Loop(j+2) = {j, j+1};
	k = news;
	Plane Surface(k) = {j+2};
	axon[] = Extrude {0, 0, axon_h} {Surface{k}; Layers{axon_lay}; };
	axon_loops[n-1] = j+2;
	axon_vol[n] = axon[1];
EndFor

//Generate Endoneurium
o = newp;
//+
Point(o) = {endo_xyz[0], endo_xyz[1], endo_xyz[2], endo_msh};
Point(o+1) = {endo_xyz[0], endo_xyz[1]+endo_rad, endo_xyz[2], endo_msh};
Point(o+2) = {endo_xyz[0]+endo_rad, endo_xyz[1], endo_xyz[2], endo_msh};
Point(o+3) = {endo_xyz[0], endo_xyz[1]-endo_rad, endo_xyz[2], endo_msh};
Point(o+4) = {endo_xyz[0]-endo_rad, endo_xyz[1], endo_xyz[2], endo_msh};
p = newc;
Circle(p) = {o+1, o, o+2};
Circle(p+1) = {o+2, o, o+3};
Circle(p+2) = {o+3, o, o+4};
Circle(p+3) = {o+4, o, o+1};
Line Loop(p+4) = {p, p+1, p+2, p+3};
q = news;
Plane Surface(q) = {p+4, axon_loops[]};
endo[] = Extrude {0, 0, axon_h} {Surface{q};};
Physical Volume("Endoneurium", 3) = {endo[1]};

//Generate Perineurium
peri_d = endo_rad*3/100;
r = newp;
//+
Point(r) = {endo_xyz[0], endo_xyz[1], endo_xyz[2], endo_msh};
Point(r+1) = {endo_xyz[0], endo_xyz[1]+endo_rad+peri_d, endo_xyz[2], endo_msh};
Point(r+2) = {endo_xyz[0]+endo_rad+peri_d, endo_xyz[1], endo_xyz[2], endo_msh};
Point(r+3) = {endo_xyz[0], endo_xyz[1]-endo_rad-peri_d, endo_xyz[2], endo_msh};
Point(r+4) = {endo_xyz[0]-endo_rad-peri_d, endo_xyz[1], endo_xyz[2], endo_msh};
s = newc;
Circle(s) = {r+1, r, r+2};
Circle(s+1) = {r+2, r, r+3};
Circle(s+2) = {r+3, r, r+4};
Circle(s+3) = {r+4, r, r+1};
Line Loop(s+4) = {s, s+1, s+2, s+3};
t = newc;
Plane Surface(t) = {s+4,p+4};
epi[] = Extrude {0, 0, axon_h} {Surface{t};};
Physical Volume("Epineurium", 4) = {epi[1]};