clc;
clear;
addpath('../distmesh/')
drectangle = @(p,x1,x2,y1,y2) -min(min(min(-y1+p(:,2),y2-p(:,2)),-x1+p(:,1)),x2-p(:,1));
fd = @(p) drectangle(p,0,100,0,30);
fh = @(p) ones(size(p,1),1);
[p,t] = distmesh_2d( fd, fh, 2, [0,0;100,30], 500 , [0,0;0,30;100,0;100,30] );
patch( 'vertices', p, 'faces', t, 'facecolor', [.9, .9, .9] )
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('HW4 (1) Mesh');

figure('color','w'); dist_plot(p,t,fd); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW4 (1) Signed distance function');
figure('color','w'); dist_plot(p,t,fh); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW4 (1) Mesh density function');


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

nload = 1;
load = [4, 0, -500];
% nload = 0;
% load = 0;

tolerance = 1e-3;
% trac_node_10 = find(abs(p(:, 1) - 100) < tolerance );
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
%         trac_h = [trac_h; 0];
%         trac_v = [trac_v; -500/30];
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

pres_node_0 = find(abs(p(:, 1)) < tolerance);
pres = zeros(2*size(pres_node_0, 1), 3);
for i = 1:size(pres_node_0, 1)
    pres(2*i-1, 1) = pres_node_0(i, 1);
    pres(2*i-1, 3) = 0.0;
    pres(2*i) = pres(2*i-1, 1);
    pres(2*i-1, 2) = 1.0;
    pres(2*i, 2) = 2.0;
end

npres = size(pres,1);

filename = 'hw4_1_inputfile.h5';
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

