clear 
close all
clc

%%%%�������%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%����������Ŀ,ÿ���û�Ϊ������
N_trans = [16,64,256];%����������Ŀ
N_user = 15;
SNR=-10:2:30;%���������a
SNR_linear=10.^(SNR/10);%���������
SNR_Len=length(SNR);%��������ȵ�����
N_Len=length(N_trans);

Pn=1./SNR_linear;%�������ʣ������źŹ���Ϊ1��
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
            %%%k�û��������ߵõ����ŵ�����
            H = 1/sqrt(2)*(randn(N_trans(Ant_index),N_rece*N_user)+1i*randn(N_trans(Ant_index),N_rece*N_user));
            
            P_mf_temp=conj(H);%%ƥ���˲�δ��һ��
            Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%��һ��ϵ��
            P_mf=P_mf_temp*Beta_mf;%%ƥ���˲���һ��
            C_mf(index,Ant_index)=C_mf(index,Ant_index)+C_mu_cal(H,P_mf,SNR_linear(index));
            
            P_zf_temp=conj(H)/(H.'*conj(H));%%����δ��һ��
            Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%��һ��ϵ��
            P_zf=P_zf_temp*Beta_zf;%%�����һ��
            C_zf(index,Ant_index)=C_zf(index,Ant_index)+C_mu_cal(H,P_zf,SNR_linear(index));
            
            P_mmse_temp=conj(H)/(H.'*conj(H)+rou./SNR_linear(index)*eye(N_user));%%mmseδ��һ��
            Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%��һ��ϵ��
            P_mmse=P_mmse_temp*Beta_mmse;%%mmse��һ��
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
