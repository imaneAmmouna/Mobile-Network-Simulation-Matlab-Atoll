clc; clear; close all;

Nfft = 8;           % Nombre de sous-porteuses (petit pour la clart?)
Ncp = 2;            % Pr?fixe cyclique
M = 4;              % Modulation QPSK
numSymbols = 1;     % Juste 1 symbole OFDM pour simplifier
numUsers = 2;       % Nombre d?utilisateurs dans OFDMA

%% G?n?ration bits et symboles OFDM (1 utilisateur)
numBits_OFDM = Nfft * numSymbols * log2(M);
bits_OFDM = randi([0 1], numBits_OFDM, 1);
symbols_OFDM = qammod(bits_OFDM, M, 'InputType', 'bit', 'UnitAveragePower', true);
symbols_OFDM_Mat = reshape(symbols_OFDM, Nfft, numSymbols);

%% Affichage OFDM - sous-porteuses
figure('Name','Comparaison OFDM vs OFDMA','NumberTitle','off','Position',[200 200 900 600]);

subplot(3,2,1);
stem(abs(symbols_OFDM_Mat(:,1)), 'filled');
title('OFDM - Symboles sur toutes les sous-porteuses');
xlabel('Indice sous-porteuse');
ylabel('Amplitude');
ylim([0 1.2]);
grid on;
pause(2);

%% G?n?ration bits et symboles OFDMA (2 utilisateurs)
subcarriersUser{1} = 1:4;   % Utilisateur 1: sous-porteuses 1 ? 4
subcarriersUser{2} = 5:8;   % Utilisateur 2: sous-porteuses 5 ? 8

bitsUsers = cell(numUsers,1);
symbolsUsers = cell(numUsers,1);
for u=1:numUsers
    numBits = length(subcarriersUser{u}) * numSymbols * log2(M);
    bitsUsers{u} = randi([0 1], numBits, 1);
    symbols = qammod(bitsUsers{u}, M, 'InputType', 'bit', 'UnitAveragePower', true);
    symbolsUsers{u} = reshape(symbols, length(subcarriersUser{u}), numSymbols);
end

ofdmaSymbols = zeros(Nfft, numSymbols);
for u=1:numUsers
    ofdmaSymbols(subcarriersUser{u}, :) = symbolsUsers{u};
end

%% Affichage OFDMA - sous-porteuses partag?es par utilisateur (diff?rentes couleurs)
subplot(3,2,2);
hold on;
stem(subcarriersUser{1}, abs(ofdmaSymbols(subcarriersUser{1},1)), 'r', 'filled');
stem(subcarriersUser{2}, abs(ofdmaSymbols(subcarriersUser{2},1)), 'b', 'filled');
title('OFDMA - Sous-porteuses r?parties entre utilisateurs');
xlabel('Indice sous-porteuse');
ylabel('Amplitude');
ylim([0 1.2]);
legend('Utilisateur 1','Utilisateur 2');
grid on;
pause(2);

%% Signal OFDM dans le domaine temps (partie r?elle)
ofdmTime = ifft(symbols_OFDM_Mat, Nfft);
ofdmTime_CP = [ofdmTime(end-Ncp+1:end, :); ofdmTime];

subplot(3,2,3);
plot(real(ofdmTime_CP(:,1)),'-ob');
title('Signal OFDM (temps r?el) avec pr?fixe cyclique');
xlabel('Echantillon');
ylabel('Amplitude');
grid on;
pause(2);

%% Signal OFDMA dans le domaine temps (partie r?elle)
ofdmaTime = ifft(ofdmaSymbols, Nfft);
ofdmaTime_CP = [ofdmaTime(end-Ncp+1:end, :); ofdmaTime];

subplot(3,2,4);
plot(real(ofdmaTime_CP(:,1)),'-sr','MarkerFaceColor','r');
title('Signal OFDMA (temps r?el) avec pr?fixe cyclique');
xlabel('Echantillon');
ylabel('Amplitude');
grid on;
pause(2);

%% Constellation OFDM
subplot(3,2,5);
scatterplot(symbols_OFDM_Mat(:,1));
title('Constellation OFDM (QPSK)');
grid on;
pause(2);

%% Constellation OFDMA Utilisateur 1 et 2 (corrig?e)
subplot(3,2,6);
hold on;
scatter(real(ofdmaSymbols(subcarriersUser{1},1)), imag(ofdmaSymbols(subcarriersUser{1},1)), 'ro', 'filled');
scatter(real(ofdmaSymbols(subcarriersUser{2},1)), imag(ofdmaSymbols(subcarriersUser{2},1)), 'bs', 'filled');
title('Constellation OFDMA Utilisateur 1 (rouge) & Utilisateur 2 (bleu)');
xlabel('Partie r?elle');
ylabel('Partie imaginaire');
grid on;
axis equal;
hold off;
pause(2);

%% Explication finale (texte)
figure('Name','Explication OFDM vs OFDMA','NumberTitle','off');
axis off;
text(0.1,0.7,'OFDM: Un seul utilisateur utilise toutes les sous-porteuses en m?me temps.','FontSize',12);
text(0.1,0.5,'OFDMA: Plusieurs utilisateurs se partagent les sous-porteuses (ex: utilisateur 1 = sous-porteuses 1-4, utilisateur 2 = sous-porteuses 5-8).','FontSize',12);
text(0.1,0.3,'Chaque utilisateur transmet ses propres symboles QAM sur ses sous-porteuses allou?es.','FontSize',12);
text(0.1,0.1,'OFDMA permet la multi-accessibilit? et une meilleure utilisation des ressources radio.','FontSize',12);
