clc; clear;

% Ts = 10 ns; Fs = 1 / Ts = 100 MHz
Fs = 100e6;

P = 32; % number of phase accumulator & increment Bits
M = 8;  % number of Look Up Table address Bits
L = 12; % number of Look Up Table Values Bits
%%
T = 100e-6;
f0 = 1e6;
f1 = 2e6;

Nstep = T * Fs
df = (f1 - f0) / Nstep
dN = df * 2^P / Fs
dNb = dec2bin(dN, P)
%%
% N : Phase increment
f = f0;
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
xlim([0, T])
xlabel('time'); ylabel('y');
grid on
%% Plot DDS Output in Freq Domain
Y = fftshift(fft(y));
magY = abs(Y);
freq = linspace(-Fs/2, Fs/2, length(magY));
figure(2); clf; hold on; grid on
plot(freq, magY / max(magY))
plot([f0, f1], [1, 1], 'r*')
% xlim([0, Fs/2])
xlim([0, 2*f1])
xlabel('freq (Hz)'); ylabel('|Y| normalized');

%%
figure(3); clf
spectrogram(y, 1024, 1, 1024, Fs, 'yaxis')
ylim([0, 2*f1] / 1e6)
