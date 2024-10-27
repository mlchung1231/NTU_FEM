clc;
clear;
addpath('../distmesh/')
fd1 = @hw4_3_1_fd;
fh1 = @hw4_3_1_fh;
fd2 = @hw4_3_2_fd;
fh2 = @hw4_3_2_fh;
pfix1 =[-1,-1;-1,1;1,-1;1,1;1,-0.5;1,0.5;4,0.5;4,-0.5;-0.5,0;0,-0.5;0,0.5;0.5,0];
pfix2 =[-1,-1;-1,1;1,-1;1,1;1,-0.5;1,0.5;4,0.5;4,-0.5;-0.5,-0.5;-0.5,0.5;0.5,-0.5;0.5,0.5];
[p,t] = distmesh_2d( fd1, fh1, 0.05, [-1 -1; 4 1], 500 , pfix1 );
patch( 'vertices', p, 'faces', t, 'facecolor', [.9, .9, .9] )
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('HW4 (3) Mesh');

figure('color','w'); dist_plot(p,t,fd1); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW4 (3) Signed distance function');
figure('color','w'); dist_plot(p,t,fh1); axis equal on; box on; xlabel('X-axis'); ylabel('Y-axis');
colorbar; colormap jet; title('HW4 (3) Mesh density function');


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

nload = 0;
load = 0;

tolerance = 1e-6;
trac_node_10 = find(abs(p(:, 1) - 4) < tolerance );
trac_elem = [];
trac_face = [];
trac_h = [];
trac_v = [];
for i = 1:size(t, 1)
    [Lia, Locb] = ismember(t(i, :), trac_node_10);
    if sum(Lia) == 2
        trac_elem = [trac_elem; i];
        elem_edge_nodei = find(Locb ~= 0);
        if(elem_edge_nodei(1) == 1)
            if(elem_edge_nodei(2) == 2)
                trac_face = [trac_face; 1];
            else
                trac_face = [trac_face; 3];
            end
        else
            trac_face = [trac_face; 2];
        end
        trac_h = [trac_h; 0];
        trac_v = [trac_v; 1000/1];
    end
end

ntrac = size(trac_elem,1);
trac = zeros(ntrac,2+ndime);

for i = 1:ntrac
    trac(i,:) = [trac_elem(i), trac_face(i), trac_h(i), trac_v(i)];
end


pres_node_0 = find(abs(p(:, 1) + 1 ) < tolerance);
pres = zeros(2*size(pres_node_0, 1), 3);
for i = 1:size(pres_node_0, 1)
    pres(2*i-1, 1) = pres_node_0(i, 1);
    pres(2*i-1, 3) = 0.0;
    pres(2*i) = pres(2*i-1, 1);
    pres(2*i-1, 2) = 1.0;
    pres(2*i, 2) = 2.0;
end

npres = size(pres,1);

filename = 'hw4_3_inputfile.h5';
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

function d = hw4_3_1_fd(p)
    d1 = drectangle(p,-1.0,4.0,-1.0,1.0);
    d2 = drectangle(p,1.0,4.0,0.5,1.0);
    d3 = ddiff(d1,d2);
    d4 = drectangle(p,1.0,4.0,-1.0,-0.5);
    d5 = ddiff(d3,d4);
    d6 = dcircle(p,0.0,0.0,0.5);
    d = ddiff(d5,d6);

end

function h = hw4_3_1_fh(p)
   h1 = 0.225+0.4*sqrt((p(:,1)-1).^2+(p(:,2)-0.5).^2);
   h2 = 0.15+0.4*sqrt(sum(p.^2,2));
   h3 = 0.225+0.4*sqrt((p(:,1)-1).^2+(p(:,2)+0.5).^2);
   h = min(min(min(h1,h3),h2),0.5);
end

function d = hw4_3_2_fd(p)
    d1 = drectangle(p,-1.0,4.0,-1.0,1.0);
    d2 = drectangle(p,1.0,4.0,0.5,1.0);
    d3 = ddiff(d1,d2);
    d4 = drectangle(p,1.0,4.0,-1.0,-0.5);
    d5 = ddiff(d3,d4);
    d6 = drectangle(p,-0.5,0.5,-0.5,0.5);
    d = ddiff(d5,d6);

end

function h = hw4_3_2_fh(p)
    h1 = 0.225+0.4*sqrt((p(:,1)+0.5).^2+(p(:,2)-0.5).^2);
    h2 = 0.225+0.4*sqrt((p(:,1)+0.5).^2+(p(:,2)+0.5).^2);
    h3 = 0.225+0.4*sqrt((p(:,1)-0.5).^2+(p(:,2)+0.5).^2);
    h4 = 0.225+0.4*sqrt((p(:,1)-0.5).^2+(p(:,2)-0.5).^2);
    h5 = 0.225+0.4*sqrt((p(:,1)-1).^2+(p(:,2)-0.5).^2);
    h6 = 0.225+0.4*sqrt((p(:,1)-1).^2+(p(:,2)+0.5).^2);
    h = min(min(min(min(min(min(h1,h2),h3),h4),h5),h6),0.5);
end

