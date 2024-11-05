function plot_displacement(coor, conn, deplacement)
    deplacement_normalized = (deplacement - min(deplacement)) / (max(deplacement) - min(deplacement));
    figure;
    nel = size(conn, 2);  % 元素數量
    nNodes = size(coor, 2);  % 節點數量
    hold on;

    % 繪製元素邊界並根據節點的 y 方向位移顯示顏色
    if (size(conn, 1) == 3)  % 如果是三角形元素
        for iel = 1:nel
            % 提取每個元素的節點
            element_nodes = conn(:, iel);
            x = coor(1, element_nodes);  % 節點X坐標
            y = coor(2, element_nodes);  % 節點Y坐標

            % 計算每個元素的位移大小（這裡使用y方向的位移平均值）
            elem_displacement = mean(dy(element_nodes));  % 平均y方向位移

            % 根據位移大小選擇顏色
            edge_color = elem_displacement;

            % 繪製三角形元素的邊界
            patch('Vertices', [x', y'], 'Faces', [1 2 3], 'FaceColor', 'none', 'EdgeColor', ...
                [1 1 1] * edge_color, 'LineWidth', 2);
        end
    elseif (size(conn, 1) == 4)  % 如果是四邊形元素
        for iel = 1:nel
            % 提取每個元素的節點
            element_nodes = conn(:, iel);
            x = coor(1, element_nodes);  % 節點X坐標
            y = coor(2, element_nodes);  % 節點Y坐標

            % 計算每個元素的位移大小（這裡使用y方向的位移平均值）
            elem_displacement = mean(deplacement_normalized(element_nodes));  % 平均y方向位移

            if elem_displacement <= 1/5
                channel_nom = (elem_displacement - 0) / (1/5);
                colorRGB = [0, channel_nom, 1];
            elseif elem_displacement <= 2/5
                channel_nom = (elem_displacement - 1/5) / (1/5);
                colorRGB = [0, 1, 1 - channel_nom];
            elseif elem_displacement <= 3/5
                channel_nom = (elem_displacement - 2/5) / (1/5);
                colorRGB = [channel_nom, 1, 0];
            else
                channel_nom = (elem_displacement - 3/5) / (2/5);
                colorRGB = [1, 1 - channel_nom, 0];
            end

            % 根據位移大小選擇顏色
            edge_color = elem_displacement;

            % 繪製四邊形元素的邊界
            patch('Vertices', [x', y'], 'Faces', [1 2 3 4], 'FaceColor', 'none', 'EdgeColor', ...
                colorRGB);
        end
    end

    % 顯示顏色條
    %colorbar;  % 顯示顏色條
    axis equal;
    box on;
    grid on;
    title('Deflection Distribution');
    xlabel('X');
    ylabel('Y');
    hold off;

    caxis([0 1]);
    n_colors = 256;
    blue_to_cyan = [linspace(0, 0, n_colors/5)', linspace(0, 1, n_colors/5)', linspace(1, 1, n_colors/5)'];
    cyan_to_green = [linspace(0, 0, n_colors/5)', linspace(1, 1, n_colors/5)', linspace(1, 0, n_colors/5)'];
    green_to_yellow = [linspace(0, 1, n_colors/5)', linspace(1, 1, n_colors/5)', linspace(0, 0, n_colors/5)'];
    yellow_to_orange = [linspace(1, 1, n_colors/5)', linspace(1, 0.5, n_colors/5)', linspace(0, 0, n_colors/5)'];
    orange_to_red = [linspace(1, 1, n_colors/5)', linspace(0.5, 0, n_colors/5)', linspace(0, 0, n_colors/5)'];
    gradient_colors = [blue_to_cyan; cyan_to_green; green_to_yellow; yellow_to_orange; orange_to_red];
    colormap(gradient_colors);
    
    split_points = linspace(min(deplacement), max(deplacement), 6);
    Stress_label = num2str(split_points', '%5.3f');

    C = colorbar('Ticks', linspace(0, 1, 6), 'TickLabels', strtrim(cellstr(Stress_label)));
    C.Label.String = 'mm';
    C.Label.VerticalAlignment = 'bottom';
    C.Label.HorizontalAlignment = 'right';
    C.Label.Rotation = 0;
    C.Label.Position(2) = C.Label.Position(2) + 0.51;
    C.Label.Position(1) = C.Label.Position(1) - 1.9;
end
