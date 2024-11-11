function exact_sol()
    h = 0.01;
    c0 = 9365.8581;
    L = 50;        
    x = 25;      
    dt = 0.0001; 
    num_iterations = 250; 
    N = 10;      
    
    y_values = zeros(1, num_iterations);
    t_values = (0:num_iterations-1) * dt; 
    
    for k = 1:num_iterations
        t = t_values(k);
        y_xt = 0; 
        
        for n = 1:N
            term = (8 * h / (pi^2 * n^2)) * sin(n * pi / 2) * cos(n * c0 * pi * t / L) * sin(n * pi * x / L);
            y_xt = y_xt + term;
        end
        
        y_values(k) = y_xt; 
    end
    
    figure;
    plot(t_values, y_values);
    xlabel('t');
    ylabel('y(t)');
    title('Exact Solutions:  y(t) at L/2');
    grid on;
end