clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw4_2_inputfile.h5');

[uglob, displacement] = displacement_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

fprintf('Out Max displacement is %.3f mm.\n',displacement(1,1)*100/(2*pi));
fprintf('In Max displacement is %.3f mm.\n',displacement(6,1)*100/(2*pi));

