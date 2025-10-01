% Param?tres
EbNo_dB_values = 0:2:20;                 % Valeurs de Eb/No en dB
M_values = [4, 16, 64, 256, 1024];       % Ordres de modulation QAM
numBits = 1e6;                           % Nombre de bits simul?s
BER_results = zeros(length(M_values), length(EbNo_dB_values));  % Matrice des BER

for m_idx = 1:length(M_values)
    M = M_values(m_idx);
    k = log2(M);                         % Nombre de bits par symbole

    for e_idx = 1:length(EbNo_dB_values)
        EbNo_dB = EbNo_dB_values(e_idx);
        EbNo = 10^(EbNo_dB/10);
        EsNo = EbNo * k;

        % G?n?ration des bits al?atoires
        bits = randi([0 1], numBits, 1);
        
        % Adapter ? un multiple de k
        nBits = floor(numBits / k) * k;
        bits = bits(1:nBits);

        % Regrouper les bits en symboles entiers
        symbols = bi2de(reshape(bits, [], k), 'left-msb');

        % Modulation QAM
        tx = qammod(symbols, M, 'UnitAveragePower', true, 'InputType', 'integer');

        % Bruit AWGN
        noiseSigma = sqrt(1 / (2 * EsNo));
        noise = noiseSigma * (randn(size(tx)) + 1i * randn(size(tx)));
        rx = tx + noise;

        % D?modulation
        demod_symbols = qamdemod(rx, M, 'UnitAveragePower', true, 'OutputType', 'integer');
        received_bits = de2bi(demod_symbols, k, 'left-msb');
        received_bits = received_bits(:);

        % Calcul du BER
        numErrors = sum(bits ~= received_bits);
        BER = numErrors / nBits;
        BER_results(m_idx, e_idx) = BER;

        fprintf('M = %d, Eb/No = %d dB, BER = %.4e\n', M, EbNo_dB, BER);
    end
end

% Tracer les r?sultats
figure; hold on; grid on;
colors = ['b', 'r', 'k', 'm', 'g'];  % Couleurs diff?rentes

for m_idx = 1:length(M_values)
    semilogy(EbNo_dB_values, BER_results(m_idx, :), ['-' colors(m_idx) 'o'], 'LineWidth', 2);
end

xlabel('Eb/No (dB)');
ylabel('Bit Error Rate (BER)');
title('BER pour diff?rents ordres de modulation QAM');
legend(arrayfun(@(x) sprintf('%d-QAM', x), M_values, 'UniformOutput', false));
hold off;
