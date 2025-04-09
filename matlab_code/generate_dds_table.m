clc; clear; close all;

P = 32; % number of phase accumulator & increment Bits
M = 8;  % number of Look Up Table address Bits
L = 12; % number of Look Up Table Values Bits

%% sampling Sine Function
n = 0:(2^M)-1;
u = n / (2^M); % [0, 1)
x = sin(2*pi*u);

%% functions to convert integer to binary
% de2bi
% doc dec2bin
% doc fi

%% Quantize Table Values to L bit
% [-1, 1] -> [-2^(L-1), 2^(L-1)]
xq = round(x * 2^(L-1));
xfi = fi(xq, true, L, 0);

xfi_2 = fi(x, true, L, L-1);


%%
% figure(1); clf; hold on
% stairs(x, 'k')
% stairs(xq / (2^(L-1)), 'r')

%% save binary values to file
fileID = fopen('.\sine_table.txt', 'w');
for v = xfi
    fprintf(fileID, '%s\n', v.bin);
end
fclose(fileID);

