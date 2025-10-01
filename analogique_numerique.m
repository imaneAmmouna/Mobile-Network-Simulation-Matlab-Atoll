clc; clear; close all;

% --- Param?tres ---
fs = 1000;             % Fr?quence d'?chantillonnage
t = 0:1/fs:1;          % 1 seconde

% --- Signal analogique : sinuso?de continue ---
analog_signal = sin(2*pi*5*t); % 5 Hz

% --- Signal num?rique : suite binaire ---
digital_bits = [1 0 1 1 0 0 1];
bit_duration = 1 / 7;          % Chaque bit dure 1/7 seconde
digital_signal = repelem(digital_bits, length(t)/length(digital_bits));

% --- Affichage ---
figure;

% Signal analogique
subplot(2,1,1);
plot(t, analog_signal, 'b');
title('Signal Analogique (sinuso?de)');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
ylim([-1.2 1.2]);

% Signal num?rique
subplot(2,1,2);
plot(t, digital_signal, 'r', 'LineWidth', 2);
title('Signal Num?rique (binaire)');
xlabel('Temps (s)');
ylabel('Bits (0 ou 1)');
grid on;
ylim([-0.2 1.2]);
