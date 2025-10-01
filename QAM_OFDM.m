clc; clear; close all;

%% Param?tres du syst?me
Nfft = 64;           % Nombre de sous-porteuses OFDM (taille FFT)
Ncp = 16;            % Taille du pr?fixe cyclique (nombre d'?chantillons)
M = 16;              % Ordre de modulation QAM (ex: 16-QAM)
numSymbols = 10;     % Nombre de symboles OFDM ? transmettre

%% 1) G?n?ration al?atoire de bits
numBits = numSymbols * Nfft * log2(M);
bits = randi([0 1], numBits, 1);

figure;
stem(bits(1:50), 'filled');
title('Bits transmis (premiers 50 bits)');
xlabel('Indice');
ylabel('Valeur binaire');
grid on;

%% 2) Modulation QAM
dataSymbols = qammod(bits, M, 'InputType', 'bit', 'UnitAveragePower', true);

figure;
scatterplot(dataSymbols(1:200));
title('Constellation 16-QAM (premiers symboles)');
grid on;

%% 3) Regroupement en blocs OFDM
dataSymbolsMatrix = reshape(dataSymbols, Nfft, numSymbols);

%% 4) Visualisation de l'orthogonalit? des sous-porteuses OFDM
% Matrice de base des sous-porteuses (vecteurs de la FFT)
F = fft(eye(Nfft));
corrMatrix = abs(F'*F); % corr?lation des sous-porteuses (devrait ?tre diagonale)

figure;
imagesc(corrMatrix);
colorbar;
title('Orthogonalit? des sous-porteuses OFDM (matrice de corr?lation)');
xlabel('Sous-porteuse');
ylabel('Sous-porteuse');

%% 5) IFFT (modulation OFDM)
ofdmTime = ifft(dataSymbolsMatrix, Nfft);

figure;
plot(real(ofdmTime(:,1)), 'b');
hold on;
plot(imag(ofdmTime(:,1)), 'r');
title('Signal OFDM (domaine temporel) - 1er symbole');
xlabel('Echantillon');
ylabel('Amplitude');
legend('Partie r?elle', 'Partie imaginaire');
grid on;

%% 6) Ajout du pr?fixe cyclique
ofdmWithCP = [ofdmTime(end-Ncp+1:end, :); ofdmTime];

figure;
plot(real(ofdmWithCP(:,1)), 'b');
hold on;
plot(imag(ofdmWithCP(:,1)), 'r');
title('Signal OFDM avec pr?fixe cyclique (1er symbole)');
xlabel('Echantillon');
ylabel('Amplitude');
legend('Partie r?elle', 'Partie imaginaire');
grid on;

%% 7) S?rialisation pour transmission
txSignal = ofdmWithCP(:);

figure;
plot(real(txSignal(1:200)), 'b');
hold on;
plot(imag(txSignal(1:200)), 'r');
title('Signal OFDM s?rialis? ? transmettre (partie)');
xlabel('Echantillon');
ylabel('Amplitude');
legend('Partie r?elle', 'Partie imaginaire');
grid on;

%% 8) Canal multi-trajet (3 chemins) + bruit AWGN
% Exemple de canal multi-trajet (avec retard implicite = indices)
h = [0.8 0.5 0.3]; % coefficients des chemins
delay = [0 3 5];   % retards en nombre d??chantillons (exemple)

% Construction du canal convolutif avec retard
channelLen = delay(end)+1;
channelImpulse = zeros(1, channelLen);
for k=1:length(h)
    channelImpulse(delay(k)+1) = h(k);
end

% Convolution du signal avec le canal
rxSignalMultiPath = conv(txSignal, channelImpulse, 'same');

% Ajout du bruit AWGN
SNR_dB = 15; % Modifie pour voir l'effet (ex: 5, 10, 15, 20)
signalPower = mean(abs(rxSignalMultiPath).^2);
SNR = 10^(SNR_dB/10);
noisePower = signalPower / SNR;
noise = sqrt(noisePower/2)*(randn(size(rxSignalMultiPath)) + 1i*randn(size(rxSignalMultiPath)));
rxSignal = rxSignalMultiPath + noise;

%% 9) Reshape du signal re?u en blocs OFDM avec pr?fixe cyclique
rxSignalMatrix = reshape(rxSignal, Nfft+Ncp, numSymbols);

%% 10) Suppression du pr?fixe cyclique (retrait du CP)
rxSignalNoCP = rxSignalMatrix(Ncp+1:end, :);

%% 11) FFT (d?modulation OFDM)
rxDataFreq = fft(rxSignalNoCP, Nfft);

figure;
scatterplot(rxDataFreq(:,1));
title(['Constellation re?ue apr?s FFT (1er symbole OFDM) ? SNR = ' num2str(SNR_dB) ' dB']);
grid on;

%% 12) D?modulation QAM
receivedBits = qamdemod(rxDataFreq, M, 'OutputType', 'bit', 'UnitAveragePower', true);
receivedBits = receivedBits(:);

%% 13) Calcul BER
[numErr, ber] = biterr(bits, receivedBits);
fprintf('SNR = %d dB, Taux d erreur binaire (BER) avec pr?fixe cyclique = %f\n', SNR_dB, ber);

%% 14) Simulation SANS pr?fixe cyclique (pour comparaison BER)
% On retire le CP ? l??mission (pas de CP ajout?)
txSignalNoCP = ofdmTime(:); % sans CP

% Passage dans le canal multi-trajet + bruit
rxSignalNoCP_chan = conv(txSignalNoCP, channelImpulse, 'same');
noiseNoCP = sqrt(noisePower/2)*(randn(size(rxSignalNoCP_chan)) + 1i*randn(size(rxSignalNoCP_chan)));
rxSignalNoCP_chan = rxSignalNoCP_chan + noiseNoCP;

% Reforme en blocs (taille Nfft cette fois, pas de CP)
rxSignalNoCP_mat = reshape(rxSignalNoCP_chan, Nfft, numSymbols);

% FFT directe (sans suppression CP)
rxDataFreqNoCP = fft(rxSignalNoCP_mat, Nfft);

% D?modulation QAM
receivedBitsNoCP = qamdemod(rxDataFreqNoCP, M, 'OutputType', 'bit', 'UnitAveragePower', true);
receivedBitsNoCP = receivedBitsNoCP(:);

% Calcul BER sans CP
[~, berNoCP] = biterr(bits, receivedBitsNoCP);
fprintf('SNR = %d dB, Taux d erreur binaire (BER) sans pr?fixe cyclique = %f\n', SNR_dB, berNoCP);

%% 15) Comparaison bits transmis/re?us (avec CP)
figure;
stem(bits(1:50), 'b', 'filled');
hold on;
stem(receivedBits(1:50), 'r');
title('Comparaison bits transmis (bleu) vs re?us avec CP (rouge)');
xlabel('Indice');
ylabel('Valeur binaire');
legend('Bits transmis', 'Bits re?us');
grid on;

%% 16) Comparaison bits transmis/re?us (sans CP)
figure;
stem(bits(1:50), 'b', 'filled');
hold on;
stem(receivedBitsNoCP(1:50), 'r');
title('Comparaison bits transmis (bleu) vs re?us sans CP (rouge)');
xlabel('Indice');
ylabel('Valeur binaire');
legend('Bits transmis', 'Bits re?us');
grid on;
