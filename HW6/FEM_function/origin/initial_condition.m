function u_x_t0 = initial_condition(x, y, L, h)
    if min(x) ~= 0
        shift = min(x);
        x(:) = x(:) - shift;
    end
    x_num = length(x);
    n = 8;
    u_x_t0 = zeros(x_num*2,1);
    for  i = 1:x_num      
        for k = 1:n
            Cn = ((8*h)/(pi^2*k^2))*sin(k*pi/2);
            u_x_t0(2*i-1) = 0;
            u_x_t0(2*i) = u_x_t0(2*i) + Cn*sin(k*pi*(x(i))/L)*1;
        end
        u_x_t0(2*i) = u_x_t0(2*i) + y(i);
%         u_x_t0(2*i) = u_x_t0(2*i);
    end
    uy = zeros(1,x_num);
    for  i = 1:x_num 
        uy(i) = u_x_t0(2*i);
    end
    idx = find(y(:) == 0);
%     plot(x(:), uy(:), '.')
end