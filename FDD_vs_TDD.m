clc; clear; close all;

% Param?tres
N = 10; % Nombre d'intervalles (slots)
t = 1:N;

% TDD : alternance dans le temps
% 1 = transmission, 0 = r?ception
TDD = zeros(1,N);
TDD(1:2:end) = 1;  % Transmit in odd slots
TDD(2:2:end) = 0;  % Receive in even slots

% FDD : transmission et r?ception simultan?es sur deux fr?quences
% 1 = actif (transmission ou r?ception)
FDD_tx = ones(1,N); % Transmission sur fr?quence 1
FDD_rx = ones(1,N); % R?ception sur fr?quence 2

% Affichage
figure;
subplot(3,1,1);
stem(t,TDD,'filled','r');
ylim([-0.2 1.2]);
title('Duplexage TDD : Transmission (1) et R?ception (0)');
xlabel('Intervalle de temps');
ylabel('Etat');

subplot(3,1,2);
stem(t,FDD_tx,'b','filled');
ylim([-0.2 1.2]);
title('Duplexage FDD : Transmission (fr?quence 1)');
xlabel('Intervalle de temps');
ylabel('Etat');

subplot(3,1,3);
stem(t,FDD_rx,'g','filled');
ylim([-0.2 1.2]);
title('Duplexage FDD : R?ception (fr?quence 2)');
xlabel('Intervalle de temps');
ylabel('Etat');
