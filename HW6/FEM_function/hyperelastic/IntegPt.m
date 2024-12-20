function xi = IntegPt(ndime,nelnd,M)
    xi = zeros(ndime,M);
    if (ndime == 1)
        xi(1,1) = -0.577350269;
        xi(1,2) = 0.577350269;
    elseif (ndime == 2)
        if (nelnd == 3)
            xi(1,1) = 1/3.;
            xi(2,1) = 1/3.;
        end
        if (nelnd == 6)
            xi(1,1) = 1/3.;
            xi(2,1) = 1/3.;
            xi(1,2) = 0.6;
            xi(2,2) = 0.2;
            xi(1,3) = 0.2;
            xi(2,3) = 0.6;
            xi(1,4) = 0.2;
            xi(2,4) = 0.2;
        end
        if (nelnd == 4)
            xi(1,1) = -0.577350269;
            xi(2,1) = -0.577350269;
            xi(1,2) = 0.577350269;
            xi(2,2) = -0.577350269;
            xi(1,3) = -0.577350269;
            xi(2,3) = 0.577350269;
            xi(1,4) = 0.577350269;
            xi(2,4) = 0.577350269;
        end
        if (nelnd == 8)
            xi(1,1) = -0.774596669;
            xi(2,1) = -0.774596669;
            xi(1,2) = 0;
            xi(2,2) = -0.774596669;
            xi(1,3) = 0.774596669;
            xi(2,3) = -0.774596669;
            xi(1,4) = -0.774596669;
            xi(2,4) = 0;
            xi(1,5) = 0;
            xi(2,5) = 0;
            xi(1,6) = 0.774596669;
            xi(2,6) = 0;
            xi(1,7) = -0.774596669;
            xi(2,7) = 0.774596669;
            xi(1,8) = 0.;
            xi(2,8) = 0.774596669;
            xi(1,9) = 0.774596669;
            xi(2,9) = 0.774596669;
        end

    elseif (ndime == 3)
        if (nelnd == 4) 
        xi(1,1) = 1/4.; 
        xi(2,1) = 1/4.;
        xi(3,1) = 1/4.;
        end
        if (nelnd == 10) 
        alpha = 0.58541020;
        beta = 0.13819660;
        
        xi(1,1) = alpha; 
        xi(2,1) = beta;
        xi(3,1) = beta;
        
        xi(1,2) = beta;
        xi(2,2) = alpha;
        xi(3,2) = beta;
        
        xi(1,3) = beta; 
        xi(2,3) = beta;
        xi(3,3) = alpha;
        
        xi(1,4) = beta; 
        xi(2,4) = beta;
        xi(3,4) = beta;
        end
        if (nelnd == 8) 
        tmp = 0.5773502692;
        xi(1,1) = -tmp;
        xi(2,1) = -tmp;
        xi(3,1) = -tmp;
        xi(1,2) = tmp; 
        xi(2,2) = -tmp;
        xi(3,2) = -tmp;
        xi(1,3) = -tmp; 
        xi(2,3) = tmp;
        xi(3,3) = -tmp;
        xi(1,4) = tmp;
        xi(2,4) = tmp;
        xi(3,4) = -tmp;
        xi(1,5) = -tmp;
        xi(2,5) = -tmp;
        xi(3,5) = tmp;
        xi(1,6) = tmp;
        xi(2,6) = -tmp;
        xi(3,6) = tmp;
        xi(1,7) = -tmp;
        xi(2,7) = tmp;
        xi(3,7) = tmp;
        xi(1,8) = tmp;
        xi(2,8) = tmp;
        xi(3,8) = tmp;
        end
        if (nelnd == 20) 
        tmp = 0.7745966692;
        xi(1,[1,4,7,10,13,16,19,22,25])=-tmp;
        xi(1,[2,5,8,11,14,17,20,23,26])=0;
        xi(1,[3,6,9,12,15,18,21,24,27])=tmp;
        
        xi(2,[1,2,3,10,12,12,19,20,21])=-tmp;
        xi(2,[4,5,6,13,14,15,22,23,24])=0;
        xi(2,[7,8,9,16,17,18,25,26,27])=tmp;
        
        xi(3,[1,2,3,4,5,6,7,8,9])=-tmp;
        xi(3,[10,11,12,13,14,15,16,17,18])=0;
        xi(3,[19,20,21,22,23,24,25,26,27])=tmp;
        end
    end
end