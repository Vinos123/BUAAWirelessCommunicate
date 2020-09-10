clear 
close all
clc
addpath('../../mod_demod');
%%%%%初始参数设置%%%% %%%%%
N_packet = 1e5;
N_bits = 1e2;
N_symbol_qpsk=N_bits/2;
SNR = 0:5:40;
SNRR = 10.^(SNR./10);
SNR_len=length(SNR);
Data_bit = round(rand(N_bits,SNR_len));
BER_qpsk_index = zeros(SNR_len,N_packet);
L = 6;%多径条数
%%%%%QPSK调制%%%%%%%%%%%%%%%%%
Data_qpsk = qpsk_mod(Data_bit);
ES_qpsk = 2^(1/2);
[x,y]=size(Data_qpsk);
%%%%信号发送%%%%%%%%%%%%%%%%%%%%%%
Data_Tx_qpsk = zeros(x+L-1,y);%采用补零的块传输方案
Data_Tx_qpsk(1:x,1:y) = Data_qpsk/ES_qpsk;%%补了L-1个0，N=x,v=L-1;
Data_Rx_qpsk_correct = zeros(N_symbol_qpsk,SNR_len);
%%%%信道%%%%%%%%%%%%%%%%%
L_rms=sqrt(mean((L_vector.^2))-mean(L_vector)^2);
P_Fade = exp(-(0:(L-1))/(L_rms));%%功率延迟分布呈指数衰减
P_Fade = P_Fade./sqrt(P_Fade*P_Fade');
%%%%频率选择性衰落%%%%%%%%%%%%%%%
for packet_index = 1:N_packet
    h = (randn(1,L)+1i*randn(1,L))*1/sqrt(2).*sqrt(P_Fade);%产生多径信道
    H=toeplitz([h zeros(1,x-1)],[h(1) zeros(1,x+L-2)]);
    %%T = toeplitz(c,r) 返回非对称托普利茨矩阵，其中 c 作为第一列，r 作为第一行。如果 c 和 r 的首个元素不同，toeplitz 将发出警告并使用列元素作为对角线。
    Data_Tx_qpsk_Fade = H*Data_Tx_qpsk;
    
    %%噪声功率，SNRR为Eb/N0，最后噪声是加到符号上，因此要换为ES/N0
    SNRR_qpsk = SNRR*2;
    Pn_qpsk = 1./SNRR_qpsk;
    
    Noise_awgn_qpsk = 1/sqrt(2)*(Pn_qpsk).^(1/2).*(randn(x+L-1,y)+1i.*randn(x+L-1,y));%QPSK 两个bit组成一个符号，每个符号对应2
    %%%%接收%%%%%%%%%%%%%%%%
    Data_Rx_qpsk = Data_Tx_qpsk_Fade + Noise_awgn_qpsk;
    %%%%MMSE均衡%%%%%%%%%%%%%%
    H_MMSE=toeplitz([h zeros(1,x-1)],[h(1) zeros(1,x-1)]);
    for index_snr=1:SNR_len
        W_MMSE=(H_MMSE'*H_MMSE+Pn_qpsk(index_snr)*eye(x))\H_MMSE';
        Data_Rx_qpsk_correct(:,index_snr) = W_MMSE*Data_Rx_qpsk(:,index_snr);
    end

    Data_bit_Rx_qpsk = qpsk_demod(Data_Rx_qpsk_correct);

    num_error_qpsk = double(Data_bit~=Data_bit_Rx_qpsk);
    BER_qpsk_index(:,packet_index)=mean(num_error_qpsk);

end
BER_qpsk = mean(BER_qpsk_index,2);
%%%星座图
figure;
plot(real(Data_Rx_qpsk(:,4)*ES_qpsk),imag(Data_Rx_qpsk(:,4)*ES_qpsk),'b.','linewidth',2);
hold on
plot(real(Data_qpsk(:,4)),imag(Data_qpsk(:,4)),'ro','linewidth',2);
grid on 
xlabel('I');
ylabel('Q');
axis equal;
title('constellation diagram:QPSK 20dB');

figure;
plot(real(Data_Rx_qpsk_correct(:,2)*ES_qpsk),imag(Data_Rx_qpsk_correct(:,2)*ES_qpsk),'b.','linewidth',2);
hold on
plot(real(Data_qpsk(:,2)),imag(Data_qpsk(:,2)),'ro','linewidth',2);
grid on 
xlabel('I');
ylabel('Q');
axis equal;
title('constellation diagram:QPSK 20dB after balance');

figure;
semilogy(SNR,BER_qpsk,'o-','linewidth',2);
hold on
grid on
axis([min(SNR) max(SNR) 1e-7 1]);
xlabel('E_S/N_0');
ylabel('BER');
title('E_S/N_0~BER');
legend('QPSK');



