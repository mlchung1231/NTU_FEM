clc;
clear;
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw2_3_inputfile.h5');

[uglob, Stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres);

Stress_val = zeros(1,nelem);
for i = 1:nelem
    Stress_val(i) = sqrt(sum(Stress_glob{i}(:).^2));  
end
max_stress = max(Stress_val);
max_stress = max_stress/5;