clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw4_1_inputfile.h5');

[uglob, deflection] = displacement_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

fprintf('Max deflection is %.3f mm.\n',deflection(4,1)*30e+6);

