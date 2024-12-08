% 定義常數 K1 和 mu1
K1 = 50;   % 這是 K1 的值，可以根據需要修改
mu1 = 5;  % 這是 mu1 的值，可以根據需要修改

% 定義 x 的範圍
x = linspace(0, 0.07, 100);  % 在 0 到 0.05 之間生成 100 個點

% 計算 y 的值
y = K1 * x + mu1 * x.^2;  % 計算 y = K1 * x + mu1 * x^2

% 繪製圖形
figure;  % 創建新圖形
plot(x, y, 'LineWidth', 1.5);  % 畫出 x 和 y 的關係，藍色線條，線寬 2
xlabel('Strain');
ylabel('Stress (MPa)');
title('Stress-Strain curve (exact)');
grid on;  % 顯示網格
