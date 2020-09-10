function [Data_qpsk]=qpsk_mod(Data_bit)
Data_qpsk = (2*Data_bit(1:2:end,:)-1)+1i*(2*Data_bit(2:2:end,:)-1);%QPSK,µ÷ÖÆ
%%11¡ª¡ª>1+i,01->-1+i,00->-1-i,10->1-i
end