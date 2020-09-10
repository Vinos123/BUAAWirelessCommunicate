clear 
close all
clc

%%%%仿真参数%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%接收天线数目,每个用户为单天线
N_trans = [16,64,256];%发射天线数目
N_user = 15;
SNR=-10:2:30;%仿真信噪比a
SNR_linear=10.^(SNR/10);%线性信噪比
SNR_Len=length(SNR);%仿真信噪比的数量
N_Len=length(N_trans);

Pn=1./SNR_linear;%噪声功率（假设信号功率为1）
C_csit=zeros(SNR_Len,1);%
C_mf=zeros(SNR_Len,N_Len);
C_zf=zeros(SNR_Len,N_Len);
C_mmse=zeros(SNR_Len,N_Len);
EPOCH=1000;
rou=1;


for Ant_index = 1:length(N_trans)
    for index=1:SNR_Len
        for epoch=1:EPOCH
            k_freedom=min(N_trans(Ant_index),N_rece*N_user);
            %%%k用户，单天线得到的信道矩阵
            H = 1/sqrt(2)*(randn(N_trans(Ant_index),N_rece*N_user)+1i*randn(N_trans(Ant_index),N_rece*N_user));
            
            P_mf_temp=conj(H);%%匹配滤波未归一化
            Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%归一化系数
            P_mf=P_mf_temp*Beta_mf;%%匹配滤波归一化
            C_mf(index,Ant_index)=C_mf(index,Ant_index)+C_mu_cal(H,P_mf,SNR_linear(index));
            
            P_zf_temp=conj(H)/(H.'*conj(H));%%迫零未归一化
            Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%归一化系数
            P_zf=P_zf_temp*Beta_zf;%%迫零归一化
            C_zf(index,Ant_index)=C_zf(index,Ant_index)+C_mu_cal(H,P_zf,SNR_linear(index));
            
            P_mmse_temp=conj(H)/(H.'*conj(H)+rou./SNR_linear(index)*eye(N_user));%%mmse未归一化
            Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%归一化系数
            P_mmse=P_mmse_temp*Beta_mmse;%%mmse归一化
            C_mmse(index,Ant_index)=C_mmse(index,Ant_index)+C_mu_cal(H,P_mmse,SNR_linear(index));

        end
    end

end
C_mf=C_mf/EPOCH;
C_zf=C_zf/EPOCH;
C_mmse=C_mmse/EPOCH;

figure;
for ii=1:N_Len
    plot(SNR,C_mf(:,ii),'linewidth',2);
    hold on 
end
grid on 
legend('n_t=16','n_t=64','n_t=256');

figure;
for ii=1:N_Len
    plot(SNR,C_zf(:,ii),'linewidth',2);
    hold on
end
grid on
legend('n_t=16','n_t=64','n_t=256');

figure;
for ii=1:N_Len
    plot(SNR,C_mmse(:,ii),'linewidth',2);
    hold on
end
grid on
legend('n_t=16','n_t=64','n_t=256');
