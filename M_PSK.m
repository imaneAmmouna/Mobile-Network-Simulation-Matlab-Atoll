% Param?tres
M = 8;                         % Ordre de modulation (8-PSK)
k = log2(M);                   % Nombre de bits par symbole
N_sym = 100;                   % Nombre de symboles

% G?n?ration al?atoire de bits
bits = randi([0 1], 1, N_sym * k);

% Regrouper les bits en symboles d?cimaux
symbols = bi2de(reshape(bits, k, []).', 'left-msb');  % symboles entre 0 et M-1

% Modulation PSK (phase offset = 0)
modulated_symbols = pskmod(symbols, M, 0);  % signal modul? complexe

% Affichage de la constellation
figure;
scatterplot(modulated_symbols);
title([num2str(M), '-PSK : Constellation']);
grid on;

% Affichage temporel (partie r?elle)
figure;
plot(real(modulated_symbols));
xlabel('Symbole');
ylabel('Amplitude');
title([num2str(M), '-PSK : Partie r?elle du signal modul?']);
grid on;
