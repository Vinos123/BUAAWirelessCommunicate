function C_mu_rand=C_mu_access_cal(H,P,SNR)
[~,K]=size(H);%N个发射天线，K个用户
C_mu_rand=zeros(K,1);%记录每个用户对应的数据率
for k_user=1:K
    Es=abs(H(:,k_user).'*P(:,k_user))^2;
    E_sum=sum(abs(H.'*P(:,k_user)).^2);
    SINR=Es/(E_sum-Es+1/SNR);
    C_mu_rand(k_user)=log2(1+SINR);
end

end
