syms y(x)
dydx = y - 3*x^2 + 1;

y_analytical = dsolve(diff(y, x) == dydx, y(0) == 0.5);

y_analytical_func = matlabFunction(y_analytical);

h = 0.005;
x_end = 0.1;
N = x_end / h;

x = 0:h:x_end;
y_Euler = zeros(size(x));

y_Euler(1) = 0.5;

for i = 1:N
    dydx_Euler = y_Euler(i) - 3*x(i)^2 + 1;
    y_Euler(i+1) = y_Euler(i) + h * dydx_Euler;
end

y_analytical_values = y_analytical_func(x);

figure;
plot(x, y_Euler, '-b', 'DisplayName', 'Euler method');
hold on;
plot(x, y_analytical_values, '-r', 'DisplayName', 'Analytical');
xlabel('x');
ylabel('y');
legend;
title('HW1 (3a)');
legend('Location', 'northwest');
grid on;

figure;
plot(x, (y_Euler - y_analytical_values).^2, '-b', ...
    'DisplayName', 'Euler method error');
xlabel('x');
ylabel('square error');
legend;
title('HW1 (3b)');
legend('Location', 'northwest');
grid on;
