clear 
close all
clc
addpath('../../mod_demod');
addpath('../ZF');
addpath('../MMSE');
%%%%对比频率选择性衰落信道下不同均衡方式的误码率
SNR = 0:5:40; 
[BER_qpsk_Fade,BER_qpsk_Fade_ZF]=Freq_Fade_qpsk_ZF(SNR);
[BER_16qam_Fade,BER_16qam_Fade_ZF]=Freq_Fade_16qam_ZF(SNR);
BER_qpsk_Fade_MMSE=Freq_Fade_qpsk_MMSE(SNR);
BER_16qam_Fade_MMSE=Freq_Fade_16qam_MMSE(SNR);
figure;
semilogy(SNR,BER_qpsk_Fade,'o-','linewidth',2); 
hold on
semilogy(SNR,BER_qpsk_Fade_ZF,'o-','linewidth',2);
hold on 
semilogy(SNR,BER_qpsk_Fade_MMSE,'o-','linewidth',2);
hold on 
semilogy(SNR,BER_16qam_Fade,'o-','linewidth',2);
hold on
semilogy(SNR,BER_16qam_Fade_ZF,'o-','linewidth',2);
hold on 
semilogy(SNR,BER_16qam_Fade_MMSE,'o-','linewidth',2);
grid on
axis([min(SNR) max(SNR) 1e-6 1]);
xlabel('E_b/N_0');
ylabel('BER');
title('E_b/N_0~BER');
legend('QPSK','QPSK:ZF','QPSK:MMSE','16QAM','16QAM:ZF','16QAM:MMSE');