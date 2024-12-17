pkg load signal;

% FIRフィルタの係数を読み込み
coeff = load('coeff_nonlin6db_48000.txt');

% 音声ファイルの読み込み
inputFile = "alice4816_direct_15s.wav";
[~,name,ext] = fileparts(inputFile);
inputFileName = [name,ext];
%[input_signal, fs] = audioread('alice9624direct_full.wav');  % 入力信号とサンプリング周波数を取得
[input_signal, fs] = audioread(inputFile);  % 入力信号とサンプリング周波数を取得

% フィルタリング
filtered_signal = filter(coeff, 1, input_signal);  % フィルタ適用

% 出力ファイルを保存
outputFileName = sprintf('FIR_RIAA_%s',inputFileName);
audiowrite(outputFileName, filtered_signal, fs);

% 周波数特性を計算
[h, w] = freqz(coeff, 1, 4096, fs); % 周波数特性を計算

% ゲイン(dB)と位相(degree)を計算
gain = 20 * log10(abs(h)); % ゲイン(dB)
phase = angle(h) * (180 / pi); % 位相(degree)

% プロット
figure;

% ゲイン特性
subplot(2, 1, 1);
semilogx(w,gain);
grid;
title(sprintf('FIR RIAA EQ %dHz Sampling',fs));
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
xlim([10, 30000]);
ylim([-20, 30]); % 必要に応じて調整

% 位相特性
subplot(2, 1, 2);
semilogx(w, phase);
grid;
xlabel('Frequency (Hz)');
ylabel('Phase (Deg)');
xlim([10, 30000]);

