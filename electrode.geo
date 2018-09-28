//Generate Electrode
//+
Physical Volume("Axon",1) = {axon_vol[]};
//+
l = newp;
//+
Point(l) = {elec_xyz[0], elec_xyz[1], elec_xyz[2], elec_msh};
Point(l+1) = {elec_xyz[0], elec_xyz[1]+elec_rad, elec_xyz[2], elec_msh};
Point(l+2) = {elec_xyz[0], elec_xyz[1], elec_xyz[2]+elec_rad, elec_msh};
Point(l+3) = {elec_xyz[0], elec_xyz[1]-elec_rad, elec_xyz[2], elec_msh};
Point(l+4) = {elec_xyz[0], elec_xyz[1], elec_xyz[2]-elec_rad, elec_msh};
m = newc;
Circle(m) = {l+1, l, l+2};
Circle(m+1) = {l+2, l, l+3};
Circle(m+2) = {l+3, l, l+4};
Circle(m+3) = {l+4, l, l+1};
Line Loop(m+4) = {m, m+1, m+2, m+3};
n = news;
Plane Surface(n) = {m+4};
elec[] = Extrude {elec_extr[0], elec_extr[1], elec_extr[2]} {Surface{n}; Layers{elec_lay}; };
Physical Volume("Electrode", 2) = {elec[1]};
//+