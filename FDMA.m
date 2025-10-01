Fs = 1000; % Fr?quence d'?chantillonnage
t = 0:1/Fs:1-1/Fs; % Vecteur temps 1s

% Signaux de trois utilisateurs sur diff?rentes fr?quences porteuses
f1 = 50;  % utilisateur 1
f2 = 150; % utilisateur 2
f3 = 300; % utilisateur 3

signal1 = cos(2*pi*f1*t);
signal2 = cos(2*pi*f2*t);
signal3 = cos(2*pi*f3*t);

% Signal multiplex? FDMA (somme des signaux)
signal_FDMA = signal1 + signal2 + signal3;

% Spectre du signal multiplex?
figure;
subplot(2,1,1);
plot(t, signal_FDMA);
title('Signal FDMA dans le domaine temporel');
xlabel('Temps (s)');
ylabel('Amplitude');

subplot(2,1,2);
NFFT = 2^nextpow2(length(signal_FDMA));
freq_axis = Fs/2*linspace(0,1,NFFT/2+1);
signal_FDMA_fft = fft(signal_FDMA, NFFT)/length(signal_FDMA);

plot(freq_axis, 2*abs(signal_FDMA_fft(1:NFFT/2+1)));
title('Spectre du signal FDMA');
xlabel('Fr?quence (Hz)');
ylabel('Amplitude');
grid on;
