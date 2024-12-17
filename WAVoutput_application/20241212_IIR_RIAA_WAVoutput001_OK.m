pkg load signal;

% フィルタ係数を定義
%{
%96kHz プリワーピングなし +6dB
#ゲインはb0のみで調整
b0 = 0.26;
b1 = [1 0];
b2 = [1 -0.96777105 0];
a1 = [1 0];
a2 = [1 -1.866859545 0.867284263];
%}

%
%48kHz プリワーピングなし +6dB
#ゲインはb0のみで調整
b0 = 0.5;
b1 = [1 0];
b2 = [1 -0.936564324 0];
a1 = [1 0];
a2 = [1 -1.749567588 0.751160265];
%}

% IIRフィルタ係数の計算
b = b0 * conv(b1, b2);
a = conv(a1, a2);

% 音声ファイルの読み込み
inputFile = "alice4816_direct_15s.wav";
[~,name,ext] = fileparts(inputFile);
inputFileName = [name,ext];
inputFileName
[input_signal, fs] = audioread(inputFile);

% フィルタリング
filtered_signal = filter(b, a, input_signal);

% 出力ファイルを保存
outputFileName = sprintf('IIR_RIAA_%s',inputFileName);
audiowrite(outputFileName, filtered_signal, fs);

% 周波数特性を計算
[h, w] = freqz(b, a, 4096, 'whole', fs);

% ゲイン(dB)と位相(degree)を計算
gain = 20 * log10(abs(h)); % ゲイン (dB)
phase = angle(h) * (180 / pi); % 位相 (degree)

% プロット
figure;

%ゲイン特性
subplot(2,1,1);
semilogx(w,gain);
grid;
title(sprintf('IIR RIAA EQ %dHz Sampling',fs));
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
xlim([10 30000]);

%位相特性
subplot(2,1,2);
semilogx(w,phase);
grid;
xlabel('Frequency (Hz)');
ylabel('Phase (Deg)');
xlim([10 30000]);
