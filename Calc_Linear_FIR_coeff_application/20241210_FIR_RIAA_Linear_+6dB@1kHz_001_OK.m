pkg load signal;

% サンプリング周波数とフィルタ設定
fs = 48000;                     % サンプリング周波数 (Hz)
N = 8192;                       % FIR フィルタのタップ数
f = linspace(0, fs/2, N/2+1);   % 周波数範囲（片側スペクトル）
current_dir=pwd;

% RIAA伝達関数の定義
T1 = 3.18e-3;         % 時定数1
T2 = 318e-6;          % 時定数2
T3 = 75e-6;           % 時定数3
s = 2 * pi * 1i * f;  % s = jω
Hs = (1 + s*T2) ./ ((1 + s*T1) .* (1 + s*T3));

% 時間領域のインパルス応答を逆フーリエ変換で取得
Hf_full = [Hs, conj(flip(Hs(2:end-1)))];  % 直線位相特性を得るため複素共役対称性を持たせる
h = real(ifft(Hf_full,N));                % インパルス応答を取得
h = circshift(h, -N/2);                   % ゼロ位相シフト
h_6db = 20*h;                             %+6dB@1kHzに調整

% FIRフィルタの周波数特性
[Hfir, w] = freqz(h, 1, N, fs);

% gainとphase
gain = 20*log10(20*abs(Hfir));            % ゲイン特性 (dB)
phase = angle(Hfir) * (180/pi);           % 位相特性 (degree)

% FIRフィルタの係数を保存
save_path=[pwd,sprintf("/coeff_lin6db_%d.txt",fs)]
save("-ascii", save_path, "h_6db");
#save(coeff_file, 'h_fir', '-ascii');

% ゲイン特性と位相特性のプロット
figure;
subplot(2,1,1);
semilogx(w, gain);
grid on;
xlim([10 24000]);
ylim([-30 30]);
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
title(sprintf('Linear FIR RIAA Response %dHzSampling',fs));

subplot(2,1,2);
semilogx(w, phase);
grid on;
xlim([10 24000]);
xlabel('Frequency (Hz)');
ylabel('Phase (Deg)');


% FIRフィルタ係数をファイルに保存
coeff_file = 'current_dir/coeff.txt';
disp(['FIR filter coefficients saved to ', coeff_file]);
