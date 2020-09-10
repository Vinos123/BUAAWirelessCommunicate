function [Data_bit_Rx_16qam]=qam16_demod(Data_Rx_16qam)
[x,y]=size(Data_Rx_16qam);
ES_16qam = 10^(1/2);
judge_16qam = (1+3)/2/ES_16qam;
Data_bit_Rx_16qam = zeros(4*x,y);
Data_I_16qam = real(Data_Rx_16qam);
Data_Q_16qam = imag(Data_Rx_16qam);
Data_bit_Rx_16qam(1:4:end,:) = 0.*(Data_I_16qam < 0) + 1.*(Data_I_16qam >= 0); 
Data_bit_Rx_16qam(2:4:end,:) = 0.*(abs(Data_I_16qam) <= judge_16qam) + 1.*(abs(Data_I_16qam) > judge_16qam);
Data_bit_Rx_16qam(3:4:end,:) = 0.*(Data_Q_16qam < 0) + 1.*(Data_Q_16qam >= 0); 
Data_bit_Rx_16qam(4:4:end,:) = 0.*(abs(Data_Q_16qam) <= judge_16qam ) + 1.*(abs(Data_Q_16qam) > judge_16qam);
end