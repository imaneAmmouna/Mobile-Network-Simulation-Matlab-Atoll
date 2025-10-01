clc; clear; close all;

% Signal analogique (ex. sinuso?de)
f = 2;                      % fr?quence du signal (Hz)
t_continu = 0:0.001:1;      % temps "continu" (pas fin)
x_analogique = sin(2*pi*f*t_continu);  % signal analogique

% === ?CHANTILLONNAGE ===
Fe = 20;                   % fr?quence d'?chantillonnage (Hz)
Te = 1/Fe;
t_ech = 0:Te:1;            % instants d'?chantillonnage
x_echant = sin(2*pi*f*t_ech);  % ?chantillons du signal

% === QUANTIFICATION ===
nb_niveaux = 8;                         % quantification ? 8 niveaux (3 bits)
x_min = -1; x_max = 1;
q_step = (x_max - x_min)/(nb_niveaux-1);  % pas de quantification
x_quant = round((x_echant - x_min)/q_step) * q_step + x_min;  % quantification uniforme

% === CODAGE BINAIRE ===
indices = round((x_quant - x_min)/q_step);      % indices des niveaux (0 ? 7)
nb_bits = ceil(log2(nb_niveaux));               % nombre de bits par niveau (3 bits)
bin_codes = dec2bin(indices, nb_bits);          % conversion indices -> binaire

% Affichage codes binaires dans la console
fprintf('Echantillon\tAmplitude\tIndice\tCode binaire\n');
for i=1:length(indices)
    fprintf('%d\t\t%.2f\t\t%d\t%s\n', i, x_quant(i), indices(i), bin_codes(i,:));
end

% === AFFICHAGE GRAPHIQUE ===
figure;

% Signal analogique continu
plot(t_continu, x_analogique, 'b', 'LineWidth', 1.5); hold on;

% Points d'?chantillonnage
stem(t_ech, x_echant, 'r', 'filled');

% Signal quantifi? (marche d'escalier)
stairs(t_ech, x_quant, 'k--', 'LineWidth', 1.5);

grid on;
xlabel('Temps (s)');
ylabel('Amplitude');
title('Num?risation d''un signal analogique : ?chantillonnage, quantification et codage');
legend('Signal analogique', '?chantillons', 'Quantification');

