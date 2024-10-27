clc;
clear;
addpath('../distmesh/')
fd = @hw4_2_fd;
fh = @hw4_2_fh;
[p,t] = distmesh_2d( fd, fh, 20, [-200 -200; 200 200], 500 , [-200,0;0,-200;0,200;200,0;-100,0;0,-100;0,100;100,0] );
patch( 'vertices', p, 'faces', t, 'facecolor', [.9, .9, .9] )
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('HW4 (2) Mesh');

figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW4 (2) Signed distance function');
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW4 (2) Mesh density function');


b_plane_strain = 1;
E = 70e9; 
v = 0.3; 
mate = zeros(3,1);
mate(1) = b_plane_strain;
mate(2) = E;
mate(3) = v;

ndime = 2;
nnode = size(p,1);
nelem = size(t,1);
nelnd = 3;

coor = p';
conn = t';

r_inner = 100;
r_outer = 200;
tolerance = 0.01;
P_a = -700e6;
P_b = 1e9;
load_hv = zeros(3, size(coor,2)); 
node_out = floor((size(coor, 2) * 2) / 3);
node_in = floor(size(coor, 2) / 3);

nload = 8;
load = [1, -1e9, 0; 
        5, 700e6, 0;
        2, 0, -1e9;
        6, 0, 700e6;
        3, 0, 1e9;
        7, 0 -700e6;
        4, 1e9, 0;
        8, -700e6, 0];
% for i = 1:size(coor, 2)
%     distance = sqrt(coor(1, i)^2 + coor(2, i)^2);
%     load_hv(1,i) = i;
%     if abs(distance - r_inner) <= tolerance
%         Fx = (coor(1, i) / r_inner) * P_a; 
%         Fy = (coor(2, i) / r_inner) * P_a; 
%         load_hv(2, i) = Fx/node_in; 
%         load_hv(3, i) = Fy/node_in;
%         
%         
%     elseif abs(distance - r_outer) <= tolerance
%         Fx = (coor(1, i) / r_outer) * P_b; 
%         Fy = (coor(2, i) / r_outer) * P_b; 
%         load_hv(2, i) = Fx/node_out; 
%         load_hv(3, i) = Fy/node_out; 
%         
%     end
% end
% 
% load = load_hv';
% nload = size(load,1);

npres = 0;
pres = 0;

ntrac = 0;
trac = 0;

filename = 'hw4_2_inputfile.h5';
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

function d = hw4_2_fd(p)
    d1 = dcircle(p,0.0,0.0,200);
    d2 = dcircle(p,0.0,0.0,100);
    d = ddiff(d1,d2);
end

function h = hw4_2_fh(p)
    h = ones(size(p,1),1);
end

