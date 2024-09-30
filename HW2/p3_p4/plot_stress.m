function plot_stress(coor, conn, Stress_val, max_index)
figure;
hold on;
default_color = [0.3, 0.3, 0.3]; 
max_stress_color = [1, 0, 0];  
for i = 1:size(conn, 2)
    triangle_vertices = coor(:, conn(:, i));
    if i == max_index
        patch('Vertices', triangle_vertices', 'Faces', [1, 2, 3], 'FaceColor', ...
            max_stress_color, 'EdgeColor', 'none');
    else
        patch('Vertices', triangle_vertices', 'Faces', [1, 2, 3], 'FaceColor', ...
            default_color, 'EdgeColor', 'none');
    end
end
hold off;
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('Maximum Stress Position');


Stress_normalized = (Stress_val - min(Stress_val)) / (max(Stress_val) - min(Stress_val));
figure;
hold on;
for i = 1:size(conn, 2)
    triangle_vertices = coor(:, conn(:, i));
    patch('Vertices', triangle_vertices', 'Faces', [1, 2, 3], 'FaceColor', ...
        [Stress_normalized(1,i),0,0], 'EdgeColor', 'none');
end
hold off;
axis equal;
xlabel('X-axis');
ylabel('Y-axis');
title('Stress Distribution');