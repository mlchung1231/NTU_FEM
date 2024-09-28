clc;
clear;
drectangle = @(p,x1,x2,y1,y2) -min(min(min(-y1+p(:,2),y2-p(:,2)),-x1+p(:,1)),x2-p(:,1));
fd = @(p) max( drectangle(p,-45,45,-45,45), -(sqrt(sum(p.^2,2))-9) );
fh1 = @(p) 0.8 + 0.1*(sqrt(sum(p.^2,2))-9);
fh2 = @(p) ones(size(p,1),1);
[p,t] = distmesh( fd, fh2, 1, [-45,-45;45,45], [-1,-1;-1,1;1,-1;1,1] );
patch( 'vertices', p, 'faces', t, 'facecolor', [.9, .9, .9] )
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('Rectangle with a Circular Hole');


b_plane_strain = 1;
E = 200e9; 
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

npres = 0;
pres = 0;

nload = 0;
load = 0;

trac_node_neg45 = find(p(:, 1) == -45);
trac_elem = [];
trac_face = [];
trac_h = [];
trac_v = [];
for i = 1:size(t, 1)
    [Lia, Locb] = ismember(t(i, :), trac_node_neg45);
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
        trac_h = [trac_h; 1000/90];
        trac_v = [trac_v; 0];
    end
end

trac_node_45 = find(p(:, 1) == 45);
for i = 1:size(t, 1)
    [Lia, Locb] = ismember(t(i, :), trac_node_45);
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
        trac_h = [trac_h; -1000/90];
        trac_v = [trac_v; 0];
    end
end
ntrac = size(trac_elem,1);
trac = zeros(ntrac,2+ndime);

for i = 1:ntrac
    trac(i,:) = [trac_elem(i), trac_face(i), trac_h(i), trac_v(i)];

end

filename = 'hw2_3_inputfile.h5';
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

