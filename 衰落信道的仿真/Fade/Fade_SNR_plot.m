clear
close all
clc

addpath('../mod_demod');

SNR=0:5:50;

[BER_qpsk,BER_qpsk_t]=Fade_SNR_qpsk_plot(SNR);
[BER_16qam,BER_16qam_t]=Fade_SNR_16qam_plot(SNR);

semilogy(SNR,BER_qpsk,'o-','linewidth',2);
hold on
semilogy(SNR,BER_qpsk_t,'o-','linewidth',2);
hold on 
semilogy(SNR,BER_16qam,'o-','linewidth',2);
hold on
semilogy(SNR,BER_16qam_t,'o-','linewidth',2);
grid on
xlabel('E_b/N_0');
ylabel('BER');
legend('QPSK','QPSK-Theoratical','16QAM','16QAM-Theoratical');
title('BER~E_b/N_0');