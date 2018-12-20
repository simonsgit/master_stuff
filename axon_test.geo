// Gmsh project created on Fri Nov 16 11:58:54 2018
SetFactory("OpenCASCADE");

Include "/Users/st18/MasterThesis/gmsh_stuff/tissue.geo";
//+
elec_msh = 1;
axon_msh = 0.1;
fasc_msh = 0.1;
peri_msh = 1;
epi_msh = 1;

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
		Printf("Axon Surface %g", k);
		axon_sur[n-1] = k;
		//axon[] = Extrude {0, 0, axon_h} {Surface{k}; Layers{ {1,1,1,6,1,1,1},{0.5/1150,3.5/1150,49.5/1150,1099.5/1150,1145.5/1150,1148.5/1150,1} }; };
		axon_loops[n-1] = j+4;
		//axon_vol[(m-1)*NoA+n] = axon[1];
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
	//endo[] = Extrude {0, 0, axon_h} {Surface{q};};
	//fasc_vol[m] = endo[1];
	

	//Generate Perineurium
	peri_d = fasc_rad[m]*3/100;
	peri_msh = 0.5;
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
	//peri[] = Extrude {0, 0, axon_h} {Surface{t};};
	//Surface Loop(t+2) = {peri[2], peri[3], peri[4], peri[5]};
	//peri_wal[(m-1)*4] = peri[2];
	//peri_wal[(m-1)*4+1] = peri[3];
	//peri_wal[(m-1)*4+2] = peri[4];
	//peri_wal[(m-1)*4+3] = peri[5]; 
	//peri_loo[m-1] = t+2;
	//peri_vol[m] = peri[1];
EndFor
Printf("Axon Surfaces %g", axon_sur[]);
Physical Surface("Axons", newv) = {axon_sur[]};
Physical Surface("Endoneurium", newv) = {fasc_vol[]};
Physical Surface("Perineurium", newv) = {peri_sur[]};

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
Physical Surface("Epineurium",news) = {w};
//npoints[] = Translate {0,0,axon_h} {Duplicata {Point{u};Point{u+1};Point{u+2};Point{u+3};Point{u+4};}};
//ncircles[] = Translate {0,0,axon_h} {Duplicata {Line{v};Line{v+1};Line{v+2};Line{v+3};}};
//nsurface[] = Translate {0,0,axon_h} {Duplicata {Surface{w};}};

//x = newc;
//Line(x) = {u+1, npoints[1]};
//Line(x+1) = {u+2, npoints[2]};
//Line(x+2) = {u+3, npoints[3]};
//Line(x+3) = {u+4, npoints[4]};

//y = newc; 
//Line Loop(y) = {v, x+1, -ncircles[0], -x};
//Line Loop(y+1) = {v+1, x+2, -ncircles[1], -(x+1)};
//Line Loop(y+2) = {v+2, x+3, -ncircles[2], -(x+2)};
//Line Loop(y+3) = {v+3, x, -ncircles[3], -(x+3)};

//z = news;
//Surface(z) = {y};
//Surface(z+1) = {y+1};
//Surface(z+2) = {y+2};
//Surface(z+3) = {y+3};
//Printf(" epi %g", z);
//Printf(" epi %g", z+1);
//Printf(" epi %g", z+2);

//Surface Loop(z+4) = {w, z, z+1, z+2, z+3, nsurface[0], peri_wal[]};
//h = newv;
//Volume(h) = {z+4, f+4};
//Volume(h) = {z+4};
//Physical Surface("Epineurium", news) = {z+4};