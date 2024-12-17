pkg load signal;

% サンプリング周波数とフィルタ設定
fs = 48000;                   % サンプリング周波数 (Hz)
N = 8192;                     % FIR フィルタのタップ数
f = linspace(0, fs/2, N/2+1); % 周波数範囲（片側スペクトル）
current_dir=pwd;

% RIAA伝達関数の定義
T1 = 3.18e-3;                                   % 時定数1
T2 = 318e-6;                                    % 時定数2
T3 = 75e-6;                                     % 時定数3
s = 2 * pi * 1i * f;                            % s = jω
Hs = (1 + s*T2) ./ ((1 + s*T1) .* (1 + s*T3));  %周波数特性

% 非直線位相を持つフィルタ設計のため、複素共役対称性を適用しない
%Hf_full = Hs; % 複素共役対称性をもたせず、そのまま使用

% 時間領域のインパルス応答を逆フーリエ変換で取得
h = real(ifft(Hs, N));    % 時間領域の係数
h_6db = 36*h;             %+6dB@1kHzに調整

% FIRフィルタの周波数特性
[H, f_resp] = freqz(h, 1, N/2, fs);       % 周波数特性の計算

% gainとphase
gain = 20*log10(36*abs(H));             % ゲイン特性 (dB)
phase = angle(H) * (180/pi);            % 位相特性 (degree)

% FIRフィルタの係数を保存
save_path=[pwd,sprintf("/coeff_nonlin6db_%d.txt",fs)]
save("-ascii", save_path, "h_6db");

% ゲイン特性と位相特性のプロット
figure;
subplot(2, 1, 1);
semilogx(f_resp, gain, 'b');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
title(sprintf('non-Linear FIR RIAA Response %dHzSampling',fs));
xlim([10 24000]);
ylim([-30 30]);
grid on;

subplot(2, 1, 2);
semilogx(f_resp, phase, 'r');
xlabel('Frequency (Hz)');
ylabel('Phase (Deg)');
xlim([10 24000]);
ylim([-100 0]);
grid on;
