clear 
close all
clc

addpath('../mod_demod');
%%%%%��ʼ��������%%%% %%%%%
N_packet = 1e7;
N_symbol_qpsk=N_packet/2;
N_symbol_16qam = N_packet/4;
SNR = 5:1:20;
SNRR = 10.^(SNR./10);
SNR_len=length(SNR);
Data_bit = round(rand(N_packet,SNR_len));
%%%%%QPSK����%%%%%%%%%%%%%%%%%
Data_qpsk = qpsk_mod(Data_bit);
ES_qpsk = 2^(1/2);
%%%%16QAM����%%%%%%%%%%%%%%%%%%%%%%
Data_16qam=qam16_mod(Data_bit); 
ES_16qam = sqrt(10);%16QAM�Ĺ��ʹ�һ�����ӣ�2*1/4*2*��1^2+3^2)
%%%%�źŷ���%%%%%%%%%%%%%%%%%%%%%%
Data_Tx_qpsk = Data_qpsk/ES_qpsk;
Data_Tx_16qam = Data_16qam/ES_16qam;%������һ������ÿ�����ŵ�������Ϊ1
%%%%�ŵ�%%%%%%%%%%%%%%%%%
%%�������ʣ�SNRRΪEb/N0����������Ǽӵ������ϣ����Ҫ��ΪES/N0
SNRR_qpsk = SNRR*2;
SNRR_16qam = SNRR*4;
Pn_qpsk = 1./SNRR_qpsk;
Pn_16qam = 1./SNRR_16qam;
Noise_awgn_qpsk = 1/sqrt(2)*(Pn_qpsk).^(1/2).*(randn(N_symbol_qpsk,SNR_len)+1i.*randn(N_symbol_qpsk,SNR_len));%QPSK ����bit���һ�����ţ�ÿ�����Ŷ�Ӧ2
Noise_awgn_16qam = 1/sqrt(2)*(Pn_16qam).^(1/2).*(randn(N_symbol_16qam,SNR_len)+1i.*randn(N_symbol_16qam,SNR_len));%%���ɸ�˹����
%%%%����%%%%%%%%%%%%%%%%
Data_Rx_qpsk = Data_Tx_qpsk + Noise_awgn_qpsk;
Data_Rx_16qam = Data_Tx_16qam + Noise_awgn_16qam;

Data_bit_Rx_qpsk = qpsk_demod(Data_Rx_qpsk);
Data_bit_Rx_16qam = qam16_demod(Data_Rx_16qam);

num_error_qpsk = double(Data_bit~=Data_bit_Rx_qpsk);
BER_qpsk = mean(num_error_qpsk);
BER_qpsk_t = 1/2*erfc(SNRR.^(1/2));%%Q(a)=1/2*erfc(a/2^(1/2))
num_error_16qam = double(Data_bit ~= Data_bit_Rx_16qam);
BER_16qam = mean(num_error_16qam);
BER_16qam_t = 4/log(16)*(1-1/4).*1/2*erfc(((2/5)*SNRR).^(1/2));

%%����ͼ
figure;
plot(real(Data_Rx_qpsk(:,6)*ES_qpsk),imag(Data_Rx_qpsk(:,6)*ES_qpsk),'b.','linewidth',2);
hold on
plot(real(Data_qpsk(:,6)),imag(Data_qpsk(:,6)),'ro','linewidth',2);
grid on 
xlabel('I');
ylabel('Q');
axis equal;
title('constellation diagram:QPSK 10dB');

figure;
plot(real(Data_Rx_16qam(:,6)*ES_16qam),imag(Data_Rx_16qam(:,6)*ES_16qam),'b.','linewidth',2);
hold on
plot(real(Data_16qam(:,6)),imag(Data_16qam(:,6)),'ro','linewidth',2);
grid on 
xlabel('I');
ylabel('Q');
axis equal;
title('constellation diagram:16QAM 10dB');


figure;
semilogy(SNR,BER_qpsk,'o-','linewidth',2);
hold on
semilogy(SNR,BER_qpsk_t,'o-','linewidth',2);
hold on
semilogy(SNR,BER_16qam,'o-','linewidth',2);
hold on 
semilogy(SNR,BER_16qam_t,'o-','linewidth',2);
grid on
axis([min(SNR) max(SNR) 1e-7 1]);
xlabel('E_b/N_0');
ylabel('BER');
title('E_b/N_0~BER')
legend('QPSK','QPSK-Theoratical','16QAM','16QAM-Theoratical');



