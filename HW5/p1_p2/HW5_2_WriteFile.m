clc;
clear;
addpath('../distmesh/')
addpath('../FEM_function/')
[p,t] = node_4_mesh(0.5, 0.01, 0.0025, 0.0025);
plot_mesh(p,t)

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


ndime = 2;
nnode = size(p,1);
nelem = size(t,1);
nelnd = 4;

% nload = 1;
% load = [4, 0, -500];
nload = 0;
load = 0;

tolerance = 1e-3;
trac_node_10 = find(abs(p(:, 2) - 0.01) < tolerance );
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
        trac_v = [trac_v; -1000];
    end
end

ntrac = size(trac_elem,1);
trac = zeros(ntrac,2+ndime);

for i = 1:ntrac
    trac(i,:) = [trac_elem(i), trac_face(i), trac_h(i), trac_v(i)];
end
% ntrac = 0;
% trac = 0;

pres = zeros(3, 3);
pres(1,:) = [1, 1, 0];
pres(2,:) = [1, 2, 0];
for i = 1:size(p, 1)
    if p(i,1) == 0.5 && p(i,2) == 0
        pres(3,:) = [i, 2, 0];
    end
end

npres = size(pres,1);

filename = 'hw5_2_inputfile.h5';
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

