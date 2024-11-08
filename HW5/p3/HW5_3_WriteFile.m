clc;
clear;
addpath('../distmesh/')
addpath('../FEM_function/')
[p,t] = node_4_mesh(50, 0.01, 0.1, 0.01);
h = 0.01;
nv_node = 0.1/0.1 + 1;
for i = 1:(size(p,2)/nv_node)
    if i <= ((size(p,2)/nv_node) + 1)/2
        plus_h = h*(i-1)*0.1/25;
        p(2,i*nv_node) = p(2,i*nv_node) + plus_h;
        p(2,i*nv_node -1) = p(2,i*nv_node -1) + plus_h;
        %p(2,i*nv_node -2) = p(2,i*nv_node -2) + plus_h;
    else
        plus_h = (-h*(i-1)*0.1/25) + 2*h;
        p(2,i*nv_node) = p(2,i*nv_node) + plus_h;
        p(2,i*nv_node -1) = p(2,i*nv_node -1) + plus_h;
        %p(2,i*nv_node -2) = p(2,i*nv_node -2) + plus_h;
    end
    
end

p(2,:) = p(2,:) - 0.005;
    

plot_mesh_p3(p,t)

coor = p;
conn = t;

p = p';
t = t';

b_plane_strain = 1;
E = 70e9; 
v = 0.3; 
mate = zeros(3,1);
mate(1) = b_plane_strain;
mate(2) = E;
mate(3) = v;
mate(4) = 1.14*1e-3;
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

% nload = 1;
% load = [4, 0, -500];
nload = 0;
load = 0;


% trac_v = (10 * 0.01/(sqrt(25^2+0.01^2)))/(sqrt(25^2+0.01^2));
% trac_h = (10 * 25/(sqrt(25^2+0.01^2)))/(sqrt(25^2+0.01^2));
% trac = zeros(size(conn,2), 4);
% for i = 1:size(conn, 2)
%     trac(i,1) = i;
%     trac(i,2) = 3;
%     trac(i,4) = -trac_v;
%     if i <= size(conn, 2)/2
%         trac(i,3) = -trac_h;
%     else
%         trac(i,3) = trac_h;
%     end
% end
% 
% ntrac = size(conn,2);

trac_v = (10 * 0.01/(sqrt(25^2+0.01^2)))/(0.01);
trac_h = (10 * 25/(sqrt(25^2+0.01^2)))/(0.01);
trac = zeros(2, 4);
trac(1,:) = [1, 4, -trac_h, -trac_v];
trac(2,:) = [500, 2, trac_h, -trac_v];

ntrac = 2;


pres = zeros(8, 3);
pres(1,:) = [1, 1, 0];
pres(2,:) = [1, 2, 0];
pres(3,:) = [2, 1, 0];
pres(4,:) = [2, 2, 0];
pres(5,:) = [1001, 1, 0];
pres(6,:) = [1001, 2, 0];
pres(7,:) = [1002, 1, 0];
pres(8,:) = [1002, 2, 0];
for i = 1:size(p, 1)
    if p(i,1) == 0.5 && p(i,2) == 0
        pres(3,:) = [i, 2, 0];
    end
end

npres = size(pres,1);

filename = 'hw5_3_inputfile.h5';
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

