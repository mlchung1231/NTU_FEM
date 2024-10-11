clc
clear

f1 = @(x) 6 + 12*x.^3 + 4*x.^6;
f2 = @(x) sin(x).^5;
f3 = @(x, y) 6 - x.^2 + y;
f4 = @(x, y) x.^2 .* exp(x .* y);
f = {f1, f2, f3, f4};

R = cell(4, 4);

a1 = -1; 
b1 = 1; 
R(1,:) = {a1, b1, 0, 0};

a2 = 0;
b2 = 3*pi/4;
R(2,:) = {a2, b2, 0, 0};

xa3 = 0; 
xb3 = 2; 
ya3 = -1; 
yb3 = 1; 
R(3,:) = {xa3, xb3, ya3, yb3};

xa4 = 0; 
xb4 = 2; 
ya4 = @(x) x/2; 
yb4 = 1; 
R(4,:) = {xa4, xb4, ya4, yb4};

Analytical_integral = zeros(4,1);
for i = 1:4
    if i <= 2
        Analytical_integral(i) = integral(f{1,i}, R{i,1}, R{i,2});
    else
        Analytical_integral(i) = integral2(f{1,i}, R{i,1}, R{i,2}, R{i,3}, R{i,4});
    end
end

P = cell(1,3);
W = cell(1,3);

p2 = [0.57735, -0.57735];
w2 = [1, 1];

p3 = [0.774597, 0, -0.774597];
w3 = [5/9, 8/9, 5/9];

p4 = [0.861136, 0.339981, -0.339981, -0.861136];
w4 = [0.347855, 0.652145, 0.652145, 0.347855];

P(1,:) = {p2, p3, p4};
W(1,:) = {w2, w3, w4};


GN_x = cell(4, 3);
GN_y = cell(4, 3);
C_x = zeros(4,1);
C_y = zeros(4,1);
R{4,3} = -1;
for i = 1:4 
    for j = 1:3
        [C_x(i,1), GN_x{i,j}] = region_transform(R{i,1},R{i,2},P{1,j});
        if i >= 3
            [C_y(i,1), GN_y{i,j}] = region_transform(R{i,3},R{i,4},P{1,j});
        end
    end
end

Gaussian_integral = zeros(4,3);
for k = 1:4
    for n = 1:3
        if k <= 2
            Gaussian_integral(k,n) = C_x(k,1) * sum(W{1,n} .* f{1,k}(GN_x{k,n}));
        elseif k <= 3 
            integral_approx = 0;
            for i = 1:length(GN_x{k,n})
                for j = 1:length(GN_y{k,n})
                    integral_approx = integral_approx + f{1,k}(GN_x{k,n}(i), ...
                        GN_y{k,n}(j)) * W{1,n}(i) * W{1,n}(j) * C_x(k,1) * C_y(k,1);
                end
            end
            Gaussian_integral(k,n) = integral_approx;
        else
            integral_approx = 0;
            for i = 1:length(GN_x{k,n})
                x_current = GN_x{k,n}(i);
                y_lower = x_current / 2;
                y_upper = 1;
                [y_c, y_points] = region_transform(y_lower,y_upper,P{1,n});
                for j = 1:length(GN_y{k,n})
                    integral_approx = integral_approx + f{1,k}(x_current, y_points(j)) * ...
                        W{1,n}(i) * W{1,n}(j) * C_x(k,1) * y_c; 
                end
            end
            Gaussian_integral(k,n) = integral_approx;
        end
    end
end


for i = 1:4
    fprintf('第%d題 Analytical Integral is %.4f\n', i, Analytical_integral(i));
    for j = 1:3
        fprintf('第%d題 %d階Gaussian Integral is %.4f\n', i, j+1, Gaussian_integral(i,j));
    end
    fprintf('\n');
end



function [const, points_transformed] = region_transform(a, b, points)
    const = (b - a) / 2;
    points_transformed = (b - a) / 2 * points + (a + b) / 2;
end


