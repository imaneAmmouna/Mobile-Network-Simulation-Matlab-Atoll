clc; clear; close all;

B = 3000;                         % Bande passante en Hz (ex: 3 kHz)
SNR_dB = 0:2:30;                  % SNR en dB
SNR_linear = 10.^(SNR_dB/10);     % Conversion en lin?aire

C = B * log2(1 + SNR_linear);     % Capacit? selon Shannon

figure;
plot(SNR_dB, C, 'b', 'LineWidth', 2);
xlabel('SNR (dB)');
ylabel('Capacit? (bit/s)');
title('Capacit? de transmission selon la formule de Shannon');
grid on;
