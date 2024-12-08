clc;
clear;
addpath('../distmesh/')
fd1 = @hw6_2_fd;
fh1 = @hw6_2_fh;
pfix =[-6,0;-6,1;6,0;6,1;0,0;0,1];
[p,t] = distmesh_2d( fd1, fh1, 0.2, [-6 0; 6 1], 500 , pfix );
patch( 'vertices', p, 'faces', t, 'facecolor', [.9, .9, .9] )
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('HW6 (1) Mesh');

figure('color','w'); dist_plot(p,t,fd1); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW6 (2) Signed distance function');
figure('color','w'); dist_plot(p,t,fh1); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW6 (2) Mesh density function');


b_plane_strain = 1;
E = 70e9; 
v = 0.33; 
rho = 0;
B1 = 0.5;
B2 = 0.5;
dt = 0.001;
nstp = 200;
nprt = 1;
S0 = 7;
e0 = 0.12;
nho = 10;
nstpho = 100;
nprtho = 1;

mate = zeros(14,1);
mate(1) = b_plane_strain;
mate(2) = E;
mate(3) = v;
mate(4) = rho;
mate(5) = B1;
mate(6) = B2;
mate(7) = dt;
mate(8) = nstp;
mate(9) = nprt;
mate(10) = S0;
mate(11) = e0;
mate(12) = nho;
mate(13) = nstpho;
mate(14) = nprtho;

ndime = 2;
nnode = size(p,1);
nelem = size(t,1);
nelnd = 3;

coor = p';
conn = t';

nload = 0;
load = 0;

tolerance = 1e-3;
% trac_node_10 = find(abs(p(:, 1) - 4) < tolerance );
% trac_elem = [];
% trac_face = [];
% trac_h = [];
% trac_v = [];
% for i = 1:size(t, 1)
%     [Lia, Locb] = ismember(t(i, :), trac_node_10);
%     if sum(Lia) == 2
%         trac_elem = [trac_elem; i];
%         elem_edge_nodei = find(Locb ~= 0);
%         if(elem_edge_nodei(1) == 1)
%             if(elem_edge_nodei(2) == 2)
%                 trac_face = [trac_face; 1];
%             else
%                 trac_face = [trac_face; 3];
%             end
%         else
%             trac_face = [trac_face; 2];
%         end
%         trac_h = [trac_h; 1000/1];
%         trac_v = [trac_v; 0];
%     end
% end
% 
% ntrac = size(trac_elem,1);
% trac = zeros(ntrac,2+ndime);
% 
% for i = 1:ntrac
%     trac(i,:) = [trac_elem(i), trac_face(i), trac_h(i), trac_v(i)];
% end
ntrac = 0;
trac = 0;



% pres_node_y1 = find(abs(p(:, 2) - 1 ) < tolerance);
pres = zeros(4, 3);
pres(1,:) = [1, 1, 0];
pres(2,:) = [1, 2, 0];
pres(3,:) = [3, 2, 0];
pres(4,:) = [6, 2, -6];


% for i = 1:size(pres_node_y1, 1)
%     pres(i+3, 1) = pres_node_y1(i, 1);
%     pres(i+3, 2) = 2;
%     pres(i+3, 3) = -0.5;
% end


npres = size(pres,1);


filename = 'hw6_2_inputfile.h5';
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

function d = hw6_2_fd(p)
    d = drectangle(p,-6,6,0,1);
end

function h = hw6_2_fh(p)
    np = size(p, 1);
    h = ones(np, 1);
end

