% --- Coordonn?es de l'antenne GSM ? Taza ---
lat0 = 34.21;
lon0 = -4.01;

% --- Calcul du rayon de couverture avec Okumura-Hata ---
f = 900;       % MHz
hb = 50;       % m
hm = 1;      % m
L = 50;       % dB

a_hm = (1.1 * log10(f) - 0.7) * hm - (1.56 * log10(f) - 0.8);
A = 69.55 + 26.16*log10(f) - 13.82*log10(hb) - a_hm;
B = 44.9 - 6.55*log10(hb);
log_d = (L - A) / B;
d_km = 10^log_d;

fprintf('Rayon de couverture estim? : %.2f km\n', d_km)

% --- Ouvrir une carte web centr?e sur Taza ---
webmap('OpenStreetMap');
wmcenter(lat0, lon0);
wmlimits([lat0-0.05, lat0+0.05], [lon0-0.05, lon0+0.05]);

% --- Afficher un marqueur pour l'antenne ---
antenne = wmmarker(lat0, lon0, 'FeatureName', 'Antenne GSM', 'Description', 'Station de base GSM');

% --- Cr?er un cercle de couverture autour de l?antenne ---
angles = linspace(0, 360, 360);
[lat_circle, lon_circle] = reckon(lat0, lon0, d_km, angles);  % rayon en km

% --- Afficher le cercle de couverture ---
wmline(lat_circle, lon_circle, 'Color', 'blue', 'Width', 2, 'FeatureName', 'Couverture GSM');
