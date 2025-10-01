clc; clear; close all;

%% === Premi?re figure : Signal TDMA combin? (cos/sin/triangle) ===
Fs = 1000;             % Fr?quence d'?chantillonnage (Hz)
T = 1;                 % Dur?e totale d'une trame (1 seconde)
t = 0:1/Fs:T-1/Fs;     % Vecteur temps

N_users = 3;                     % Nombre d'utilisateurs
slot_duration = T / N_users;     % Dur?e de chaque slot temporel

% Initialiser le signal TDMA
signal_TDMA = zeros(size(t));

% D?finir les signaux des utilisateurs
user_signals = {
    @(t) cos(2*pi*50*t);          % Utilisateur 1
    @(t) sin(2*pi*100*t);         % Utilisateur 2
    @(t) sawtooth(2*pi*150*t);    % Utilisateur 3
};

% Cr?ation du signal TDMA combin?
for user = 1:N_users
    slot_start = (user-1)*slot_duration;
    slot_end = user*slot_duration;
    
    slot_idx = (t >= slot_start) & (t < slot_end);
    signal_TDMA(slot_idx) = user_signals{user}(t(slot_idx));
end

% Affichage du signal combin?
figure;
plot(t, signal_TDMA, 'LineWidth', 1.5);
title('Signal TDMA dans le domaine temporel');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
legend('Signal TDMA');

%% === Deuxi?me figure : Structure TDMA (slots carr?s) ===
N_users = 3;           % Nombre d'utilisateurs
T_slot = 1;            % Dur?e d'un slot temporel (en secondes)
N_slots = 3;           % Nombre total de slots
fs = 100;              % Fr?quence d'?chantillonnage
T_total = N_slots * T_slot;

% Vecteur temps
t = linspace(0, T_total, T_total*fs);

% Initialiser les signaux utilisateurs
signals = zeros(N_users, length(t));

% G?n?rer les signaux TDMA par utilisateur
for user = 1:N_users
    idx_start = round((user-1)*T_slot*fs) + 1;
    idx_end = round(user*T_slot*fs);
    signals(user, idx_start:idx_end) = 1;
end

% Affichage structure TDMA
figure;
hold on;
colors = ['b', 'r', 'g'];

for user = 1:N_users
    stairs(t, signals(user,:) + (user-1)*1.5, 'Color', colors(user), 'LineWidth', 2);
end

set(gca, 'YTick', 0:1.5:(N_users-1)*1.5);
set(gca, 'YTickLabel', arrayfun(@(x) sprintf('Utilisateur %d', x), 1:N_users, 'UniformOutput', false));
xlabel('Temps (s)');
title('Illustration TDMA pour 3 utilisateurs');
grid on;
ylim([-0.5, N_users*1.5]);
hold off;
