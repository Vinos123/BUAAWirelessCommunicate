function [C_mu_rand_mf,C_mu_rand_zf,C_mu_rand_mmse]=MuRandom(N_trans,N_rece,SNR,N_user,N_user_sum,rou)
% UserEpoch=floor(N_user_sum/N_user);%%用户调度的次数
% UserList=zeros(N_user_sum,1);
C_mu_rand_mf=zeros(N_user_sum,1);
C_mu_rand_zf=zeros(N_user_sum,1);
C_mu_rand_mmse=zeros(N_user_sum,1);
%%%生成信道矩阵和预处理矩阵%%%%
%%%匹配滤波预处理%%%%%%%%%%%%%
H = 1/sqrt(2)*(randn(N_trans,N_rece*N_user)+1i*randn(N_trans,N_rece*N_user));
P_mf_temp=conj(H);%%匹配滤波未归一化
Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%归一化系数
P_mf=P_mf_temp*Beta_mf;%%匹配滤波归一化

P_zf_temp=conj(H)/(H.'*conj(H));%%迫零未归一化
Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%归一化系数
P_zf=P_zf_temp*Beta_zf;%%迫零归一化

P_mmse_temp=conj(H)/(H.'*conj(H)+rou./SNR*eye(N_user));%%mmse未归一化
Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%归一化系数
P_mmse=P_mmse_temp*Beta_mmse;%%mmse归一化

%%%生成接入用户列表
User2access=rand(N_user_sum,1);
[~,UserAccessList]=sort(User2access);
%%%计算接入用户的信道容量
C_mu_rand_mf(UserAccessList(1:N_user))=C_mu_access_cal(H,P_mf,SNR);%%计算接入用户的信道容量
C_mu_rand_zf(UserAccessList(1:N_user))=C_mu_access_cal(H,P_zf,SNR);
C_mu_rand_mmse(UserAccessList(1:N_user))=C_mu_access_cal(H,P_mmse,SNR);

    
end