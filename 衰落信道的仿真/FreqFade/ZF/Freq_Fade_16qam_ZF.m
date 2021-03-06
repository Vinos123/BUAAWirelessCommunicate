function [BER_Fade,BER_Fade_ZF] = Freq_Fade_16qam_ZF(SNR)
% clear all
% close 
% clc
%%%%%初始参数设置%%%% %%%%%
N_packet = 1e5;
N_bits = 1e2;
% N_symbol_16qam = N_bits/4;
L=6;%%可分辨的多径条数
% SNR = 0:5:40;
SNRR = 10.^(SNR./10);   
SNR_len=length(SNR);    
Data_bit = round(rand(N_bits,SNR_len));
BER_16qam_index = zeros(SNR_len,N_packet);
BER_16qam_Fade_index=BER_16qam_index;
L_vector=0:L-1;
%%%%16QAM调制%%%%%%%%%%%%%%%%%%%%%%
Data_16qam=qam16_mod(Data_bit); 
ES_16qam = sqrt(10);%16QAM的功率归一化因子，2*1/4*2*（1^2+3^2)
[x,y]=size(Data_16qam);
%%%%信号发送%%%%%%%%%%%%%%%%%%%%%%
Data_Tx_16qam = zeros(x+L-1,y);
Data_Tx_16qam(1:x,:) = Data_16qam/ES_16qam;%能量归一化，将每个符号的能量归为1
%%%%信道%%%%%%%%%%%%%%%%%
L_rms=sqrt(mean((L_vector.^2))-mean(L_vector)^2);
P_Fade = exp(-(0:(L-1))/(L_rms));%%功率延迟分布呈指数衰减
P_Fade = P_Fade./sqrt(P_Fade*P_Fade');
%%%%平衰落%%%%%%%%%%%%%%% 
for packet_index = 1:N_packet
    h = (randn(1,L)+1i*randn(1,L))*1/sqrt(2).*sqrt(P_Fade);%产生多径信道
    H=toeplitz([h zeros(1,x-1)],[h(1) zeros(1,x+L-2)]);
    Data_Tx_16qam_Fade = H*Data_Tx_16qam;
    %%噪声功率，SNRR为Eb/N0，最后噪声是加到符号上，因此要换为ES/N0
    SNRR_16qam = SNRR*4;
    Pn_16qam = 1./SNRR_16qam;
    Noise_awgn_16qam = 1/sqrt(2)*(Pn_16qam).^(1/2).*(randn(x+L-1,y)+1i.*randn(x+L-1,y));%%生成高斯噪声
    %%%%接收%%%%%%%%%%%%%%%%
    Data_Rx_16qam = Data_Tx_16qam_Fade + Noise_awgn_16qam;
   %%%%ZF均衡%%%%%%%%%%%%%%
    H_ZF=toeplitz([h zeros(1,x-1)],[h(1) zeros(1,x-1)]);
    W_ZF=(H_ZF'*H_ZF)\H_ZF';
    Data_Rx_16qam_correct = W_ZF*Data_Rx_16qam;
    %%%%解调%%%%%%%%%%%%%%%
    Data_bit_Rx_16qam_Fade = qam16_demod(Data_Rx_16qam(1:x,:));%%未经过均衡得到的解调数值
    Data_bit_Rx_16qam = qam16_demod(Data_Rx_16qam_correct);
    %%%%统计误码率%%%%%%%%%
    num_error_16qam_Fade = double(Data_bit~=Data_bit_Rx_16qam_Fade);
    BER_16qam_Fade_index(:,packet_index)=mean(num_error_16qam_Fade);
    num_error_16qam = double(Data_bit~=Data_bit_Rx_16qam);
    BER_16qam_index(:,packet_index)=mean(num_error_16qam);
 
end
BER_Fade = mean(BER_16qam_Fade_index,2);
BER_Fade_ZF = mean(BER_16qam_index,2);
% figure;
% semilogy(SNR,BER_16qam,'o-','linewidth',2);
% hold on 
% grid on
% axis([min(SNR) max(SNR) 1e-6 1]);
% xlabel('E_S/N_0');
% ylabel('BER');
% title('E_S/N_0~BER');
% legend('16QAM');%%,'16QAM-Theoratical');
end