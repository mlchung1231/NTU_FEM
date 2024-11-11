clc;
clear;
addpath('../distmesh/')
addpath('../FEM_function/')
[p,t] = node_4_mesh(50, 1, 0.5, 0.5);
    
plot_mesh(p,t)

coor = p;
conn = t;

p = p';
t = t';

b_plane_strain = 1;
E = 70e7; 
v = 0.33; 
mate = zeros(3,1);
mate(1) = b_plane_strain;
mate(2) = E;
mate(3) = v;
mate(4) = 0.00073;
mate(5) = 1/2;
mate(6) = 1/2;
mate(7) = 0.0001;
mate(8) = 500;
mate(9) = 1;
mate(10) = 10;


ndime = 2;
nnode = size(p,1);
nelem = size(t,1);
nelnd = 4;

nload = 0;
load = 0;

v = 50;
T_v = 50*0.00073;

% trac = zeros(2, 4);
% trac(1,:) = [100, 2, 0, -T_v/10];
% trac(2,:) = [99, 2, 0, -T_v/10];
% 
% ntrac = 2;
trac = 0;
ntrac = 0;


pres = zeros(4, 3);
pres(1,:) = [1, 1, 0];
pres(2,:) = [1, 2, 0];
pres(3,:) = [301, 1, 0];
pres(4,:) = [301, 2, 0];


npres = size(pres,1);

filename = 'hw5_4_inputfile.h5';
if exist(filename, 'file') == 2
    delete(filename);
end

h5create(filename, '/coor', size(coor));
h5write(filename, '/coor', coor);

h5create(filename, '/conn', size(conn));
h5write(filename, '/conn', conn);

h5create(filename, '/ndime', size(ndime));
h5write(filename, '/ndime', ndime);

h5create(filename, '/mate', size(mate));
h5write(filename, '/mate', mate);

h5create(filename, '/nnode', size(nnode));
h5write(filename, '/nnode', nnode);

h5create(filename, '/nelem', size(nelem));
h5write(filename, '/nelem', nelem);

h5create(filename, '/nelnd', size(nelnd));
h5write(filename, '/nelnd', nelnd);

h5create(filename, '/npres', size(npres));
h5write(filename, '/npres', npres);

h5create(filename, '/pres', size(pres));
h5write(filename, '/pres', pres);

h5create(filename, '/nload', size(nload));
h5write(filename, '/nload', nload);

h5create(filename, '/load', size(load));
h5write(filename, '/load', load);

h5create(filename, '/ntrac', size(ntrac));
h5write(filename, '/ntrac', ntrac);

h5create(filename, '/trac', size(trac));
h5write(filename, '/trac', trac);

