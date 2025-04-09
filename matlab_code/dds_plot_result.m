clc; clear;

% Ts = 10 ns; Fs = 1 / Ts = 100 MHz
Fs = 100e6;

P = 32; % number of phase accumulator & increment Bits
M = 8;  % number of Look Up Table address Bits
L = 12; % number of Look Up Table Values Bits

%%
% N : Phase increment
f = 500e3;
N = f * (2^P) / Fs
Nb = dec2bin(N, P)

%%
fileID = fopen('./../dds/dds_out.txt', 'r');
y = fscanf(fileID, '%f\n');
fclose(fileID);

y = y / (2^(L-1)); % scale DDS output
t = (0:length(y) - 1) / Fs;

%% Plot DDS outpot in Time Domain
figure(1);
plot(t, y)
xlim([0, 20/f])
xlabel('time'); ylabel('y');
grid on

%% Plot DDS Output in Freq Domain
Y = fftshift(fft(y));
magY = abs(Y);
freq = linspace(-Fs/2, Fs/2, length(magY));
figure(2); clf; hold on; grid on
plot(freq, magY / max(magY))
plot(f, 1, 'r*')
% xlim([0, Fs/2])
xlim([0, 10*f])
xlabel('freq (Hz)'); ylabel('|Y| normalized');

%%
figure(3); clf
spectrogram(y, 1024, 1, 512, Fs, 'yaxis')
ylim([0, 20*f] / 1e6)


