clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw4_3_inputfile.h5');

[uglob, stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

stress_val = zeros(1,nelem);
for i = 1:nelem
    stress_val(i) = sqrt(sum(stress_glob{i}(:).^2));  
end
[max_stress, max_index] = max(stress_val);
plot_stress(coor, conn, stress_val, max_index);