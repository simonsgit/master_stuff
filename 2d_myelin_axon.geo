// Gmsh project created on Tue Nov 27 15:17:51 2018
SetFactory("Built-in");

//Set Tissue
in = 1150;
nl = 1;
nd = 3.3;
ind = 6.9;
mh = 1;
bh = 50;
nmsh = 100;
amsh = 100;
bmsh = 100;
N = 19;

Point(1) = {0,0,0,nmsh};
Point(2) = {0,-nd,0,nmsh};
Point(3) = {nl,-nd,0,nmsh};
Point(4) = {nl,0,0,nmsh};

Point(5) = {0,bh,0,bmsh};
Point(6) = {0,-(nd+bh),0,bmsh};
Point(7) = {(N-1)*in+nl,-(nd+bh),0,bmsh};
Point(8) = {(N-1)*in+nl,bh,0,bmsh};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {4,3};
Line(4) = {4,1};

Line(5) = {5,1};
Line(6) = {2,6};

Line Loop(1) = {1,2,-3,4};

Surface(1) = {1};
node_sur[1] = 1;
border1[0] = -4;
border2[0] = 2;

For n In {2:N}
	//Printf("axon number %g", n);
	i = newp;
	//Printf("newp %g", i);
	Point(i) = {(n-1)*in,0,0,amsh};
	Point(i+1) = {(n-1)*in,-nd,0,amsh};
	Point(i+2) = {(n-1)*in+nl,-nd,0,amsh};
	Point(i+3) = {(n-1)*in+nl,0,0,amsh};
	Point(i+4) = {(n-2)*in+2*nl,mh,0,amsh};
	Point(i+5) = {(n-1)*in-nl,mh,0,amsh};
	Point(i+6) = {(n-2)*in+2*nl,-(nd+mh),0,amsh};
	Point(i+7) = {(n-1)*in-nl,-(nd+mh),0,amsh};

	j = newl;
	//Printf("newl %g", j);
	Line(j) = {i,i+1};
	Line(j+1) = {i+1,i+2};
	Line(j+2) = {i+2,i+3};
	Line(j+3) = {i+3,i};
	Line(j+4) = {i-6,i+1};
	Line(j+5) = {i-5,i};
	Line(j+6) = {i,i+5};
	Line(j+7) = {i+5,i+4};
	Line(j+8) = {i+4,i-5};
	Line(j+9) = {i+1,i+7};
	Line(j+10) = {i+7,i+6};
	Line(j+11) = {i+6,i-6};

	border1[1+(n-2)*4] = -(j+8);
	border1[2+(n-2)*4] = -(j+7);
	border1[3+(n-2)*4] = -(j+6);
	border1[4+(n-2)*4] = -(j+3);
	border2[1+(n-2)*4] = -(j+11);
	border2[2+(n-2)*4] = -(j+10);
	border2[3+(n-2)*4] = -(j+9);
	border2[4+(n-2)*4] = j+1;

	Line Loop(j) = {j,j+1,j+2,j+3};
	//Printf("Line Loop %g %g %g %g", 7+(n-3)*9,j+5,j,-(j+4));
	Line Loop(j+1) = {9+(n-3)*12,j+5,j,-(j+4)};
	Line Loop(j+2) = {j+5,j+6,j+7,j+8};
	Line Loop(j+3) = {j+4,j+9,j+10,j+11};
	//Printf("news %g", j);
	k = news;
	Surface(j) = {j};
	Surface(j+1) = {j+1};
	Surface(j+2) = {j+2};
	Surface(j+3) = {j+3};
	node_sur[n] = j;
	internode_sur[n-2] = j+1;
	myelin_sur1[n-2] = j+2;
	myelin_sur2[n-2] = j+3;

EndFor

Printf("border %g", i+2);

Physical Surface("Nodes", 1) = {node_sur[]};
Physical Surface("Internodes", 2) = {internode_sur[]};
Physical Surface("Myelin", 3) = {myelin_sur1[],myelin_sur2[]};



l = newl;

Line(l) = {6,7};
Line(l+1) = {7,i+2};
Line(l+2) = {i+3,8};
Line(l+3) = {8,5};


Line Loop(l) = {5,border1[],l+2,l+3};
Line Loop(l+1) = {-(l+1),-l,-6,border2[]};
//Printf("myelin_sur %g", myelin_sur[0]);
Plane Surface(l) = {l};
Plane Surface(l+1) = {l+1};

Physical Surface("Extracellular Medium", 4) = {l,l+1};