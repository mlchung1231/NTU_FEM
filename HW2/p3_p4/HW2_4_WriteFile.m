clc;
clear;
fd = @fshaped;
fh = @uniform_mesh;
[p,t] = distmesh( fd, fh, 2, [-90,-45;90,45], [-1,-1;-1,1;1,-1;1,1] );
patch( 'vertices', p, 'faces', t, 'facecolor', [.9, .9, .9] )
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('HW2 (4) mesh');


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

trac_node_neg90 = find(p(:, 1) == -90);
trac_elem = [];
trac_face = [];
trac_h = [];
trac_v = [];
for i = 1:size(t, 1)
    [Lia, Locb] = ismember(t(i, :), trac_node_neg90);
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

trac_node_90 = find(p(:, 1) == 90);
for i = 1:size(t, 1)
    [Lia, Locb] = ismember(t(i, :), trac_node_90);
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
        trac_h = [trac_h; -1000/60];
        trac_v = [trac_v; 0];
    end
end
ntrac = size(trac_elem,1);
trac = zeros(ntrac,2+ndime);

for i = 1:ntrac
    trac(i,:) = [trac_elem(i), trac_face(i), trac_h(i), trac_v(i)];

end

filename = 'hw2_4_inputfile.h5';
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


function d = fshaped(p)

    rect1 = drectangle(p , -90, 90, -45, 45);
    rect2 = drectangle(p , 0, 91, 30, 46);
    rect3 = drectangle(p , 0, 91, -46, -30);
    small_rect1 = drectangle(p , 0, 9, 30, 39);
    small_rect2 = drectangle(p , 0, 9, -39, -30);
    
    cir1 = dcircle(p, 9, 39, 9);
    cir2 = dcircle(p, 9, -39, 9);
    d = min(min(max(max(rect1, -rect2), -rect3), small_rect1), small_rect2);
    d = ddiff(d, cir1);
    d = ddiff(d, cir2);
end

function h = uniform_mesh(p)
    np = size(p, 1);
    h = ones(np, 1);
end

function d = drectangle ( p, x1, x2, y1, y2 )
  d = - min ( min ( min ( -y1+p(:,2), y2-p(:,2) ), -x1+p(:,1) ), x2-p(:,1) );

  return
end

function d = dcircle ( p, xc, yc, r )
  d = sqrt ( ( p(:,1) - xc ).^2 + ( p(:,2) - yc ).^2 ) - r;

  return
end
function d = ddiff ( d1, d2 )
  d = max ( d1, -d2 );

  return
end
