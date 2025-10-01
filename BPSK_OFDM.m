clc;
clear;
close all;

%% Param?tres OFDM
N = 64;             % Nombre de sous-porteuses
cp_len = 16;        % Longueur du pr?fixe cyclique
Nb_bits = N;        % Nombre de bits ? transmettre (1 bit par sous-porteuse ici)

%% 1. G?n?ration des bits al?atoires
bits = randi([0 1], Nb_bits, 1);

%% 2. Modulation BPSK (0->-1, 1->+1)
symbols = 2*bits - 1;

%% 3. IFFT pour passer au domaine temps (OFDM)
ofdm_time = ifft(symbols, N);

%% 4. Ajout du pr?fixe cyclique
ofdm_with_cp = [ofdm_time(end-cp_len+1:end); ofdm_time];

%% 5. Transmission (ici, canal id?al sans bruit)

%% 6. R?ception : suppression du pr?fixe cyclique
rx_signal = ofdm_with_cp(cp_len+1:end);

%% 7. FFT pour revenir au domaine fr?quence
received_symbols = fft(rx_signal, N);

%% 8. D?cision BPSK
received_bits = real(received_symbols) > 0;

%% 9. Affichage r?sultats
disp('Bits transmis :');
disp(bits');

disp('Bits re?us :');
disp(received_bits');

%% 10. Trac? du signal OFDM avec pr?fixe cyclique
figure;
plot(real(ofdm_with_cp));
title('Signal OFDM avec pr?fixe cyclique');
xlabel('Temps');
ylabel('Amplitude');
grid on;
