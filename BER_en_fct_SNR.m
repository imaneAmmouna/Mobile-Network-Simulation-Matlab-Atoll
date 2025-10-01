EbNo = 0:2:20;
ber_bpsk = berawgn(EbNo, 'psk', 2, 'nondiff');
ber_qpsk = berawgn(EbNo, 'psk', 4, 'nondiff');
ber_16qam = berawgn(EbNo, 'qam', 16);
ber_64qam = berawgn(EbNo, 'qam', 64);

semilogy(EbNo, ber_bpsk, '-o', EbNo, ber_qpsk, '-x', EbNo, ber_16qam, '-s', EbNo, ber_64qam, '-^');
legend('BPSK', 'QPSK', '16QAM', '64QAM');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR pour diff?rentes modulations');
grid on;
