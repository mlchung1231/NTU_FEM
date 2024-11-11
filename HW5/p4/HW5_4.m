clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw5_4_inputfile.h5');

[modes_u, frequencies] = mode_shape_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

coor_new = coor;


for j = 1:5
    for i = 1:size(coor,2)
        coor_new(1,i) = coor_new(1,i) + modes_u(2*i-1,j);
        coor_new(2,i) = coor_new(2,i) + modes_u(2*i,j);
        
    end
    wn = ((j^2*pi^2)/50^2) * sqrt((mate(2)*0.0833)/(mate(4)*1));
    fprintf('\nw%d:\n',j);
    fprintf('exact solution: %.0f Hz\n',wn);
    fprintf('FEM solution: %.0f Hz\n',frequencies(j+4,1));

    plot_mesh(coor_new, conn);
end










