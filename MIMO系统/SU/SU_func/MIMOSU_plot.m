function [C_csit,C_csir]=MIMOSU_plot(EPOCH,SNR)
%%%%仿真参数%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = [1,2,4];%接收天线数目
N_trans = [1,2,4];%发射天线数目
N_Len=length(N_trans);
% SNR=-10:2:30;%仿真信噪比
SNR_linear=10.^(SNR/10);%线性信噪比
SNR_Len=length(SNR);%仿真信噪比的数量
Pn=1./SNR_linear;%噪声功率（假设信号功率为1）
C_csir=zeros(SNR_Len,N_Len);%
C_csit=zeros(SNR_Len,N_Len);
% EPOCH=10000;
for Ant_index = 1:length(N_trans)
    for index=1:SNR_Len
        for epoch=1:EPOCH
            H = 1/sqrt(2)*(randn(N_rece(Ant_index),N_trans(Ant_index))+1i*randn(N_rece(Ant_index),N_trans(Ant_index)));
%             C_csit(index)=C_csit(index)+log(1+SNR_linear(index)/N_trans(Ant_index)*(sum(abs(H).^2)));
            C_csit(index,Ant_index)=C_csit(index,Ant_index)+C_csit_cal(H,SNR_linear(index));
            C_csir(index,Ant_index)=C_csir(index,Ant_index)+log2((det(eye(N_trans(Ant_index))+SNR_linear(index)/N_trans(Ant_index)*(H*H'))));
        end
    end
end
C_csit=C_csit/EPOCH;
C_csir=C_csir/EPOCH;
% figure;
% for ii=1:N_Len
%    
%     plot(SNR,C_csit(:,ii),'linewidth',2);
%     hold on
% end
% grid on 
% legend
% figure;
% for ii=1:N_Len
% 
%     plot(SNR,abs(C_csir(:,ii)),'linewidth',2);
%     hold on 
% end
% grid on 
% legend
end
