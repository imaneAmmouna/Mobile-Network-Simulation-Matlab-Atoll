clc; clear;

% --- Coordonn?es d'antennes GSM autour de Taza ---
antennes = [
    34.210, -4.010;  % Taza centre
    34.220, -4.000;  % Nord-est
    34.200, -4.020;  % Sud-ouest
    34.215, -4.030;  % Ouest
    34.205, -4.000   % Sud-est
];

% --- Param?tres pour le mod?le Okumura-Hata ---
f = 900;       % Fr?quence en MHz (GSM 900)
hb = 50;       % Hauteur de l'antenne (m)
hm = 1.5;      % Hauteur du mobile (m)
L = 50;        % Pertes admises (dB) pour d?finir le rayon de couverture

% --- Calcul du rayon de couverture ---
a_hm = (1.1 * log10(f) - 0.7) * hm - (1.56 * log10(f) - 0.8);
A = 69.55 + 26.16*log10(f) - 13.82*log10(hb) - a_hm;
B = 44.9 - 6.55*log10(hb);
log_d = (L - A) / B;
d_km = 10^log_d;  % Rayon en km

fprintf('Rayon de couverture estim? (par cellule) : %.2f km\n', d_km);

% --- Affichage de la carte ---
webmap('OpenStreetMap');
wmcenter(mean(antennes(:,1)), mean(antennes(:,2)));
wmlimits([min(antennes(:,1))-0.05, max(antennes(:,1))+0.05], ...
         [min(antennes(:,2))-0.05, max(antennes(:,2))+0.05]);

% --- Afficher les antennes et leur couverture ---
for i = 1:size(antennes,1)
    lat0 = antennes(i,1);
    lon0 = antennes(i,2);
    
    % Marqueur antenne
    wmmarker(lat0, lon0, 'FeatureName', sprintf('Antenne %d', i), ...
        'Description', 'Station de base GSM');

    % Cercle de couverture
    angles = linspace(0, 360, 360);
    [lat_circle, lon_circle] = reckon(lat0, lon0, d_km, angles);
    wmline(lat_circle, lon_circle, 'Color', 'blue', 'Width', 2);
end
