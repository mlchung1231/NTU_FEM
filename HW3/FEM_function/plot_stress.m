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
    %colorRGB = zeros(size(conn, 2),3);
    
    figure;
    hold on;
    for i = 1:size(conn, 2)
        
        if Stress_normalized(1,i) <= 1/5
            channel_nom = (Stress_normalized(1,i) - 0) / (1/5);
            colorRGB = [0,channel_nom,1];
        elseif Stress_normalized(1,i) <= 2/5
            channel_nom = (Stress_normalized(1,i) - 1/5) / (1/5);
            colorRGB = [0,1,1-channel_nom];
        elseif Stress_normalized(1,i) <= 3/5
            channel_nom = (Stress_normalized(1,i) - 2/5) / (1/5);
            colorRGB = [channel_nom,1,0];
        else
            channel_nom = (Stress_normalized(1,i) - 3/5) / (2/5);
            colorRGB = [1,1-channel_nom,0];
        end
        triangle_vertices = coor(:, conn(:, i));
        patch('Vertices', triangle_vertices', 'Faces', [1, 2, 3], 'FaceColor', ...
            colorRGB, 'EdgeColor', 'none');
    end
    hold off;
    axis equal;
    xlabel('X-axis');
    ylabel('Y-axis');
    title('Stress Distribution');
end