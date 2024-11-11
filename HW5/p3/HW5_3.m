clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw5_3_inputfile.h5');

displacement_find_t(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

exact_sol();


