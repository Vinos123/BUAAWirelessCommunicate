function [BER_qpsk,BER_qpsk_t]=Fade_SNR_qpsk_plot(SNR)
%%%%%初始参数设置%%%% %%%%%
N_packet = 1e6;
N_bits = 1e2;
N_symbol_qpsk=N_bits/2;
%SNR = 0:5:40;
SNRR = 10.^(SNR./10);
SNR_len=length(SNR);
Data_bit = round(rand(N_bits,SNR_len));
BER_qpsk_index = zeros(SNR_len,N_packet);
%%%%%QPSK调制%%%%%%%%%%%%%%%%%
Data_qpsk = qpsk_mod(Data_bit);
ES_qpsk = 2^(1/2);
%%%%信号发送%%%%%%%%%%%%%%%%%%%%%%
Data_Tx_qpsk = Data_qpsk/ES_qpsk;
%%%%信道%%%%%%%%%%%%%%%%%
%%%%平衰落%%%%%%%%%%%%%%%
for packet_index = 1:N_packet
    h = (randn+1i*randn)*1/sqrt(2);
    Data_Tx_qpsk_Fade = Data_Tx_qpsk*h;

    %%噪声功率，SNRR为Eb/N0，最后噪声是加到符号上，因此要换为ES/N0
    SNRR_qpsk = SNRR*2;
    Pn_qpsk = 1./SNRR_qpsk;
    Noise_awgn_qpsk = 1/sqrt(2)*(Pn_qpsk).^(1/2).*(randn(N_symbol_qpsk,SNR_len)+1i.*randn(N_symbol_qpsk,SNR_len));%QPSK 两个bit组成一个符号，每个符号对应2
    %%%%接收%%%%%%%%%%%%%%%%
    Data_Rx_qpsk = Data_Tx_qpsk_Fade + Noise_awgn_qpsk;
    Data_Rx_qpsk_correct = Data_Rx_qpsk*conj(h);

    Data_bit_Rx_qpsk = qpsk_demod(Data_Rx_qpsk_correct);

    num_error_qpsk = double(Data_bit~=Data_bit_Rx_qpsk);
    BER_qpsk_index(:,packet_index)=mean(num_error_qpsk);

end
BER_qpsk = mean(BER_qpsk_index,2);
BER_qpsk_t = 1/2*(1-sqrt(SNRR./(SNRR+1)));
end


