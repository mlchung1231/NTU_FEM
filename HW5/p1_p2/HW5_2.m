clc;
clear;

addpath('../FEM_function/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw5_2_inputfile.h5');

[uglob, deflection] = displacement_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);
[uglob_sl, deflection_sl] = displacement_find_sl(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload,load);

uglob = uglob / 0.01;
uglob_sl = uglob_sl / 0.01;

deflection_v = zeros(size(coor, 2), 1);
deflection_sl_v = zeros(size(coor, 2), 1);
for i = 1:size(coor, 2)
    deflection_v(i,1) = abs(uglob(2*i, 1));
    deflection_sl_v(i,1) = abs(uglob_sl(2*i, 1));
end

fprintf('Max deflection without shear locking %.3f mm.\n', max(deflection_v)*1e3);
fprintf('Max deflection with shear locking %.3f mm.\n', max(deflection_sl_v)*1e3);

plot_displacement(coor, conn, deflection_v)
plot_displacement(coor, conn, deflection_sl_v)

coor_new = coor;
coor_new_sl = coor;
for i = 1:size(coor,2)
    coor_new(2,i) = coor_new(2,i) + uglob(2*i,1);
    coor_new_sl(2,i) = coor_new_sl(2,i) + uglob_sl(2*i,1);
end

plot_mesh(coor_new, conn);
plot_mesh(coor_new_sl, conn);


