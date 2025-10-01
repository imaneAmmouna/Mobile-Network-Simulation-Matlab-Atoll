clc; clear;

%% 1. Param?tres 3G
lat0 = 34.21;      % Latitude de Taza
lon0 = -4.01;      % Longitude de Taza

f = 2100;          % Fr?quence en MHz (3G - UMTS)
hb = 40;           % Hauteur de l'antenne (station de base)
hm = 1.5;          % Hauteur du terminal mobile
L = 120;           % Perte moyenne en zone urbaine dense (dB)

% Placement de plusieurs antennes autour de Taza
offsets = [0.01 0.01; -0.01 0.015; 0.015 -0.01];
nb_antennes = size(offsets, 1);
antennes_lat = lat0 + offsets(:,1);
antennes_lon = lon0 + offsets(:,2);

%% 2. Mod?le Okumura-Hata adapt? (ou COST-231 Hata)
% Correction urbaine
a_hm = (1.1 * log10(f) - 0.7) * hm - (1.56 * log10(f) - 0.8);

% Formule principale (zone urbaine, f > 1500 MHz ? COST231-Hata)
A = 46.3 + 33.9*log10(f) - 13.82*log10(hb) - a_hm;
B = 44.9 - 6.55*log10(hb);

log_d = (L - A) / B;
d_km = 10^log_d;

fprintf('Rayon de couverture estim? (3G) : %.2f km\n', d_km);

%% 3. Carte interactive
webmap('OpenStreetMap');
wmcenter(lat0, lon0);
wmlimits([lat0-0.05, lat0+0.05], [lon0-0.05, lon0+0.05]);

for i = 1:nb_antennes
    wmmarker(antennes_lat(i), antennes_lon(i), ...
        'FeatureName', sprintf('Antenne 3G %d', i), ...
        'Description', sprintf('Couverture ~ %.2f km', d_km));
    
    angles = linspace(0, 360, 360);
    [lat_circle, lon_circle] = reckon(antennes_lat(i), antennes_lon(i), d_km, angles);
    
    wmline(lat_circle, lon_circle, 'Color', 'green', 'Width', 2, ...
        'FeatureName', sprintf('Couverture 3G Antenne %d', i));
end
