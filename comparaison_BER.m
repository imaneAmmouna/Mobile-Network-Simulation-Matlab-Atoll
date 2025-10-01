clc; clear; close all;

% Param?tres
EbNo_dB_values = 0:2:20; % Valeurs de Eb/No en dB
M_values = [4, 16, 64]; % Ordres de modulation (QPSK, 16QAM, 64QAM)
modulations = {'QPSK', '16QAM', '64QAM'};

numBits = 1e5; % Nombre de bits ? transmettre
BER_results = zeros(length(M_values), length(EbNo_dB_values)); % Tableau de r?sultats

for m_idx = 1:length(M_values)
    M = M_values(m_idx);
    k = log2(M); % Bits par symbole

    for e_idx = 1:length(EbNo_dB_values)
        EbNo_dB = EbNo_dB_values(e_idx);
        EbNo = 10^(EbNo_dB/10); % Eb/No en valeur lin?aire

        % G?n?ration des bits al?atoires (ajust?s pour ?tre divisibles par k)
        numSymbols = floor(numBits / k);
        bits_tx = randi([0 1], numSymbols * k, 1);

        % Mapping des bits en symboles
        symbols_tx = qammod(bi2de(reshape(bits_tx, k, []).'), M, 'InputType', 'integer', 'UnitAveragePower', true);

        % Ajout de bruit AWGN
        snr = EbNo_dB + 10*log10(k); % SNR par symbole
        symbols_rx = awgn(symbols_tx, snr, 'measured');

        % D?modulation
        bits_rx = de2bi(qamdemod(symbols_rx, M, 'OutputType', 'integer', 'UnitAveragePower', true), k).';
        bits_rx = bits_rx(:);

        % Calcul du BER
        numErrors = sum(bits_tx ~= bits_rx);
        BER = numErrors / length(bits_tx);
        BER_results(m_idx, e_idx) = BER;

        fprintf('%s, Eb/No=%d dB, BER=%.5e\n', modulations{m_idx}, EbNo_dB, BER);
    end
end

% Trac?
figure;
semilogy(EbNo_dB_values, BER_results(1,:), 'r-o', 'LineWidth', 2); hold on;
semilogy(EbNo_dB_values, BER_results(2,:), 'b-s', 'LineWidth', 2);
semilogy(EbNo_dB_values, BER_results(3,:), 'k-^', 'LineWidth', 2);
grid on;
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate (BER)');
title('Comparaison du BER pour diff?rentes modulations QAM');
legend(modulations, 'Location', 'southwest');
