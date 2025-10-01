% Donn?es binaires ? transmettre
bits = [1 0 1 1 0 0 1 0];

% ===========================
% TRANSMISSION S?RIE
% ===========================
T_bit = 1;                           % dur?e d?un bit
Fs = 100;                           % fr?quence d??chantillonnage pour l?affichage
t_serie = linspace(0, length(bits), length(bits)*Fs);

% Signal s?rie r?p?t? (chaque bit r?p?t? Fs fois)
signal_serie = repelem(bits, Fs);

% ===========================
% TRANSMISSION PARALL?LE
% ===========================
bits_parallel = reshape(bits, 2, []); % 2 lignes (canaux), plusieurs colonnes
signal_par_1 = repelem(bits_parallel(1,:), Fs);
signal_par_2 = repelem(bits_parallel(2,:), Fs);
t_parallele = linspace(0, size(bits_parallel,2), length(signal_par_1));

% ===========================
% AFFICHAGE
% ===========================
figure;

% Transmission s?rie
subplot(2,1,1);
plot(t_serie, signal_serie, 'b', 'LineWidth', 2);
ylim([-0.2 1.2]); grid on;
xlabel('Temps');
ylabel('Niveau');
title('Transmission S?rie');

% Ajouter les bits au-dessus de chaque segment
for k = 1:length(bits)
    text(k-0.5, 1.1, num2str(bits(k)), 'FontSize', 12, 'HorizontalAlignment', 'center');
end

% Transmission parall?le
subplot(2,1,2);
plot(t_parallele, signal_par_1, 'r', 'LineWidth', 2); hold on;
plot(t_parallele, signal_par_2, 'g', 'LineWidth', 2);
ylim([-0.2 1.2]); grid on;
xlabel('Temps');
ylabel('Niveau');
title('Transmission Parall?le (2 canaux)');
legend('Canal 1', 'Canal 2');

% Ajouter les bits pour canal 1
for k = 1:size(bits_parallel,2)
    text(k-0.5, 1.1, num2str(bits_parallel(1,k)), 'Color', 'r', 'FontSize', 12, 'HorizontalAlignment', 'center');
end
% Ajouter les bits pour canal 2
for k = 1:size(bits_parallel,2)
    text(k-0.5, 0.1, num2str(bits_parallel(2,k)), 'Color', 'g', 'FontSize', 12, 'HorizontalAlignment', 'center');
end
