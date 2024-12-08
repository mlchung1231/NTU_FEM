clc;
clear;

%addpath('../FEM_function/')
addpath('../FEM_function/hypoelastic/')
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw6_4_inputfile.h5');

rglob = GlobTrac(ndime, nnode, nelem, nelnd, ntrac, coor, conn, trac);

nstpho = mate(13);  
tol = 1e-4;  
maxit = 100;  
wglob = zeros(nnode * ndime, 1); 
e_plot = [];
s_plot = [];
e_plot = [e_plot, 0];
s_plot = [s_plot, 0];
for i = 2:nstpho+1
    faci = (i-1) / nstpho;  
    erri = tol * 100;  
    niti = 0;  
    disp(['Step: ' num2str(i) ', factor: ' num2str(faci)]);

    while (erri > tol && niti < maxit)  
        niti = niti + 1;
        kglob = GlobStif(ndime, nnode, nelem, nelnd, mate, coor, conn, wglob);
        diagIndices_k = 1:min(size(kglob));  
        for dik = diagIndices_k
            if kglob(dik, dik) == 0
                kglob(dik, dik) = 1e-9;
            end
        end
        fglob = GlobResi(ndime, nnode, nelem, nelnd, mate, coor, conn, wglob);
        bglob = faci * rglob - fglob;

        for j = 1:npres
            ir = ndime * (pres(j,1) - 1) + pres(j,2);  
            for ic = 1:ndime * nnode
                kglob(ir, ic) = 0;  
            end
            kglob(ir, ir) = 1;  
            bglob(ir) = -wglob(ir) + faci * pres(j,3);  
        end

        dwglob = kglob \ bglob;  
        dwglobsq = dwglob.' * dwglob;  

        wglob = wglob + dwglob;

        wglobsq = wglob.' * wglob;  
        erri = sqrt(dwglobsq / wglobsq);  
        %disp(['Iter: ' num2str(niti) ', err: ' num2str(erri)]);
    end

    if mod(i,25) == 0
        coor_new = coor;
        for i_new = 1:size(coor,2)
            coor_new(1,i_new) = coor_new(1,i_new) + wglob(2*i_new-1,1);
            coor_new(2,i_new) = coor_new(2,i_new) + wglob(2*i_new,1);
        end
        
        plot_mesh(coor_new, conn);
    end
    disp(num2str(wglob(22,1)));
    disp(num2str(fglob(22,1)));


    e_plot = [e_plot, abs(wglob(12,1))];
    s_plot = [s_plot, 40*abs(fglob(12,1))];
end
figure(5);
plot(e_plot, s_plot);
xlabel('Strain');
ylabel('Stress (MPa)'); 
title('Stress-Strain curve (FEM)');
grid on;