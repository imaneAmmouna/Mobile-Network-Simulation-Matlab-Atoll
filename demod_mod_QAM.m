% Param?tres
EbNo_dB_values = 0:2:20;           % Valeurs de Eb/No en dB
M_values = [4, 16, 64];             % Ordres de modulation QAM
BER_results = zeros(length(M_values), length(EbNo_dB_values));  % Stockage des BER

model = 'mod_demod_QAM';            % Nom du mod?le Simulink
open_system(model);                 % Ouvre le mod?le

for m_idx = 1:length(M_values)
    M = M_values(m_idx);
    for e_idx = 1:length(EbNo_dB_values)
        EbNo_dB = EbNo_dB_values(e_idx);

        % Passer les param?tres au workspace base
        assignin('base', 'M', M);
        assignin('base', 'EbNo_dB', EbNo_dB);

        % Mise ? jour du mod?le
        set_param(model, 'SimulationCommand', 'update');

        % Lancer la simulation
        simOut = sim(model, 'StopTime', '5');

        % Afficher les variables retourn?es (debug)
        vars = fieldnames(simOut);
        fprintf('Variables retourn?es pour M=%d, EbNo_dB=%d :\n', M, EbNo_dB);
        disp(vars);

        % Initialiser BER_val ? NaN
        BER_val = NaN;

        % R?cup?rer la variable BER (format Array)
        if ismember('BER', vars)
            BER_var = simOut.BER;  % BER est un vecteur (array)

            if isnumeric(BER_var) && ~isempty(BER_var)
                BER_val = BER_var(end); % Derni?re valeur BER simul?e
            else
                warning('BER est vide ou pas num?rique.');
            end
        else
            warning('Variable BER non trouv?e dans la simulation.');
        end

        % Stocker le BER dans la matrice de r?sultats
        BER_results(m_idx, e_idx) = BER_val;

        % Afficher la valeur calcul?e
        fprintf('M = %d, Eb/No = %d dB, BER = %.6e\n', M, EbNo_dB, BER_val);
    end
end

% Tracer les r?sultats BER vs Eb/No
figure; hold on; grid on;
colors = ['b', 'r', 'k']; % Couleurs pour chaque M

for m_idx = 1:length(M_values)
    semilogy(EbNo_dB_values, BER_results(m_idx, :), ['-' colors(m_idx) 'o'], 'LineWidth', 2);
end

xlabel('Eb/No (dB)');
ylabel('Bit Error Rate (BER)');
title('Comparaison BER pour diff?rents ordres de modulation QAM');
legend(arrayfun(@(x) sprintf('%d-QAM', x), M_values, 'UniformOutput', false));
hold off;
