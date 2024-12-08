function rglob = GlobTrac(ndime,nnode,nelem,nelnd,ntrac,mate,coor,conn,trac)
    rglob = zeros(ndime*nnode,1);
    for j = 1:ntrac
        rel = ElemTrac(j,coor,conn,trac);
        iel = trac(j, 1);
        ia = zeros(2,1);
        if(trac(j, 2) == 1)
            ia(1) = 1;
            ia(2) = 2;
        elseif(trac(j, 2) == 2)
            ia(1) = 2;
            ia(2) = 3;
        else
            ia(1) = 3;
            ia(2) = 1;
        end
        for a = 1:2
            for i = 1:2
                ir = ndime*(conn(ia(a),iel)-1)+i;
                rglob(ir) = rglob(ir)+rel(ndime*(a-1)+i);
            end
        end
    end
end