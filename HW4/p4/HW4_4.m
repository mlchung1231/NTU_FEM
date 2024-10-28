clc;
clear;
addpath('../FEM_function/');
infile = fopen("circular_plate.txt");
[ndime,nnode,nelem,nelnd,npres,mate,coor,conn,pres,ntrac,trac] = ReadInput_txt(infile);
plot_mesh_3D(coor,conn);
fclose(infile);

radius = 0.5;
center = 2*radius^2;
tolerance = 1e-4;
fixed_nodes = [];
for i = 1:size(coor, 2)
    x = coor(1, i);
    y = coor(2, i);
    z = coor(3, i);

    if abs((x^2 + y^2 - radius^2)) < tolerance
        fixed_nodes = [fixed_nodes, i];
    end
    if z == 0.0
        if (x^2 + y^2) < center
            center = x^2 + y^2;
            center_node = i;
        end 
    end
end
pres = zeros(3*size(fixed_nodes,2), 3);
for i = 1:size(fixed_nodes,2)
    pres(3*i-2, :) = [fixed_nodes(i), 1, 0];
    pres(3*i-1, :) = [fixed_nodes(i), 2, 0];
    pres(3*i, :) = [fixed_nodes(i), 3, 0];
end
npres = size(pres,1);

for i = 1:size(coor, 2)
    x = coor(1, i);
    y = coor(2, i);
    z = coor(3, i);
    if z == 0 
        if (x^2 + y^2 - radius^2) < tolerance
            fixed_nodes = [fixed_nodes, i];
        end
    end
end

nload = 1;
load = [center_node, 0.0, 0.0, -1000];


[uglob, total_de] = displacement_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

deflection = zeros(size(coor, 2), 1);
for i = 1:size(coor, 2)
    deflection(i,1) = abs(uglob(3*i, 1));
end
fprintf("Max vertical deflection is %f mm.\n",max(deflection)*1e3);