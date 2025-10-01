% Param?tres
M = 16;                % Ordre de la modulation QAM (16-QAM)
k = log2(M);           % Nombre de bits par symbole
N_sym = 100;           % Nombre de symboles ? transmettre

% G?n?ration al?atoire de bits
bits = randi([0 1], 1, N_sym * k);

% Mapping bits -> symboles (groupes de k bits)
symbols_dec = bi2de(reshape(bits, k, []).', 'left-msb');  % Conversion binaire vers d?cimal

% Cr?ation de l'objet modulateur QAM
qam_mod = comm.RectangularQAMModulator(M, 'BitInput', false);

% Modulation avec step (ou appel? comme une fonction si MATLAB r?cent)
modulated_symbols = step(qam_mod, symbols_dec);

% Affichage de la constellation
figure;
scatterplot(modulated_symbols);
title('Diagramme de constellation 16-QAM');
grid on;

% Affichage des bits transmis (une partie pour lisibilit?)
disp('Quelques bits transmis (par symboles) :');
disp(reshape(bits, k, []).');

% Affichage temporel (partie r?elle)
figure;
plot(real(modulated_symbols));
title('Signal module 16-QAM (partie reelle)');
xlabel('Symbole');
ylabel('Amplitude');
grid on;
