% Temps de pause entre les animations
pause_time = 0.8;

% Positions des n?uds A et B
A = [1, 1]; 
B = [4, 1];

figure;
axis([0 5 0 2]); axis off;
title('Modes de communication : Simplex / Half-Duplex / Full-Duplex');

% --- SIMPLEX ---
text(2.3, 1.8, 'Simplex', 'FontSize', 12, 'FontWeight', 'bold');
plot([A(1) B(1)], [A(2) B(2)], 'k--');
hold on;
plot(A(1), A(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot(B(1), B(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Fl?che de A ? B
quiver(A(1), A(2), B(1)-A(1)-0.2, 0, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
pause(pause_time);

clf; % clear pour l?animation suivante

% --- HALF-DUPLEX ---
axis([0 5 0 2]); axis off;
text(2.1, 1.8, 'Half-Duplex', 'FontSize', 12, 'FontWeight', 'bold');
plot([A(1) B(1)], [A(2) B(2)], 'k--');
hold on;
plot(A(1), A(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot(B(1), B(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Fl?che A ? B
quiver(A(1), A(2), B(1)-A(1)-0.2, 0, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
pause(pause_time);

% Fl?che B ? A
quiver(B(1), B(2), -(B(1)-A(1)-0.2), 0, 0, 'g', 'LineWidth', 2, 'MaxHeadSize', 0.5);
pause(pause_time);

clf;

% --- FULL-DUPLEX ---
axis([0 5 0 2]); axis off;
text(2.1, 1.8, 'Full-Duplex', 'FontSize', 12, 'FontWeight', 'bold');
plot([A(1) B(1)], [A(2) B(2)], 'k--');
hold on;
plot(A(1), A(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot(B(1), B(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

% Fl?ches dans les deux sens
quiver(A(1), A(2), B(1)-A(1)-0.2, 0, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
quiver(B(1), B(2), -(B(1)-A(1)-0.2), 0, 0, 'g', 'LineWidth', 2, 'MaxHeadSize', 0.5);
