clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw5_2_inputfile.h5');

[uglob, deflection] = displacement_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);
[uglob_sl, deflection_sl] = displacement_find_sl(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

deflection_v = zeros(size(coor, 2), 1);
deflection_sl_v = zeros(size(coor, 2), 1);
for i = 1:size(coor, 2)
    deflection_v(i,1) = abs(uglob(2*i, 1));
    deflection_sl_v(i,1) = abs(uglob_sl(2*i, 1));
end
deflection_v = deflection_v / 0.01 * 1e3;
deflection_sl_v = deflection_sl_v / 0.01 * 1e3;

fprintf('Max deflection without shear locking %.4f mm.\n',max(deflection_v));
fprintf('Max deflection with shear locking %.4f mm.\n',max(deflection_sl_v));

plot_displacement(coor, conn, deflection_v)
plot_displacement(coor, conn, deflection_sl_v)

