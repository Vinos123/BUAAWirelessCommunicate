clear 
close all
clc
addpath('../mod_demod');
%%%%%��ʼ��������%%%% %%%%%
N_packet = 1e4;
N_bits = 1e4;
N_symbol_qpsk=N_bits/2;
SNR = 0:5:40;
SNRR = 10.^(SNR./10);
SNR_len=length(SNR);
Data_bit = round(rand(N_bits,SNR_len));
BER_qpsk_index = zeros(SNR_len,N_packet);
%%%%%QPSK����%%%%%%%%%%%%%%%%%
Data_qpsk = qpsk_mod(Data_bit);
ES_qpsk = 2^(1/2);
%%%%�źŷ���%%%%%%%%%%%%%%%%%%%%%%
Data_Tx_qpsk = Data_qpsk/ES_qpsk;
%%%%�ŵ�%%%%%%%%%%%%%%%%%
%%%%ƽ˥��%%%%%%%%%%%%%%%
for packet_index = 1:N_packet
    h = (randn+1i*randn)*1/sqrt(2);
    Data_Tx_qpsk_Fade = Data_Tx_qpsk*h;

    %%�������ʣ�SNRRΪEb/N0����������Ǽӵ������ϣ����Ҫ��ΪES/N0
    SNRR_qpsk = SNRR*2;
    Pn_qpsk = 1./SNRR_qpsk;
    Noise_awgn_qpsk = 1/sqrt(2)*(Pn_qpsk).^(1/2).*(randn(N_symbol_qpsk,SNR_len)+1i.*randn(N_symbol_qpsk,SNR_len));%QPSK ����bit���һ�����ţ�ÿ�����Ŷ�Ӧ2
    %%%%����%%%%%%%%%%%%%%%%
    Data_Rx_qpsk = Data_Tx_qpsk_Fade + Noise_awgn_qpsk;
    Data_Rx_qpsk_correct = Data_Rx_qpsk*conj(h);

    Data_bit_Rx_qpsk = qpsk_demod(Data_Rx_qpsk_correct);

    num_error_qpsk = double(Data_bit~=Data_bit_Rx_qpsk);
    BER_qpsk_index(:,packet_index)=mean(num_error_qpsk);

end
BER_qpsk = mean(BER_qpsk_index,2);
BER_qpsk_t = 1/2*(1-sqrt(SNRR./(SNRR+1)));
%%%����ͼ
figure;
plot(real(Data_Rx_qpsk(:,4)*ES_qpsk),imag(Data_Rx_qpsk(:,4)*ES_qpsk),'b.','linewidth',2);
hold on
plot(real(Data_qpsk(:,4)),imag(Data_qpsk(:,4)),'ro','linewidth',2);
grid on 
xlabel('I');
ylabel('Q');
axis equal;
title('constellation diagram:QPSK 15dB');

figure;
plot(real(Data_Rx_qpsk_correct(:,4)*ES_qpsk),imag(Data_Rx_qpsk_correct(:,4)*ES_qpsk),'b.','linewidth',2);
hold on
plot(real(Data_qpsk(:,4)),imag(Data_qpsk(:,4)),'ro','linewidth',2);
grid on 
xlabel('I');
ylabel('Q');
axis equal;
title('constellation diagram:QPSK 15dB after balance');
%%%������
figure;
semilogy(SNR,BER_qpsk,'o-','linewidth',2);
hold on
semilogy(SNR,BER_qpsk_t,'o-','linewidth',2);
hold on

grid on
axis([min(SNR) max(SNR) 1e-7 1]);
xlabel('E_b/N_0');
ylabel('BER');
title('E_b/N_0~BER')
legend('QPSK','QPSK-Theoratical');



