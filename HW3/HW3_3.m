clc;
clear;

addpath('./distmesh/')

filename = 'hw3_3';
fd = @hw3_3_fd;
fh = @hw3_3_fh;
h = 0.1;
meshbox = [0, 0, 0; 4, 1, 1];
iteration_max = 500;
fixed = [0,0,0;0,0,1;0,1,0;0,1,1;0.5,0,0;0.5,1,0;1.5,0,0;1.5,1,0;
    2.5,0,0;2.5,1,0;3.5,0,0;3.5,1,0;4,0,0;4,0,1;4,1,0;4,1,1];
[p,t] = distmesh_3d(fd,fh,h,meshbox,iteration_max,fixed);

coor = p';
conn = t';

figure('color','w'); plotmesh(coor,conn,filename); title('HW3 (3) Mesh');


filename = 'hw3_3_inputfile.h5';
if exist(filename, 'file') == 2
    delete(filename);
end

h5create(filename, '/coor', size(coor));
h5write(filename, '/coor', coor);

h5create(filename, '/conn', size(conn));
h5write(filename, '/conn', conn);

function d = hw3_3_fd(p)
    
    y1 = -(p(:,2)-(-1));
    y2 = -(1-p(:,2));
    rect = -min(min(min(min(min(-0.0+p(:,3),1.0-p(:,3)), ...
        -0.0+p(:,2)),1.0-p(:,2)),-0.0+p(:,1)),4.0-p(:,1));
    r_m1 = -(0.5-sqrt((p(:,1)-(1)).^2+(p(:,3)-(0)).^2));
    r_m2 = -(0.5-sqrt((p(:,1)-(3)).^2+(p(:,3)-(0)).^2));
    d0 = max(y1,y2);
    d1 = max(d0, -r_m1);
    d2 = max(d1,-r_m2);
    d3 = max(rect, d2);
    d = d3;
end

function h = hw3_3_fh(p)
    np = size(p, 1);
    h = ones(np, 1);
end
