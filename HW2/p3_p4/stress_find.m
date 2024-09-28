function [uglob, Stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres)
    [kglob, Bglob, Dglob] = GlobStif(ndime,nnode,nelem,nelnd,mate,coor,conn);
    rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac);
    kpres= kglob;
    rpres= rglob;
    for i = 1:npres
        idof = ndime*(pres(1,i)-1)+pres(2,i);
        for ir = 1:ndime*nnode
            kpres(ir,idof) = 0;
            rpres(ir) = rpres(ir) - kglob(ir,idof)*pres(3,i);
        end
    end
    for i = 1:npres
        idof = ndime*(pres(1,i)-1)+pres(2,i);
        kpres(idof,:) = 0;
        kpres(idof,idof) = 1;
        rpres(idof) = pres(3,i);
    end
    uglob = kpres\rpres;
    uel = zeros(6,1);
    for j = 1:nelem
        Bel = Bglob{j};
        Del = Dglob{j};
        uel(1:2,1) = [uglob(2*conn(1,j)-1, 1),uglob(2*conn(1,j), 1)];
        uel(3:4,1) = [uglob(2*conn(2,j)-1, 1),uglob(2*conn(2,j), 1)];
        uel(5:6,1) = [uglob(2*conn(3,j)-1, 1),uglob(2*conn(3,j), 1)];
        strain = Bel * uel;
        Stress_glob{j} = Del * strain;
    end
end