function [C_mf,C_zf,C_mmse,C_k_mu_mf,C_k_mu_zf,C_k_mu_mmse]=MISOMU_plot(EPOCH,SNR,N_user,N_trans)
%%%%�������%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%����������Ŀ,ÿ���û�Ϊ������
% N_trans = [4,8,16];%����������Ŀ
% N_user = 3;
% SNR=-10:2:30;%���������
SNR_linear=10.^(SNR/10);%���������
SNR_Len=length(SNR);%��������ȵ�����
N_Len=length(N_trans);
% EPOCH=10000;
Pn=1./SNR_linear;%�������ʣ������źŹ���Ϊ1��
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
            %%%k�û��������ߵõ����ŵ�����
            H = 1/sqrt(2)*(randn(N_trans(Ant_index),N_rece*N_user)+1i*randn(N_trans(Ant_index),N_rece*N_user));
            P_mf_temp=conj(H);%%ƥ���˲�δ��һ��
            Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%��һ��ϵ��
            P_mf=P_mf_temp*Beta_mf;%%ƥ���˲���һ��
            [C_mf(index,Ant_index,epoch),C_k_mu_mf(:,epoch,index,Ant_index)]=C_mu_cal(H,P_mf,SNR_linear(index));
            
            P_zf_temp=conj(H)/(H.'*conj(H));%%����δ��һ��
            Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%��һ��ϵ��
            P_zf=P_zf_temp*Beta_zf;%%�����һ��
            [C_zf(index,Ant_index,epoch),C_k_mu_zf(:,epoch,index,Ant_index)]=C_mu_cal(H,P_zf,SNR_linear(index));
            
            P_mmse_temp=conj(H)/(H.'*conj(H)+rou./SNR_linear(index)*eye(N_user));%%mmseδ��һ��
            Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%��һ��ϵ��
            P_mmse=P_mmse_temp*Beta_mmse;%%mmse��һ��
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