% Temps
t = 0:0.001:1;  % 1 seconde, r?solution 1 ms

% Valeurs fixes de base
A = 1;      % Amplitude fixe
f = 5;      % Fr?quence fixe (Hz)
phi = 0;    % Phase fixe (radians)

% === 1. Variation d'amplitude ===
A1 = 0.5; A2 = 1; A3 = 1.5;
s1 = A1 * sin(2*pi*f*t + phi);
s2 = A2 * sin(2*pi*f*t + phi);
s3 = A3 * sin(2*pi*f*t + phi);

figure;
subplot(3,1,1);
plot(t, s1, 'r', t, s2, 'g', t, s3, 'b');
title('Variation d''Amplitude');
legend('A = 0.5','A = 1','A = 1.5');
xlabel('Temps (s)');
ylabel('Amplitude');

% === 2. Variation de fr?quence ===
A = 1;
f1 = 3; f2 = 5; f3 = 7;
s1 = A * sin(2*pi*f1*t + phi);
s2 = A * sin(2*pi*f2*t + phi);
s3 = A * sin(2*pi*f3*t + phi);

subplot(3,1,2);
plot(t, s1, 'r', t, s2, 'g', t, s3, 'b');
title('Variation de Frequence');
legend('f = 3 Hz','f = 5 Hz','f = 7 Hz');
xlabel('Temps (s)');

% === 3. Variation de phase ===
phi1 = 0; phi2 = pi/4; phi3 = pi/2;
f = 5;
s1 = A * sin(2*pi*f*t + phi1);
s2 = A * sin(2*pi*f*t + phi2);
s3 = A * sin(2*pi*f*t + phi3);

subplot(3,1,3);
plot(t, s1, 'r', t, s2, 'g', t, s3, 'b');
title('Variation de Phase');
legend('\phi = 0','\phi = \pi/4','\phi = \pi/2');
xlabel('Temps (s)');
