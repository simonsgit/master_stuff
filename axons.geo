// Gmsh project created on Tue Sep 25 11:32:57 2018
SetFactory("OpenCASCADE");

Include "/Users/st18/MasterThesis/master_stuff/tissue.geo";
//+
elec_msh = 1;
axon_msh = 1;
fasc_msh = 2;
peri_msh = 2;
epi_msh = 5;

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
points[] = Translate {elec_extr[0], elec_extr[1], elec_extr[2]} {Duplicata {Point{a};Point{a+1};Point{a+2};Point{a+3};Point{a+4};}};
circles[] = Translate {elec_extr[0], elec_extr[1], elec_extr[2]} {Duplicata {Line{b};Line{b+1};Line{b+2};Line{b+3};}};
surface[] = Translate {elec_extr[0], elec_extr[1], elec_extr[2]} {Duplicata {Surface{c};}};

d = newc;
Line(d) = {a+1, points[1]};
Line(d+1) = {a+2, points[2]};
Line(d+2) = {a+3, points[3]};
Line(d+3) = {a+4, points[4]};

e = newc; 
Line Loop(e) = {b, d+1, -circles[0], -d};
Line Loop(e+1) = {b+1, d+2, -circles[1], -(d+1)};
Line Loop(e+2) = {b+2, d+3, -circles[2], -(d+2)};
Line Loop(e+3) = {b+3, d, -circles[3], -(d+3)};

f = news;
Surface(f) = {e};
Surface(f+1) = {e+1};
Surface(f+2) = {e+2};
Surface(f+3) = {e+3};
Surface Loop(f+4) = {c, f, f+1, f+2, f+3, surface[0]};
g = newv;
Volume(g) = {f+4};
//elec[] = Extrude {elec_extr[0], elec_extr[1], elec_extr[2]} {Surface{c};};
Physical Volume("Electrode", newv) = {g};

