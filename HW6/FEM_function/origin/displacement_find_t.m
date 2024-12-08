function displacement_find_t(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload, load)
    mglob = GlobMass(ndime,nnode,nelem,nelnd,mate,coor,conn);
    [kglob, Cglob, Bglob] = GlobStif_sl(ndime,nnode,nelem,nelnd,mate,coor,conn);
    rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac);
    if ndime == 2
        for i = 1:nload
            rglob(2*load(i, 1)) = load(i, 3);
        end
    else
        for i = 1:nload
            rglob(2*load(i, 1)) = load(i, 4);
        end
    end
    diagIndices = 1:min(size(kglob));  
    for i = diagIndices
        if kglob(i, i) == 0
            kglob(i, i) = 1e-9;
        end
    end
    mpres = mglob;
    kpres= kglob;
    rpres= rglob;
    for i = 1:npres
        %idof = ndime*(pres(i,1)-1)+pres(i,2);
        ir = ndime*(pres(i,1)-1)+pres(i,2);
        for ic = 1:ndime*nnode
            mpres(ir,ic) = 0;
            mpres(ic,ir) = 0;
            kpres(ir,ic) = 0;
            kpres(ic,ir) = 0;
        end
        mpres(ir,ir) = 1.;
        rpres(ir) = pres(i,3);
    end
    beta1 = mate(5);
    beta2 = mate(6);
    dt = mate(7);
    nstp = mate(8);
    nprt = mate(9);
    vc = zeros(nnode*ndime,1);
    uc = zeros(nnode*ndime,1);
    for i = 1:size(coor,2)
        uc(2*i-1,1) = 0;
        uc(2*i,1) = coor(2,i);
    end
    mkpres = mpres+0.5*beta2*dt*dt*kpres;
    ac = mkpres\(-kpres*uc+rpres);
    iprt = 0;
    t_plot = [];
    uy_plot = [];
    for i = 1:nstp
        an = mkpres\(rpres-kpres*(uc+dt*vc+0.5*(1.-beta2)*dt*dt*ac));
        vn = (vc+dt*(1.-beta1)*ac+dt*beta1*an);
        un = (uc+dt*vc+(1.-beta2)*0.5*dt*dt*ac+0.5*beta2*dt*dt*an);
        if i == 1
            fprintf('%d : y=%.8f\n',i,0.01)
        else
            fprintf('%d : y=%.8f\n',i,uc(size(coor,2),1))
        end
        t_plot = [t_plot, i*0.00005];
        uy_plot = [uy_plot, uc(size(coor,2),1)];
        ac = an;
        vc = vn;
        uc = un;
    end
    uy_plot(1) = 0.01;
    plot(t_plot, uy_plot);
    xlabel('t');
    ylabel('y(t)'); 
    title('y(t) at L/2');
    grid on;
end