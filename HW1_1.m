f = @(x) 4 * cos(x) - 2;

a = 0;
b = pi;

integral_exact = integral(f, a, b);

n_values = 1:1000;
errors = zeros(length(n_values), 1);


for k = 1:length(n_values)
    n = n_values(k);  
    h = (b - a) / n;  
    x = linspace(a, b, n+1);  
    y = f(x);  

    integral_trapezoid = (h/2) * (y(1) + 2*sum(y(2:end-1)) + y(end));

    errors(k) = (integral_trapezoid - integral_exact) ^2;
end

figure;
plot(1./n_values, errors, 'b-');
xlabel('step size');
ylabel('error');
title('HW1 (1a)');
ylim([0, 1e-9])
set(gca, 'XDir', 'reverse');
set(gca, 'XScale', 'log');
grid on;

x_plot = linspace(a, b, 100);
y_plot = f(x_plot);
figure;
plot(x_plot, y_plot, 'b-');
xlabel('x');
ylabel('f(x)');
title('HW (1b)');
xlim([a, b])
grid on;


