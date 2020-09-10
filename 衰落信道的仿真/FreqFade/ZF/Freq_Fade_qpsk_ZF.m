function [BER_Fade,BER_Fade_ZF] = Freq_Fade_qpsk_ZF(SNR)
% clear all
% %close 
% clc
%%%%%��ʼ��������%%%% %%%%%
N_packet = 1e5;
N_bits = 1e2;
% N_symbol_qpsk=N_bits/2;
% SNR = 0:5:40;
SNRR = 10.^(SNR./10);
SNR_len=length(SNR);
Data_bit = round(rand(N_bits,SNR_len));
BER_qpsk_index = zeros(SNR_len,N_packet);
BER_qpsk_Fade_index = BER_qpsk_index;
L = 6;%�ྶ����
L_vector=0:L-1;
%%%%%QPSK����%%%%%%%%%%%%%%%%%
Data_qpsk = qpsk_mod(Data_bit);
ES_qpsk = 2^(1/2);
[x,y]=size(Data_qpsk);
%%%%�źŷ���%%%%%%%%%%%%%%%%%%%%%%
Data_Tx_qpsk = zeros(x+L-1,y);%���ò���Ŀ鴫�䷽��
Data_Tx_qpsk(1:x,:) = Data_qpsk/ES_qpsk;%%����L-1��0��N=x,v=L-1;
%%%%�ŵ�%%%%%%%%%%%%%%%%%
L_rms=sqrt(mean((L_vector.^2))-mean(L_vector)^2);
P_Fade = exp(-(0:(L-1))/(L_rms));%%�����ӳٷֲ���ָ��˥��
P_Fade = P_Fade./sqrt(P_Fade*P_Fade');
%%%%Ƶ��ѡ����˥��%%%%%%%%%%%%%%%
for packet_index = 1:N_packet
    h = (randn(1,L)+1i*randn(1,L))*1/sqrt(2).*sqrt(P_Fade);%�����ྶ�ŵ�
    H=toeplitz([h zeros(1,x-1)],[h(1) zeros(1,x+L-2)]);
    %%T = toeplitz(c,r) ���طǶԳ��������ľ������� c ��Ϊ��һ�У�r ��Ϊ��һ�С���� c �� r ���׸�Ԫ�ز�ͬ��toeplitz ���������沢ʹ����Ԫ����Ϊ�Խ��ߡ�
    Data_Tx_qpsk_Fade = H*Data_Tx_qpsk;    
    %%�������ʣ�SNRRΪEb/N0����������Ǽӵ������ϣ����Ҫ��ΪES/N0
    SNRR_qpsk = SNRR*2;
    Pn_qpsk = 1./SNRR_qpsk;
    
    Noise_awgn_qpsk = 1/sqrt(2)*(Pn_qpsk).^(1/2).*(randn(x+L-1,y)+1i.*randn(x+L-1,y));%QPSK ����bit���һ�����ţ�ÿ�����Ŷ�Ӧ2
    %%%%����%%%%%%%%%%%%%%%%
    Data_Rx_qpsk = Data_Tx_qpsk_Fade + Noise_awgn_qpsk;
    %%%%ZF����%%%%%%%%%%%%%%
    H_ZF=toeplitz([h zeros(1,x-1)],[h(1) zeros(1,x-1)]);
    W_ZF=(H_ZF'*H_ZF)\H_ZF';
    Data_Rx_qpsk_correct = W_ZF*Data_Rx_qpsk;   
    %%%%���%%%%%%%%%%%%%%%
    Data_bit_Rx_qpsk_Fade = qpsk_demod(Data_Rx_qpsk(1:x,:));%δ���������Ľ����ֵ���൱�����SNR���ջ�
    Data_bit_Rx_qpsk = qpsk_demod(Data_Rx_qpsk_correct);%%���������Ľ����ֵ
    %%%%����������%%%%%%%%%
    num_error_qpsk_Fade = double(Data_bit_Rx_qpsk_Fade);
    BER_qpsk_Fade_index(:,packet_index)=mean(num_error_qpsk_Fade);%%%δ��������õ���������
    num_error_qpsk = double(Data_bit~=Data_bit_Rx_qpsk);
    BER_qpsk_index(:,packet_index)=mean(num_error_qpsk);%%%���������õ���������

end
BER_Fade = mean(BER_qpsk_Fade_index,2);
BER_Fade_ZF = mean(BER_qpsk_index,2);
% figure;
% semilogy(SNR,BER_qpsk,'o-','linewidth',2);
% hold on
% grid on
% axis([min(SNR) max(SNR) 1e-7 1]);
% xlabel('E_S/N_0');
% ylabel('BER');
% title('E_S/N_0~BER');
% legend('QPSK:ZF');




end