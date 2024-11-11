function [u, frequencies] = mode_shape_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres,nload, load)
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
    mpresroot = sqrtm(mpres);
    mpresrootinv = inv(mpresroot);
    hpres = mpresrootinv*(kpres*mpresrootinv);
    [q,lambda,~] = svd(hpres);
    lambdasort = zeros(ndime*nnode,1);
    for i = 1:ndime*nnode
        lambdasort(i) = lambda(i,i);
    end
    lambdasort = sort(diag(lambda));  
    frequencies = sqrt(lambdasort);   
    
    
    nmod = mate(10);
    if ndime == 2
        nmodrbm = 3;
    else
        nmodrbm = 6;
    end
    
    u = zeros(nnode * ndime, nmod);
    for k = 1:nmod
        for i = 1:nnode * ndime
            if ((lambda(i, i) - lambdasort(nmodrbm + k))^2 < 1e-8)
                ipick = i;
                break;
            end
        end
        u(:, k) = mpresrootinv * q(:, ipick);
    end
    
    u(2, 1) = 0;
    
end