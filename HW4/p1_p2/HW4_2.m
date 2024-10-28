clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw4_2_inputfile.h5');

[uglob, displacement] = displacement_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

outer_u = 0;
inner_u = 0;
tolerance = 1e-3;
for i = 1:4
    outer_u = outer_u + displacement(i,1);
    inner_u = inner_u + displacement(i+4,1);
end

outer_u = outer_u / 4;
inner_u = inner_u / 4;

fprintf('u(a) is %.3f mm.\n',inner_u*100);
fprintf('u(b) is %.3f mm.\n',outer_u*100);

