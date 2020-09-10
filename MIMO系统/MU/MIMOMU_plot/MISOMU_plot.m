function [C_mf,C_zf,C_mmse,C_k_mu_mf,C_k_mu_zf,C_k_mu_mmse]=MISOMU_plot(EPOCH,SNR,N_user,N_trans)
%%%%仿真参数%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%接收天线数目,每个用户为单天线
% N_trans = [4,8,16];%发射天线数目
% N_user = 3;
% SNR=-10:2:30;%仿真信噪比
SNR_linear=10.^(SNR/10);%线性信噪比
SNR_Len=length(SNR);%仿真信噪比的数量
N_Len=length(N_trans);
% EPOCH=10000;
Pn=1./SNR_linear;%噪声功率（假设信号功率为1）
C_csit=zeros(SNR_Len,1);%
C_mf=zeros(SNR_Len,N_Len,EPOCH);
C_zf=zeros(SNR_Len,N_Len,EPOCH);
C_mmse=zeros(SNR_Len,N_Len,EPOCH);

rou=1;
C_k_mu_mf=zeros(N_user,EPOCH,SNR_Len,N_Len);
C_k_mu_zf=zeros(N_user,EPOCH,SNR_Len,N_Len);
C_k_mu_mmse=zeros(N_user,EPOCH,SNR_Len,N_Len);

for Ant_index = 1:length(N_trans)
    for index=1:SNR_Len
        for epoch=1:EPOCH
            %%%k用户，单天线得到的信道矩阵
            H = 1/sqrt(2)*(randn(N_trans(Ant_index),N_rece*N_user)+1i*randn(N_trans(Ant_index),N_rece*N_user));
            P_mf_temp=conj(H);%%匹配滤波未归一化
            Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%归一化系数
            P_mf=P_mf_temp*Beta_mf;%%匹配滤波归一化
            [C_mf(index,Ant_index,epoch),C_k_mu_mf(:,epoch,index,Ant_index)]=C_mu_cal(H,P_mf,SNR_linear(index));
            
            P_zf_temp=conj(H)/(H.'*conj(H));%%迫零未归一化
            Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%归一化系数
            P_zf=P_zf_temp*Beta_zf;%%迫零归一化
            [C_zf(index,Ant_index,epoch),C_k_mu_zf(:,epoch,index,Ant_index)]=C_mu_cal(H,P_zf,SNR_linear(index));
            
            P_mmse_temp=conj(H)/(H.'*conj(H)+rou./SNR_linear(index)*eye(N_user));%%mmse未归一化
            Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%归一化系数
            P_mmse=P_mmse_temp*Beta_mmse;%%mmse归一化
            [C_mmse(index,Ant_index,epoch),C_k_mu_mmse(:,epoch,index,Ant_index)]=C_mu_cal(H,P_mmse,SNR_linear(index));

        end
    end

end
C_mf=mean(C_mf,3);
C_zf=mean(C_zf,3);
C_mmse=mean(C_mmse,3);

C_k_mu_mf=mean(C_k_mu_mf,2);
C_k_mu_zf=mean(C_k_mu_zf,2);
C_k_mu_mmse=mean(C_k_mu_mmse,2);

end