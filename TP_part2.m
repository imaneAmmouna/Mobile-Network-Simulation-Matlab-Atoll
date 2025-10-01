% ************ creer la carte du MAROC ************
% D?finir les limites g?ographiques (latitude et longitude) pour le Maroc
latlim = [20 37];    % latitude sud et nord approximatives
lonlim = [-18 -1];   % longitude ouest et est approximatives

% Cr?er une nouvelle figure
figure;

% Utiliser axesm pour d?finir la projection (ici Mercator)
axesm('mercator', 'MapLatLimit', latlim, 'MapLonLimit', lonlim);

% Afficher la carte avec les fronti?res des pays
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8]); % terre en gris clair

% Ajouter les fronti?res des pays
geoshow('worldlo.shp', 'Color', 'black');

% Ajouter un titre
title('Carte du Maroc centr?e');

% Activer la grille des latitudes/longitudes
gridm on;
mlabel on;
plabel on;

% Optionnel : zoom sur la zone
setm(gca, 'MapLatLimit', latlim, 'MapLonLimit', lonlim);
