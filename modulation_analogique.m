clc; clear; close all;

% Signal d'information (message)
Fs = 10000;            % Fr?quence d'?chantillonnage
t = 0:1/Fs:0.01;       % Temps (10 ms)
fm = 150;               % Fr?quence du message (Hz)
Am = 1;                % Amplitude du message
m = Am * sin(2*pi*fm*t);  % Signal message

% Porteuse
fc = 1000;             % Fr?quence de la porteuse (Hz)
Ac = 1;                % Amplitude de la porteuse

% --- Modulation AM ---
ka = 0.7;              % Indice de modulation AM
AM = (1 + ka*m) .* cos(2*pi*fc*t);

% --- Modulation FM ---
kf = 50;               % Sensibilit? en fr?quence
FM = Ac * cos(2*pi*fc*t + 2*pi*kf*cumsum(m)/Fs);

% --- Modulation PM ---
kp = pi/2;             % Sensibilit? en phase
PM = Ac * cos(2*pi*fc*t + kp*m);

% --- Affichage ---
figure;
subplot(4,1,1);
plot(t,m,'k'); grid on;
title('Signal message m(t)');
xlabel('Temps (s)'); ylabel('Amplitude');

subplot(4,1,2);
plot(t,AM,'b'); grid on;
title('Modulation d''Amplitude (AM)');
xlabel('Temps (s)'); ylabel('Amplitude');

subplot(4,1,3);
plot(t,FM,'r'); grid on;
title('Modulation de Fr?quence (FM)');
xlabel('Temps (s)'); ylabel('Amplitude');

subplot(4,1,4);
plot(t,PM,'m'); grid on;
title('Modulation de Phase (PM)');
xlabel('Temps (s)'); ylabel('Amplitude');
