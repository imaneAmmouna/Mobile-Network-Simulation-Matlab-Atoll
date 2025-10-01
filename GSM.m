clc; clear;

% Coordonn?es GPS de Taza
latTaza = 34.22;
lonTaza = -4.02;

% Param?tres antenne GSM (exemple)
freqGSM = 900e6;      % fr?quence GSM en Hz
PuissanceTx_dBm = 43; % Puissance Tx typique (20W = 43 dBm)
hauteurAntenne = 30;  % hauteur en m?tres

% Calcul du rayon de couverture avec mod?le Okumura-Hata simplifi?
freqMHz = freqGSM / 1e6;
PLmax = PuissanceTx_dBm - (-104); % Puissance Tx - sensibilit? Rx
hBS = hauteurAntenne;

d_km = 10^((PLmax - 69.55 - 26.16*log10(freqMHz) + 13.82*log10(hBS)) / (44.9 - 6.55*log10(hBS)));
fprintf('Rayon de couverture estim? : %.2f km\n', d_km);

% Ouvre une carte Web interactive centr?e sur Taza
wm = webmap('OpenStreetMap');
wmcenter(wm, latTaza, lonTaza, 12); % centre sur Taza, zoom = 12

% Place un marqueur antenne GSM
wmmarker(wm, latTaza, lonTaza, 'FeatureName', 'Antenne GSM');

% Tracer un cercle de couverture (polygone approch?)
theta = linspace(0, 2*pi, 100);
rayon_deg = d_km / 111; % Approximation conversion km -> degr?s

lat_cercle = latTaza + rayon_deg * cos(theta);
lon_cercle = lonTaza + rayon_deg * sin(theta) ./ cosd(latTaza);

% Ajouter un polygone pour simuler le cercle
wmpolygon(wm, lat_cercle, lon_cercle, ...
    'FaceColor', 'cyan', 'EdgeColor', 'blue', 'FaceAlpha', 0.3, 'LineWidth', 2);
