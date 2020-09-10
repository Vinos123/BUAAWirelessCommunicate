function [C_mu,C_k_mu]=C_mu_cal(H,P,SNR)
[~,K]=size(H);%N���������ߣ�K���û�
C_mu=0;
C_k_mu=zeros(K,1);%��¼ÿ���û���Ӧ��������
for k_user=1:K
    Es=abs(H(:,k_user).'*P(:,k_user))^2;
    E_sum=sum(abs(H.'*P(:,k_user)).^2);
    SINR=Es/(E_sum-Es+1/SNR);
    C_mu=C_mu+log2(1+SINR);
    C_k_mu(k_user)=log2(1+SINR);
end

end