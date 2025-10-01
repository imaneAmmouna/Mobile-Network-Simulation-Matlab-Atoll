M = [2, 4, 16, 64, 256];
bitrate = log2(M); % En supposant 1 symbole par seconde

plot(M, bitrate, '-o');
xlabel('Ordre de modulation (M-QAM ou M-PSK)');
ylabel('D?bit binaire (bits/symbole)');
title('D?bit binaire vs ordre de modulation');
grid on;
