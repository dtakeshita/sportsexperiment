% サンプリング周波数と時間軸の設定
Fs = 200; % サンプリング周波数
T = 1/Fs; % サンプリング周期
t = 0:T:10; % サンプル時刻（0から10秒まで）

% 2 Hzの位相と振幅がそろった三角波の生成
triangle_wave = sawtooth(2*pi*2*t, 0.5);

% 2 Hzの位相と振幅がそろった正弦波の生成
sin_wave = -cos(2*pi*2*t);

% フィルタの設計
cutoff_freq = 6; % カットオフ周波数（6 Hz）
filter_order = 2; % フィルタの次数（2次）
[b, a] = butter(filter_order, cutoff_freq/(Fs/2)); % バターワース型ローパスフィルタの係数

% フィルタリング
filtered_triangle_wave = filtfilt(b, a, triangle_wave);
filtered_sin_wave = filtfilt(b, a, sin_wave);

% 速度の算出
d_dt = @(x)((x(3:end)-x(1:end-2))/(2*T));
t_v = t(2:end-1);
v_triangle_wave = d_dt(triangle_wave);
v_filtered_triangle_wave = d_dt(filtered_triangle_wave);
v_sin_wave = d_dt(sin_wave);
v_filtered_sin_wave = d_dt(filtered_sin_wave);


% プロット
subplot(2,2,1);
plot(t, triangle_wave, 'b', 'LineWidth', 1.5);
hold on;
plot(t, filtered_triangle_wave, 'r', 'LineWidth', 1.5);
hold off;
xlabel('Time (s)');
ylabel('Position');
title('Triangle Wave and Filtered Signal');
legend('Original', 'Filtered');

subplot(2,2,2);
plot(t, sin_wave, 'b', 'LineWidth', 1.5);
hold on;
plot(t, filtered_sin_wave, 'r', 'LineWidth', 1.5);
hold off;
xlabel('Time (s)');
ylabel('Position');
title('Sine Wave and Filtered Signal');
legend('Original', 'Filtered');

subplot(2,2,3)
plot(t_v, v_triangle_wave, 'b', 'LineWidth', 1.5)
hold on
plot(t_v, v_filtered_triangle_wave, 'r', 'LineWidth', 1.5)
xlabel('Time (s)');ylabel('Velocity ')
title('Derivative of Triangle Wave ');
legend('Original', 'Filtered');

subplot(2,2,4)
plot(t_v, v_sin_wave, 'b', 'LineWidth', 1.5)
hold on
plot(t_v, v_filtered_sin_wave, 'r', 'LineWidth', 1.5)
xlabel('Time (s)');ylabel('Velocity ')
title('Derivative of Sine Wave ');
legend('Original', 'Filtered');

AH = findobj(gcf,'type','axes');
set(AH,'xlim',[4 5])