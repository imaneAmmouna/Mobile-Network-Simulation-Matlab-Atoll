BER = logspace(-6, 0, 100);
QoS = 100 * exp(-30 * BER); % mod?le simplifi?

figure;
semilogx(BER, QoS, 'r', 'LineWidth', 2);
xlabel('Bit Error Rate (BER)');
ylabel('QoS (%)');
title('Impact du BER sur la Qualit? de Service');
grid on;
