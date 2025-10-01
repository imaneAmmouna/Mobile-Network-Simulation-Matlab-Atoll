clc;
clear all;
close all;

%% 1. Param?tres
Nb_bits = 5;  % nombre de bits par utilisateur
chip_length = 6;

%% 2. Donn?es binaires al?atoires pour A, B, C
data_A = randi([0 1], 1, Nb_bits);
data_B = randi([0 1], 1, Nb_bits);
data_C = randi([0 1], 1, Nb_bits);

%% 3. Codes d??talement orthogonaux (Walsh codes simples)
a_code = [1 -1 -1 1 -1 1];
b_code = [1 1 -1 -1 1 1];
c_code = [1 1 -1 1 1 -1];

%% 4. Codage des bits : bit=1 ? code, bit=0 ? -code
signal_A = [];
signal_B = [];
signal_C = [];

for i = 1:Nb_bits
    if data_A(i) == 1
        signal_A = [signal_A a_code];
    else
        signal_A = [signal_A -a_code];
    end

    if data_B(i) == 1
        signal_B = [signal_B b_code];
    else
        signal_B = [signal_B -b_code];
    end

    if data_C(i) == 1
        signal_C = [signal_C c_code];
    else
        signal_C = [signal_C -c_code];
    end
end

%% 5. Superposition du signal total (principe du CDMA)
signal_total = signal_A + signal_B + signal_C;

%% 6. D?codage par produit scalaire (correlation avec chaque code)
decoded_A = [];
decoded_B = [];
decoded_C = [];

for i = 1:chip_length:length(signal_total)
    segment = signal_total(i:i+chip_length-1);

    res_A = dot(segment, a_code);
    res_B = dot(segment, b_code);
    res_C = dot(segment, c_code);

    decoded_A = [decoded_A (res_A > 0)];
    decoded_B = [decoded_B (res_B > 0)];
    decoded_C = [decoded_C (res_C > 0)];
end

%% 7. Trac? du signal transmis
figure;
plot(1:length(signal_total), signal_total, 'k', 'LineWidth', 2);
title('Signal CDMA transmis (somme des signaux A, B, C)');
xlabel('Temps');
ylabel('Amplitude');
grid on;

%% 8. Figure 2 : signaux individuels (avant sommation)
t_A = 1:length(signal_A);
t_B = 1:length(signal_B);
t_C = 1:length(signal_C);

figure;

subplot(3,1,1);
plot(t_A, signal_A, 'r', 'LineWidth', 2);
title(['Signal A - Bits : ', num2str(data_A)]);
xlabel('Temps');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(t_B, signal_B, 'g', 'LineWidth', 2);
title(['Signal B - Bits : ', num2str(data_B)]);
xlabel('Temps');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(t_C, signal_C, 'b', 'LineWidth', 2);
title(['Signal C - Bits : ', num2str(data_C)]);
xlabel('Temps');
ylabel('Amplitude');
grid on;

%% 9. Affichage des r?sultats de d?codage
disp('Bits transmis A :'); disp(data_A);
disp('Bits d?cod?s A  :'); disp(decoded_A);

disp('Bits transmis B :'); disp(data_B);
disp('Bits d?cod?s B  :'); disp(decoded_B);

disp('Bits transmis C :'); disp(data_C);
disp('Bits d?cod?s C  :'); disp(decoded_C);
