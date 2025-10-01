clc; clear; close all;

%% Param?tres
Nfft = 8;            % Nombre total de sous-porteuses
Ncp = 2;             % Taille du pr?fixe cyclique
M = 4;               % Modulation QPSK (4-QAM)
numSymbols = 3;      % Nombre de symboles OFDMA dans le temps
numUsers = 2;        % Nombre d'utilisateurs

%% Attribution des sous-porteuses
subcarriersUser{1} = 1:4;      % Utilisateur 1 : sous-porteuses 1 ? 4
subcarriersUser{2} = 5:8;      % Utilisateur 2 : sous-porteuses 5 ? 8

%% 1) G?n?ration bits et modulation QAM par utilisateur
bitsUsers = cell(numUsers,1);
symbolsUsers = cell(numUsers,1);
for u = 1:numUsers
    numBits = length(subcarriersUser{u}) * numSymbols * log2(M);
    bitsUsers{u} = randi([0 1], numBits, 1);
    symbols = qammod(bitsUsers{u}, M, 'InputType', 'bit', 'UnitAveragePower', true);
    symbolsUsers{u} = reshape(symbols, length(subcarriersUser{u}), numSymbols);
    
    % Affichage constellation QAM de chaque utilisateur (premier symbole)
    figure;
    scatterplot(symbolsUsers{u}(:,1));
    title(['Constellation QPSK Utilisateur ', num2str(u)]);
    grid on;
end

%% 2) Construction signal OFDMA en fr?quence (mise des symboles dans le spectre)
ofdmaSymbols = zeros(Nfft, numSymbols);
for u = 1:numUsers
    ofdmaSymbols(subcarriersUser{u}, :) = symbolsUsers{u};
end

% Affichage du spectre (amplitude des symboles sur sous-porteuses)
figure;
stem(abs(ofdmaSymbols(:,1)), 'filled');
title('Amplitude des symboles OFDMA (1er symbole)');
xlabel('Indice sous-porteuse');
ylabel('Amplitude');
grid on;

%% 3) Passage en domaine temporel avec IFFT
timeSignal = ifft(ofdmaSymbols, Nfft);

% Affichage signal temps (partie r?elle et imaginaire) du premier symbole
figure;
plot(real(timeSignal(:,1)), '-ob');
hold on;
plot(imag(timeSignal(:,1)), '-xr');
title('Signal OFDMA en domaine temps (1er symbole)');
xlabel('Echantillon');
ylabel('Amplitude');
legend('Partie r?elle', 'Partie imaginaire');
grid on;

%% 4) Ajout du pr?fixe cyclique
timeSignalWithCP = [timeSignal(end-Ncp+1:end, :); timeSignal];

% Affichage signal avec pr?fixe cyclique (partie r?elle et imaginaire)
figure;
plot(real(timeSignalWithCP(:,1)), '-ob');
hold on;
plot(imag(timeSignalWithCP(:,1)), '-xr');
title('Signal OFDMA avec pr?fixe cyclique (1er symbole)');
xlabel('Echantillon');
ylabel('Amplitude');
legend('Partie r?elle', 'Partie imaginaire');
grid on;

%% 5) S?rialisation du signal pour transmission
txSignal = timeSignalWithCP(:);

% Affichage partie du signal temps r?el s?rialis?
figure;
plot(real(txSignal(1:20)), '-ob');
hold on;
plot(imag(txSignal(1:20)), '-xr');
title('Signal OFDMA s?rialis? ? transmettre (20 premiers ?chantillons)');
xlabel('Echantillon');
ylabel('Amplitude');
legend('Partie r?elle', 'Partie imaginaire');
grid on;

%% 6) Transmission dans canal id?al (pas de bruit)
rxSignal = txSignal;

%% 7) R?ception : reshape, suppression CP, FFT
rxMatrix = reshape(rxSignal, Nfft+Ncp, numSymbols);
rxMatrixNoCP = rxMatrix(Ncp+1:end, :);
rxFreqSymbols = fft(rxMatrixNoCP, Nfft);

% Affichage constellation re?ue pour le 1er utilisateur, 1er symbole
figure;
scatterplot(rxFreqSymbols(subcarriersUser{1},1));
title('Constellation re?ue Utilisateur 1 (1er symbole)');
grid on;

% Affichage constellation re?ue pour le 2?me utilisateur, 1er symbole
figure;
scatterplot(rxFreqSymbols(subcarriersUser{2},1));
title('Constellation re?ue Utilisateur 2 (1er symbole)');
grid on;

%% 8) D?modulation QAM et r?cup?ration bits par utilisateur
receivedBitsUsers = cell(numUsers,1);
for u = 1:numUsers
    userSymbols = rxFreqSymbols(subcarriersUser{u}, :);
    userSymbols = userSymbols(:);
    receivedBitsUsers{u} = qamdemod(userSymbols, M, 'OutputType', 'bit', 'UnitAveragePower', true);
end

%% 9) Calcul BER et affichage bits transmis/re?us
for u = 1:numUsers
    [numErr, ber] = biterr(bitsUsers{u}, receivedBitsUsers{u});
    fprintf('Utilisateur %d, BER = %f\n', u, ber);
    
    % Affichage bits transmis vs re?us (20 bits)
    figure;
    stem(bitsUsers{u}(1:20), 'b', 'filled');
    hold on;
    stem(receivedBitsUsers{u}(1:20), 'r');
    title(['Bits transmis (bleu) vs re?us (rouge) Utilisateur ', num2str(u)]);
    xlabel('Indice');
    ylabel('Bit');
    legend('Transmis', 'Re?u');
    grid on;
end
