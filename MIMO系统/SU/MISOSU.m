clear 
close all
clc

%%%%仿真参数%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%接收天线数目
N_trans = [1,2,4];%发射天线数目
SNR=-10:1:30;%仿真信噪比
SNR_linear=10.^(SNR/10);%线性信噪比
SNR_Len=length(SNR);%仿真信噪比的数量
Pn=1./SNR_linear;%噪声功率（假设信号功率为1）
C_csit=zeros(SNR_Len,1);%
EPOCH=10000;
figure;
for Ant_index = 1:length(N_trans)
    for index=1:SNR_Len
        for epoch=1:EPOCH
            H = 1/sqrt(2)*(randn(N_rece,N_trans(Ant_index))+1i*randn(N_rece,N_trans(Ant_index)));
%             C_csit(index)=C_csit(index)+log(1+SNR_linear(index)/N_trans(Ant_index)*(sum(abs(H).^2)));
            lambda0=svd(H);
            C_csit(index)=C_csit(index)+ log2(1+SNR_linear(index)*lambda0^2);
        end
    end
    C_csit=C_csit/EPOCH;
    plot(SNR,C_csit,'linewidth',2);
    hold on 
end
grid on 
legend('1\times1','2\times1','4\times1');
title('SU-MISO:C~SNR');
xlabel('E_S/N_0');
ylabel('C');