For m In {1:NoF}
	Printf("Fascicle No. %g", m);
	For n In {1:NoA}
		i = newp;
		//Printf("Point no. %g", i);
		Point(i) = {fasc_x[m]+axon_x[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		Point(i+1) = {fasc_x[m]+axon_x[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n]+axon_rad[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		Point(i+2) = {fasc_x[m]+axon_x[(m-1)*NoA+n]+axon_rad[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		Point(i+3) = {fasc_x[m]+axon_x[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n]-axon_rad[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		Point(i+4) = {fasc_x[m]+axon_x[(m-1)*NoA+n]-axon_rad[(m-1)*NoA+n], fasc_y[m]+axon_y[(m-1)*NoA+n], fasc_z[m]+axon_z[(m-1)*NoA+n], axon_msh};
		j = newc;
		//Printf("Line no. %g", j);
		Circle(j) = {i+1, i, i+2};
		Circle(j+1) = {i+2, i, i+3};
		Circle(j+2) = {i+3, i, i+4};
		Circle(j+3) = {i+4, i, i+1};
		Line Loop(j+4) = {j, j+1, j+2, j+3};
		k = news;
		Plane Surface(k) = {j+4};
		axon[] = Extrude {0, 0, axon_h} {Surface{k}; Layers{ {1,1,1,6,1,1,1}, {0.5/1150,3.5/1150,49.5/1150,1099.5/1150,1145.5/1150,1148.5/1150,1} }; };
		axon_loops[n-1] = j+4;
		axon_vol[(m-1)*NoA+n] = axon[1];
		//Printf("vol %g", axon[1]);
	EndFor

	//Generate Endoneurium
	o = newp;
	//+
	Point(o) = {fasc_x[m], fasc_y[m], fasc_z[m], fasc_msh};
	Point(o+1) = {fasc_x[m], fasc_y[m]+fasc_rad[m], fasc_z[m], fasc_msh};
	Point(o+2) = {fasc_x[m]+fasc_rad[m], fasc_y[m], fasc_z[m], fasc_msh};
	Point(o+3) = {fasc_x[m], fasc_y[m]-fasc_rad[m], fasc_z[m], fasc_msh};
	Point(o+4) = {fasc_x[m]-fasc_rad[m], fasc_y[m], fasc_z[m], fasc_msh};
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
	peri_d = fasc_rad[m]*3/100;
	peri_msh = 1;
	r = newp;
	//+
	Point(r) = {fasc_x[m], fasc_y[m], fasc_z[m], peri_msh};
	Point(r+1) = {fasc_x[m], fasc_y[m]+fasc_rad[m]+peri_d, fasc_z[m], peri_msh};
	Point(r+2) = {fasc_x[m]+fasc_rad[m]+peri_d, fasc_y[m], fasc_z[m], peri_msh};
	Point(r+3) = {fasc_x[m], fasc_y[m]-fasc_rad[m]-peri_d, fasc_z[m], peri_msh};
	Point(r+4) = {fasc_x[m]-fasc_rad[m]-peri_d, fasc_y[m], fasc_z[m], peri_msh};
	s = newc;
	Circle(s) = {r+1, r, r+2};
	Circle(s+1) = {r+2, r, r+3};
	Circle(s+2) = {r+3, r, r+4};
	Circle(s+3) = {r+4, r, r+1};
	Line Loop(s+4) = {s, s+1, s+2, s+3};
	t = newc;
	Plane Surface(t) = {s+4,p+4};
	//Plane Surface(t+1) = {s+4};
	//nsurface[] = Translate {0,0,axon_h} {Duplicata {Surface{t+1};}};
	//Printf(" nsurface %g", nsurface[0]);
	peri_sur[m] = s+4;
	peri[] = Extrude {0, 0, axon_h} {Surface{t};};
	//Surface Loop(t+2) = {peri[2], peri[3], peri[4], peri[5]};
	peri_wal[(m-1)*4] = peri[2];
	peri_wal[(m-1)*4+1] = peri[3];
	peri_wal[(m-1)*4+2] = peri[4];
	peri_wal[(m-1)*4+3] = peri[5]; 
	//peri_loo[m-1] = t+2;
	peri_vol[m] = peri[1];
EndFor

Physical Volume("Axons", newv) = {axon_vol[]};
Physical Volume("Endoneurium", newv) = {fasc_vol[]};
Physical Volume("Perineurium", newv) = {peri_vol[]};

//Generate Epineurium
epi_xyz[] = {0,0,0};
epi_rad = 10;
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
npoints[] = Translate {0,0,axon_h} {Duplicata {Point{u};Point{u+1};Point{u+2};Point{u+3};Point{u+4};}};
ncircles[] = Translate {0,0,axon_h} {Duplicata {Line{v};Line{v+1};Line{v+2};Line{v+3};}};
nsurface[] = Translate {0,0,axon_h} {Duplicata {Surface{w};}};

x = newc;
Line(x) = {u+1, npoints[1]};
Line(x+1) = {u+2, npoints[2]};
Line(x+2) = {u+3, npoints[3]};
Line(x+3) = {u+4, npoints[4]};

y = newc; 
Line Loop(y) = {v, x+1, -ncircles[0], -x};
Line Loop(y+1) = {v+1, x+2, -ncircles[1], -(x+1)};
Line Loop(y+2) = {v+2, x+3, -ncircles[2], -(x+2)};
Line Loop(y+3) = {v+3, x, -ncircles[3], -(x+3)};

z = news;
Surface(z) = {y};
Surface(z+1) = {y+1};
Surface(z+2) = {y+2};
Surface(z+3) = {y+3};
Printf(" epi %g", z);
Printf(" epi %g", z+1);
Printf(" epi %g", z+2);

Surface Loop(z+4) = {w, z, z+1, z+2, z+3, nsurface[0], peri_wal[]};
h = newv;
Volume(h) = {z+4, f+4};
Physical Volume("Epineurium", newv) = {h};