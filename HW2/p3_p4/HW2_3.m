clc;
clear;
[coor, conn, ndime, mate, nnode, nelem, nelnd, npres, pres, nload, load, ntrac, trac] = ReadInput('hw2_3_inputfile.h5');

[uglob, Stress_glob] = stress_find(ndime,nnode,nelem,nelnd,mate,coor,conn,ntrac,trac,npres,pres);

Stress_val = zeros(1,nelem);
for i = 1:nelem
    Stress_val(i) = sqrt(sum(Stress_glob{i}(:).^2));  
end
Stress_val = Stress_val./5;
[max_stress, max_index] = max(Stress_val);
fprintf('max stress is %.2f MPa\n', max_stress);

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
