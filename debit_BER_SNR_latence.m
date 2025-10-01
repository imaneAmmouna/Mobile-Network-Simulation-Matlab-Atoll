clc; clear; close all;

% --- Param?tres simul?s ---
SNR_dB = 0:2:30;               % SNR de 0 ? 30 dB
SNR_linear = 10.^(SNR_dB/10);  % Conversion en ?chelle lin?aire

% --- BER th?orique pour BPSK (modulation binaire simple) ---
BER = qfunc(sqrt(2 * SNR_linear));  % Fonction Q pour le BER BPSK

% --- D?bit binaire simul? en fonction du SNR ---
% Hypoth?se simple : 1 bit/s/Hz * log2(1 + SNR)
bitrate = log2(1 + SNR_linear);     % D?bit binaire normalis?

% --- Latence simul?e : inversement proportionnelle au SNR ---
latence = 100 ./ (1 + SNR_linear);  % en millisecondes

% === AFFICHAGE DES COURBES ===

% 1. Courbe BER vs SNR
figure;
semilogy(SNR_dB, BER, 'r', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title('BER (Bit Error Rate) en fonction du SNR');
legend('BER - BPSK');

% 2. D?bit binaire vs SNR
figure;
plot(SNR_dB, bitrate, 'b-o', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('D?bit binaire (bit/s/Hz)');
title('D?bit binaire en fonction du SNR');
legend('D?bit binaire');

% 3. Latence vs SNR
figure;
plot(SNR_dB, latence, 'g-s', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Latence (ms)');
title('Latence en fonction du SNR');
legend('Latence simul?e');

% 4. Courbes combin?es sur une m?me figure
figure;
yyaxis left;
semilogy(SNR_dB, BER, 'r', 'LineWidth', 2);
ylabel('BER (?chelle logarithmique)');

yyaxis right;
plot(SNR_dB, bitrate, 'b--', 'LineWidth', 2);
hold on;
plot(SNR_dB, latence, 'g:', 'LineWidth', 2);
ylabel('D?bit binaire / Latence');

xlabel('SNR (dB)');
title('Comparaison : BER, D?bit binaire, Latence vs SNR');
legend('BER', 'D?bit binaire', 'Latence');
grid on;

