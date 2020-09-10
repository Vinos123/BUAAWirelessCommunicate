clear 
close all
clc

addpath('../function2use');
%%%%仿真参数%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%接收天线数目,每个用户为单天线
N_trans = [16];%发射天线数目
N_user = 15;
SNR=-10:2:30;%仿真信噪比
SNR_linear=10.^(SNR/10);%线性信噪比
SNR_Len=length(SNR);%仿真信噪比的数量
N_Len=length(N_trans);
EPOCH=10000;
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
%             k_freedom=min(N_trans(Ant_index),N_rece*N_user);
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

figure;
for ii=1:N_Len
    plot(SNR,C_mf(:,ii),'linewidth',2);
    hold on 
end
grid on 
legend('n_t=4','n_t=8','n_t=16');
xlabel('E_S/N_0');
ylabel('R');
title('MF:R~E_S/N_0');

figure;
for ii=1:N_Len
    plot(SNR,C_zf(:,ii),'linewidth',2);
    hold on
end
grid on
legend('n_t=4','n_t=8','n_t=16');
xlabel('E_S/N_0');
ylabel('R');
title('ZF:R~E_S/N_0');


figure;
for ii=1:N_Len
    plot(SNR,C_mmse(:,ii),'linewidth',2);
    hold on
end
grid on
legend('n_t=4','n_t=8','n_t=16');
xlabel('E_S/N_0');
ylabel('R');
title('MMSE:R~E_S/N_0');


SNR_index=[4,16];
plot_index=1;
figure;
for index_N=1:N_Len
    for index_snr=1:length(SNR_index)
        subplot(N_Len,length(SNR_index),plot_index);
        for ii=1:N_user
            ecdf(C_k_mu_mf(ii,:,SNR_index(index_snr),index_N));
            hold on
        end
        grid on
        title(['User CDF:SNR=',num2str(SNR(SNR_index(index_snr))),',n_t=',num2str(N_trans(index_N))]);
        plot_index=plot_index+1;
    end
end

plot_index=1;
figure;
for index_N=1:N_Len
    for index_snr=1:length(SNR_index)
        subplot(N_Len,length(SNR_index),plot_index);
        for ii=1:N_user
            ecdf(C_k_mu_zf(ii,:,SNR_index(index_snr),index_N));
            hold on
        end
        grid on
        title(['User CDF:SNR=',num2str(SNR(SNR_index(index_snr))),',n_t=',num2str(N_trans(index_N))]);
        plot_index=plot_index+1;
    end
end
plot_index=1;
figure;
for index_N=1:N_Len
    for index_snr=1:length(SNR_index)
        subplot(N_Len,length(SNR_index),plot_index);
        for ii=1:N_user
            ecdf(C_k_mu_mmse(ii,:,SNR_index(index_snr),index_N));
            hold on
        end
        grid on
        title(['User CDF:SNR=',num2str(SNR(SNR_index(index_snr))),',n_t=',num2str(N_trans(index_N))]);
        plot_index=plot_index+1;
    end
end

