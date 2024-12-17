% パラメータ設定
fs = 96000;       % サンプリング周波数 (Hz)
n_fft = 8192;     % FFTサイズ
T1 = 3180e-6;     % 時定数 T1 (例: 3180us)
T3 = 75e-6;       % 時定数 T2 (例: 75us)
T2 = 318e-6;      % 時定数 T3 (例: 318us)

% 周波数軸の生成
f = linspace(0, fs/2, n_fft/2+1);  % 0 から fs/2 の周波数軸
omega = 2 * pi * f;               % 角周波数

% H(s) の計算 (s = jω)
Hs = (1 + 1i * omega * T2) ./ ((1 + 1i * omega * T1) .* (1 + 1i * omega * T3));

% 1kHzでのゲインで正規化
norm_index = find(f >= 1000, 1);  % 周波数1kHzのインデックスを取得
Hs = Hs / abs(Hs(norm_index));    % 1kHzでの振幅を1に正規化

% 振幅特性 (dBスケール)
magnitude_db = 20 * log10(abs(Hs)); % dBに変換
phase_deg = angle(Hs) * (180 / pi); % 位相を度に変換

% プロットの周波数範囲制限
f_min = 10;       % 最小周波数 (Hz)
f_max = 30000;    % 最大周波数 (Hz)
idx_range = (f >= f_min & f <= f_max); % 指定範囲のインデックスを取得

% 振幅特性プロット
figure;
semilogx(f(idx_range), magnitude_db(idx_range), 'b', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Frequency Response (Magnitude)');
xlim([f_min f_max]);
ylim([-30 30]);

% 位相特性プロット
figure;
semilogx(f(idx_range), phase_deg(idx_range), 'r', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
title('Frequency Response (Phase)');
xlim([f_min f_max]);
