% 定義常數
sigma0 = 15;   % 常數 σ₀
e0 = 0.15;    % 常數 ε₀ (可根據需求調整)
n = 2;        % 常數 n

% 定義變數 εₑ
syms ee;

% 計算公式的分子和分母
numerator = sigma0 * (n / (n - 1) - ee / e0); % 分子
denominator_expr = (1 + n^2) / (n - 1)^2 - (n / (n - 1) - ee / e0)^2; % 分母內部表達式
denominator = e0 * sqrt(denominator_expr); % 分母

% 最終公式（斜率）
slope = numerator / denominator;

% 定義 εₑ 的範圍
ee_values = linspace(0.0007, 0.07, 100); % εₑ 的範圍
ee_values = [0, ee_values];
% valid_mask = double(subs(denominator_expr, ee, ee_values)) >= 0; % 有效範圍掩碼

% 僅保留有效範圍內的 εₑ 和斜率值
% valid_ee_values = ee_values(valid_mask); % 有效 εₑ 的範圍
slope_values = double(subs(slope, ee, ee_values)); % 計算斜率

% 根據斜率計算曲線的累積值
curve_values = cumtrapz(ee_values, slope_values); % 累積積分計算曲線值


% 繪製曲線
figure;
plot(ee_values, curve_values, 'LineWidth', 1.5);
xlabel('Strain');
ylabel('Stress (MPa)');
title('Stress-Strain curve (exact)');
grid on;
