clc; clear; close all;

%% 1) SIGNAL BASEBAND : Suite de bits
Fs = 10000;             % Fr?quence d'?chantillonnage (10 kHz)
Tb = 0.002;             % Dur?e d?un bit = 2 ms
bits = [1 0 1 1 0];     % Suite de bits ? transmettre

% G?n?ration du signal baseband
baseband = [];
for i = 1:length(bits)
    baseband = [baseband bits(i)*ones(1,Fs*Tb)];
end

t1 = (0:length(baseband)-1)/Fs; % Temps associ?

% === Affichage du signal baseband ===
figure;
plot(t1, baseband, 'b', 'LineWidth', 1.5);
title('Figure 1 : Signal Baseband (suite de bits)');
xlabel('Temps (s)');
ylabel('Amplitude');
ylim([-0.5 1.5]); grid on;

%% 2) SIGNAL BROADBAND : Plusieurs signaux sur diff?rentes fr?quences
fs = 10000;             % Fr?quence d'?chantillonnage
t2 = 0:1/fs:0.01;       % 10 ms

% Signal 1 : voix (basse fr?quence)
f1 = 300;               % 300 Hz
s1 = sin(2*pi*f1*t2);

% Signal 2 : donn?es (fr?quence moyenne)
f2 = 1200;              % 1.2 kHz
s2 = 0.7 * sin(2*pi*f2*t2);

% Signal 3 : vid?o (haute fr?quence)
f3 = 3000;              % 3 kHz
s3 = 0.4 * sin(2*pi*f3*t2);

% Signal total broadband = somme des 3
broadband_signal = s1 + s2 + s3;

% === Affichage temporel des signaux ===
figure;
subplot(4,1,1);
plot(t2, s1);
title('Figure 2 : Signal 1 - Voix (300 Hz)');
ylabel('Amplitude'); grid on;

subplot(4,1,2);
plot(t2, s2);
title('Figure 3 : Signal 2 - Donn?es (1.2 kHz)');
ylabel('Amplitude'); grid on;

subplot(4,1,3);
plot(t2, s3);
title('Figure 4 : Signal 3 - Vid?o (3 kHz)');
ylabel('Amplitude'); grid on;

subplot(4,1,4);
plot(t2, broadband_signal);
title('Figure 5 : Signal Compos? - Transmission Broadband');
xlabel('Temps (s)'); ylabel('Amplitude'); grid on;

%% 3) Analyse fr?quentielle du signal broadband
n = length(broadband_signal);
Y = fft(broadband_signal);
n = length(Y);
Y = abs(Y(1:floor(n/2)));
f = linspace(0, fs/2, length(Y));

% === Affichage du spectre (FFT) ===
figure;
plot(f, Y, 'LineWidth', 1.2);
title('Figure 6 : Spectre du signal broadband');
xlabel('Fr?quence (Hz)');
ylabel('|Amplitude|');
grid on;
