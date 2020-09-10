function [C_mf,C_zf,C_mmse,C_k_mf,C_k_zf,C_k_mmse]=MIMORandom_plot(EPOCH,SNR)
%%%%仿真参数%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%接收天线数目,每个用户为单天线
N_trans = 8;%发射天线数目
N_user_sum=20;
N_user = 5;


% SNR=-10:2:30;%仿真信噪比
SNR_linear=10.^(SNR/10);%线性信噪比
SNR_Len=length(SNR);%仿真信噪比的数量
N_Len=length(N_trans);
% EPOCH=10000;

rou=1;
C_k_mf=zeros(N_user_sum,EPOCH,SNR_Len,N_Len);
C_k_zf=zeros(N_user_sum,EPOCH,SNR_Len,N_Len);
C_k_mmse=zeros(N_user_sum,EPOCH,SNR_Len,N_Len);

for Ant_index = 1:length(N_trans)
    for index=1:SNR_Len
        for epoch=1:EPOCH
            %%%k用户，单天线得到的信道矩阵
            [C_k_mf(:,epoch,index,Ant_index),C_k_zf(:,epoch,index,Ant_index),C_k_mmse(:,epoch,index,Ant_index)]...
            =MuRandom(N_trans(Ant_index),N_rece,SNR_linear(index),N_user,N_user_sum,rou);
        end
    end

end
C_mf=sum(mean(C_k_mf,2),1);
C_zf=sum(mean(C_k_zf,2),1);
C_mmse=sum(mean(C_k_mmse,2),1);

end