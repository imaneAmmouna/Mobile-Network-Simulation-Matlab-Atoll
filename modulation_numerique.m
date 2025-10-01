% Param?tres communs
Tb = 1;                % Dur?e d'un bit (1 seconde)
fs = 100;              % Fr?quence d'?chantillonnage (Hz)
t = 0:1/fs:Tb-1/fs;    % Vecteur temps pour 1 bit
fc = 10;               % Fr?quence porteuse pour ASK et PSK (Hz)
f1 = 10;               % Fr?quence pour bit 0 en FSK (Hz)
f2 = 20;               % Fr?quence pour bit 1 en FSK (Hz)
N = 8;                 % Nombre de bits ? transmettre

% G?n?ration al?atoire de bits (0 ou 1)
bits = randi([0 1], 1, N);

% Initialisation des signaux modul?s
ASK_signal = [];
FSK_signal = [];
PSK_signal = [];

for i = 1:N
    % Signal ASK
    carrier_ASK = sin(2*pi*fc*t);
    if bits(i) == 1
        mod_ASK = carrier_ASK;
    else
        mod_ASK = zeros(size(carrier_ASK));
    end
    ASK_signal = [ASK_signal mod_ASK];
    
    % Signal FSK
    if bits(i) == 0
        carrier_FSK = sin(2*pi*f1*t);
    else
        carrier_FSK = sin(2*pi*f2*t);
    end
    FSK_signal = [FSK_signal carrier_FSK];
    
    % Signal PSK (BPSK) : bit 0 = sin(2*pi*fc*t), bit 1 = -sin(2*pi*fc*t)
    if bits(i) == 0
        mod_PSK = sin(2*pi*fc*t);
    else
        mod_PSK = -sin(2*pi*fc*t);
    end
    PSK_signal = [PSK_signal mod_PSK];
end

% Pr?parer la cha?ne de bits ? afficher
bits_str = sprintf('%d ', bits);

% Vecteur temps total pour N bits
t_total = 0:1/fs:Tb*N-1/fs;

% Affichage dans 3 sous-graphes
figure;

% ASK
subplot(3,1,1);
plot(t_total, ASK_signal);
title('Signal modul? ASK');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
x_pos = t_total(round(end/2));
y_pos = max(ASK_signal) + 0.5;
ylim([min(ASK_signal)-1, y_pos + 0.5]);
text(x_pos, y_pos, ['Bits transmis : ' bits_str], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

% FSK
subplot(3,1,2);
plot(t_total, FSK_signal);
title('Signal modul? FSK');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
x_pos = t_total(round(end/2));
y_pos = max(FSK_signal) + 0.5;
ylim([min(FSK_signal)-1, y_pos + 0.5]);
text(x_pos, y_pos, ['Bits transmis : ' bits_str], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

% PSK
subplot(3,1,3);
plot(t_total, PSK_signal);
title('Signal modul? PSK (BPSK)');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
x_pos = t_total(round(end/2));
y_pos = max(PSK_signal) + 0.5;
ylim([min(PSK_signal)-1, y_pos + 0.5]);
text(x_pos, y_pos, ['Bits transmis : ' bits_str], 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
