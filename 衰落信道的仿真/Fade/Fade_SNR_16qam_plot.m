function [BER_16qam,BER_16qam_t]=Fade_SNR_16qam_plot(SNR)
%%%%%初始参数设置%%%% %%%%%
N_packet = 1e6;
N_bits = 1e2;
N_symbol_16qam = N_bits/4;
%SNR = 0:5:40;   
SNRR = 10.^(SNR./10);   
SNR_len=length(SNR);    
Data_bit = round(rand(N_bits,SNR_len));
BER_16qam_index = zeros(SNR_len,N_packet);
%%%%16QAM调制%%%%%%%%%%%%%%%%%%%%%%
Data_16qam=qam16_mod(Data_bit); 
ES_16qam = sqrt(10);%16QAM的功率归一化因子，2*1/4*2*（1^2+3^2)
%%%%信号发送%%%%%%%%%%%%%%%%%%%%%%
Data_Tx_16qam = Data_16qam/ES_16qam;%能量归一化，将每个符号的能量归为1
%%%%平衰落%%%%%%%%%%%%%%%
for packet_index = 1:N_packet
    h = (randn+1i*randn)*1/sqrt(2);
    Data_Tx_16qam_Fade = Data_Tx_16qam*h;

    %%噪声功率，SNRR为Eb/N0，最后噪声是加到符号上，因此要换为ES/N0
    SNRR_16qam = SNRR*4;
    Pn_16qam = 1./SNRR_16qam;
    Noise_awgn_16qam = 1/sqrt(2)*(Pn_16qam).^(1/2).*(randn(N_symbol_16qam,SNR_len)+1i.*randn(N_symbol_16qam,SNR_len));%%生成高斯噪声
    %%%%接收%%%%%%%%%%%%%%%%
    Data_Rx_16qam = Data_Tx_16qam_Fade + Noise_awgn_16qam;
    Data_Rx_16qam_correct = Data_Rx_16qam./h;

    Data_bit_Rx_16qam = qam16_demod(Data_Rx_16qam_correct);

    num_error_16qam = double(Data_bit~=Data_bit_Rx_16qam);
    BER_16qam_index(:,packet_index)=mean(num_error_16qam);
 
end
BER_16qam = mean(BER_16qam_index,2);
BER_16qam_t = 3/8*(1-sqrt(2/5*SNRR./(1+2/5*SNRR)));%%Q(a)=1/2*erfc(a/2^(1/2))  
end

