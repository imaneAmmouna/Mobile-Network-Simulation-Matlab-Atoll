bitrate = [1e3, 1e4, 1e5, 1e6]; % en bps
latence = 1 ./ bitrate; % pour 1 bit

plot(bitrate, latence * 1e3, '-o'); % latence en ms
xlabel('D?bit binaire (bps)');
ylabel('Latence pour 1 bit (ms)');
title('Latence vs D?bit binaire');
grid on;
