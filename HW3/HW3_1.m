clc;
clear;

addpath('./FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw3_1_inputfile.h5');

[uglob, Stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres);

Stress_val = zeros(1,nelem);
for i = 1:nelem
    Stress_val(i) = sqrt(sum(Stress_glob{i}(:).^2));  
end
Stress_val = Stress_val./5;
[max_stress, max_index] = max(Stress_val);
fprintf('max stress is %.2f MPa\n', max_stress);

plot_stress(coor, conn, Stress_val, max_index);
