clear 
close all
clc

%%%%仿真参数%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%接收天线数目,每个用户为单天线
N_trans = 8;%发射天线数目
N_user_sum=20;
N_user_list=zeros(N_user_sum,1);
N_user = 5;
UserEpoch=N_user_sum/N_user;

SNR=-10:2:30;%仿真信噪比
SNR_linear=10.^(SNR/10);%线性信噪比
SNR_Len=length(SNR);%仿真信噪比的数量
N_Len=length(N_trans);
EPOCH=10000;
Pn=1./SNR_linear;%噪声功率（假设信号功率为1）
C_csit=zeros(SNR_Len,1);%
% C_mf=zeros(SNR_Len,N_Len,EPOCH);
% C_zf=zeros(SNR_Len,N_Len,EPOCH);
% C_mmse=zeros(SNR_Len,N_Len,EPOCH);

rou=1;
C_k_mu_mf=zeros(N_user_sum,SNR_Len,EPOCH,N_Len);
C_k_mu_zf=zeros(N_user_sum,SNR_Len,EPOCH,N_Len);
C_k_mu_mmse=zeros(N_user_sum,SNR_Len,EPOCH,N_Len);

for Ant_index = 1:length(N_trans)
    for index=1:SNR_Len
        for epoch=1:EPOCH
            %%%k用户，单天线得到的信道矩阵
            [C_k_mu_mf(:,index,epoch,Ant_index),C_k_mu_zf(:,index,epoch,Ant_index),C_k_mu_mmse(:,index,epoch,Ant_index)]...
            =MuRandom(N_trans(Ant_index),N_rece,SNR_linear(index),N_user,N_user_sum,rou);
        end
    end

end
C_k_mu_mf_mean=mean(C_k_mu_mf,3);
C_k_mu_zf_mean=mean(C_k_mu_zf,3);
C_k_mu_mmse_mean=mean(C_k_mu_mmse,3);

C_mf=sum(C_k_mu_mf_mean,1);
C_zf=sum(C_k_mu_zf_mean,1);
C_mmse=sum(C_k_mu_mmse_mean,1);
figure;
plot(SNR,C_mf,'linewidth',2);
hold on 
plot(SNR,C_zf,'linewidth',2);
hold on 
plot(SNR,C_mmse,'linewidth',2);
grid on 
xlabel('E_S/N_0');
ylabel('R');
title('Random:R_{sum}~E_S/N_0')
legend('MF','ZF','MMSE');

% for ii=1:N_Len
%     plot(SNR,C_mf(:,ii),'linewidth',2);
%     hold on 
% end
% grid on 
% legend('n_t=4','n_t=8','n_t=16');
% 
% figure;
% for ii=1:N_Len
%     plot(SNR,C_zf(:,ii),'linewidth',2);
%     hold on
% end
% grid on
% legend('n_t=4','n_t=8','n_t=16');
% 
% figure;
% for ii=1:N_Len
%     plot(SNR,C_mmse(:,ii),'linewidth',2);
%     hold on
% end
% grid on
% legend('n_t=4','n_t=8','n_t=16');
% 
% figure;
% cdfplot(C_k_mu_mf(1,:,6,1));
% figure;
% cdfplot(C_k_mu_zf(1,:,6,1));
% figure;
% cdfplot(C_k_mu_mmse(1,:,6,1));
