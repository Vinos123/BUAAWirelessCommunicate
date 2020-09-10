function [C_mu_rand_mf,C_mu_rand_zf,C_mu_rand_mmse]=MuRandom(N_trans,N_rece,SNR,N_user,N_user_sum,rou)
% UserEpoch=floor(N_user_sum/N_user);%%�û����ȵĴ���
% UserList=zeros(N_user_sum,1);
C_mu_rand_mf=zeros(N_user_sum,1);
C_mu_rand_zf=zeros(N_user_sum,1);
C_mu_rand_mmse=zeros(N_user_sum,1);
%%%�����ŵ������Ԥ�������%%%%
%%%ƥ���˲�Ԥ����%%%%%%%%%%%%%
H = 1/sqrt(2)*(randn(N_trans,N_rece*N_user)+1i*randn(N_trans,N_rece*N_user));
P_mf_temp=conj(H);%%ƥ���˲�δ��һ��
Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%��һ��ϵ��
P_mf=P_mf_temp*Beta_mf;%%ƥ���˲���һ��

P_zf_temp=conj(H)/(H.'*conj(H));%%����δ��һ��
Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%��һ��ϵ��
P_zf=P_zf_temp*Beta_zf;%%�����һ��

P_mmse_temp=conj(H)/(H.'*conj(H)+rou./SNR*eye(N_user));%%mmseδ��һ��
Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%��һ��ϵ��
P_mmse=P_mmse_temp*Beta_mmse;%%mmse��һ��

%%%���ɽ����û��б�
User2access=rand(N_user_sum,1);
[~,UserAccessList]=sort(User2access);
%%%��������û����ŵ�����
C_mu_rand_mf(UserAccessList(1:N_user))=C_mu_access_cal(H,P_mf,SNR);%%��������û����ŵ�����
C_mu_rand_zf(UserAccessList(1:N_user))=C_mu_access_cal(H,P_zf,SNR);
C_mu_rand_mmse(UserAccessList(1:N_user))=C_mu_access_cal(H,P_mmse,SNR);

    
end