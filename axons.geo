// Gmsh project created on Tue Sep 25 11:32:57 2018
SetFactory("OpenCASCADE");

Include "/Users/st18/MasterThesis/master_stuff/tissue.geo";
//+

// Generate Electrode
a = newp;
Point(a) = {elec_x[0], elec_y[0], elec_z[0], elec_msh};
Point(a+1) = {elec_x[1], elec_y[1], elec_z[1], elec_msh};
Point(a+2) = {elec_x[2], elec_y[2], elec_z[2], elec_msh};
Point(a+3) = {elec_x[3], elec_y[3], elec_z[3], elec_msh};
Point(a+4) = {elec_x[4], elec_y[4], elec_z[4], elec_msh};
b = newc;
Circle(b) = {a+1, a, a+2};
Circle(b+1) = {a+2, a, a+3};
Circle(b+2) = {a+3, a, a+4};
Circle(b+3) = {a+4, a, a+1};
Line Loop(b+4) = {b, b+1, b+2, b+3};
c = newc;
Plane Surface(c) = {b+4};
surf[] = Translate {0,2,0} {Duplicata {Surface{c};}};
//elec[] = Extrude {elec_extr[0], elec_extr[1], elec_extr[2]} {Surface{c};};
//Physical Volume("Electrode", newv) = {elec[1]};

For m In {1:NoF}
	Printf("Fascicle No. %g", m);
	For n In {1:NoA}
		i = newp;
		//Printf("Point no. %g", i);
		Point(i) = {fasc_x[m]+axon_x[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n]+axon_rad[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		Point(i+1) = {fasc_x[m]+axon_x[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		Point(i+2) = {fasc_x[m]+axon_x[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n]-axon_rad[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		j = newc;
		//Printf("Line no. %g", j);
		Circle(j) = {i, i+1, i+2};
		Circle(j+1) = {i+2, i+1, i};
		Line Loop(j+2) = {j, j+1};
		k = news;
		Plane Surface(k) = {j+2};
		axon[] = Extrude {0, 0, axon_h} {Surface{k}; Layers{axon_lay}; };
		axon_loops[n-1] = j+2;
		axon_vol[(m-1)*NoA+n] = axon[1];
		//Printf("vol %g", axon[1]);
	EndFor

	//Generate Endoneurium
	o = newp;
	//+
	Point(o) = {fasc_x[m], fasc_y[m], fasc_z[m], fasc_msh};
	Point(o+1) = {fasc_x[m], fasc_y[m]+fasc_rad, fasc_z[m], fasc_msh};
	Point(o+2) = {fasc_x[m]+fasc_rad, fasc_y[m], fasc_z[m], fasc_msh};
	Point(o+3) = {fasc_x[m], fasc_y[m]-fasc_rad, fasc_z[m], fasc_msh};
	Point(o+4) = {fasc_x[m]-fasc_rad, fasc_y[m], fasc_z[m], fasc_msh};
	p = newc;
	Circle(p) = {o+1, o, o+2};
	Circle(p+1) = {o+2, o, o+3};
	Circle(p+2) = {o+3, o, o+4};
	Circle(p+3) = {o+4, o, o+1};
	Line Loop(p+4) = {p, p+1, p+2, p+3};
	q = news;
	Plane Surface(q) = {p+4, axon_loops[]};
	endo[] = Extrude {0, 0, axon_h} {Surface{q};};
	fasc_vol[m] = endo[1];
	

	//Generate Perineurium
	peri_d = fasc_rad*3/100;
	peri_msh = 0.1;
	r = newp;
	//+
	Point(r) = {fasc_x[m], fasc_y[m], fasc_z[m], peri_msh};
	Point(r+1) = {fasc_x[m], fasc_y[m]+fasc_rad+peri_d, fasc_z[m], peri_msh};
	Point(r+2) = {fasc_x[m]+fasc_rad+peri_d, fasc_y[m], fasc_z[m], peri_msh};
	Point(r+3) = {fasc_x[m], fasc_y[m]-fasc_rad-peri_d, fasc_z[m], peri_msh};
	Point(r+4) = {fasc_x[m]-fasc_rad-peri_d, fasc_y[m], fasc_z[m], peri_msh};
	s = newc;
	Circle(s) = {r+1, r, r+2};
	Circle(s+1) = {r+2, r, r+3};
	Circle(s+2) = {r+3, r, r+4};
	Circle(s+3) = {r+4, r, r+1};
	Line Loop(s+4) = {s, s+1, s+2, s+3};
	t = newc;
	Plane Surface(t) = {s+4,p+4};
	peri_sur[m] = s+4;
	peri[] = Extrude {0, 0, axon_h} {Surface{t};};
	peri_vol[m] = peri[1];
	
EndFor

Physical Volume("Axons", newv) = {axon_vol[]};
Physical Volume("Endoneurium", newv) = {fasc_vol[]};
Physical Volume("Perineurium", newv) = {peri_vol[]};

//Generate Epineurium
epi_xyz[] = {0,0,0};
epi_rad = 50;
epi_msh = 0.1;
u = newp;
Point(u) = {epi_xyz[0], epi_xyz[1], epi_xyz[2], epi_msh};
Point(u+1) = {epi_xyz[0], epi_xyz[1]+epi_rad, epi_xyz[2], epi_msh};
Point(u+2) = {epi_xyz[0]+epi_rad, epi_xyz[1], epi_xyz[2], epi_msh};
Point(u+3) = {epi_xyz[0], epi_xyz[1]-epi_rad, epi_xyz[2], epi_msh};
Point(u+4) = {epi_xyz[0]-epi_rad, epi_xyz[1], epi_xyz[2], epi_msh};
v = newc;
Circle(v) = {u+1, u, u+2};
Circle(v+1) = {u+2, u, u+3};
Circle(v+2) = {u+3, u, u+4};
Circle(v+3) = {u+4, u, u+1};
Line Loop(v+4) = {v, v+1, v+2, v+3};
w = newc;
peri_sur[0] = v+4;
Plane Surface(w) = {peri_sur[]};
epi[] = Extrude {0, 0, axon_h} {Surface{w};};
Physical Volume("Epineurium", newv) = {epi[1]};

