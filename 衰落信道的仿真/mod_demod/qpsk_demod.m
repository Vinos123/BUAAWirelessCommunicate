function [Data_bit_Rx_qpsk]=qpsk_demod(Data_Rx_qpsk)

[x,y] = size(Data_Rx_qpsk);
Data_bit_Rx_qpsk = zeros(2*x,y);
Data_I_qpsk = real(Data_Rx_qpsk);%I路信号
Data_Q_qpsk = imag(Data_Rx_qpsk);%Q路信号

Data_bit_Rx_qpsk(1:2:end,:) = 1.*(Data_I_qpsk > 0)+0.*(Data_I_qpsk < 0);
Data_bit_Rx_qpsk(2:2:end,:) = 1.*(Data_Q_qpsk > 0)+0.*(Data_Q_qpsk < 0);
end