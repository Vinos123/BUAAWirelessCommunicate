function [Data_16qam]=qam16_mod(Data_bit)
Data_I_1 = Data_bit(1:4:end,:);
Data_I_2 = Data_bit(2:4:end,:);
Data_Q_1 = Data_bit(3:4:end,:);
Data_Q_2 = Data_bit(4:4:end,:);%分为IQ两路
Data_16qam = (2*Data_I_1-1).*(2*Data_I_2+1)+...
    1i*((2*Data_Q_1-1).*(2*Data_Q_2+1));
%%0000->-1-1i,0001->
end