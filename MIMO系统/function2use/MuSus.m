function [C_mu_rand_mf,C_mu_rand_zf,C_mu_rand_mmse,S_list]=MuSus(N_trans,N_rece,SNR,N_user,N_user_sum,rou)
%%%论文中gk为行向量，这里用的是列向量
Alpha=0.4;
% H = 1/sqrt(2)*(randn(N_trans,N_rece*N_user_sum)+1i*randn(N_trans,N_rece*N_user_sum));%%hk为第k列
T=zeros(N_user_sum,N_user_sum);%%第i次候选调度的用户
T(:,1)=1:N_user_sum;%%
ii=1;
User2Access=zeros(N_user_sum,1);
S_list=zeros(N_user,1);%%最终调度的用户顺序,每次调度N_user个用户
% S_list_zero=zeros(N_user_sum,1);
% g_sum=zeros(N_user_sum,N_user_sum);
T_nonzero=(1:N_user_sum).';
% UserEpoch=N_user_sum/N_user;%%%一共进行调度的次数

C_mu_rand_mf=zeros(N_user_sum,1);
C_mu_rand_zf=zeros(N_user_sum,1);
C_mu_rand_mmse=zeros(N_user_sum,1);

G_user=zeros(N_trans,N_user);%%%存储筛选的信道

%     T=zeros(N_user_sum,N_user_sum);%%第i次候选调度的用户
%     T(:,1)=1:N_user_sum;%%
%%%生成信道矩阵和预处理矩阵%%%%

%%%匹配滤波预处理%%%%%%%%%%%%%
H = 1/sqrt(2)*(randn(N_trans,N_rece*N_user_sum)+1i*randn(N_trans,N_rece*N_user_sum));
%%%生成接入用户列表
%%%每次调度N_user个用户，题目要求为5
while(length(find(S_list))<N_user)%%%论文中为达到发射天线个数为止，按题目要求则为达到每次要调度的用户数目为止
    if(ii==1)
        G=H; 
    else
        T_len=length(T_nonzero);
%             H_left=H(:,T_nonzero);%%%%
        T(1:T_len,ii)=T_nonzero.*( T_nonzero~=User2Access(ii-1) & ...
            ( H(:,T_nonzero).'*conj(G_user(:,ii-1))./( sqrt(sum(abs(H(:,T_nonzero)).^2).') .* sqrt(sum(abs(G_user(:,ii-1)).^2))) ) < Alpha );
        T_nonzero=T(T(1:T_len,ii)~=0,ii);
        g_sum=zeros(N_trans,N_trans);
        if((isempty(T_nonzero)))
            break;
        end
        for jj=1:(ii-1) 
            g_sum=g_sum+conj(G_user(:,jj))*G_user(:,jj).'/(G_user(:,jj)'*G_user(:,jj));%%第j列为gj
        end
        G=(H(:,T_nonzero).'*(eye(N_trans)-g_sum)).';%第k列为gk，存储剩余用户的gk

    end

    [~,index]=max(sum(abs(G).^2));%%取gk模的最大值对应的序号  
    User2Access(ii)=T_nonzero(index);
    S_list(ii)=User2Access(ii);
%         H(:,ii)=H(:,User2Access(ii));
    G_user(:,ii)=G(:,index);%%%将筛选的G存入G_user中

    ii=ii+1;
end

H_user=H(:,S_list);
P_mf_temp=conj(H_user);%%匹配滤波未归一化
Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%归一化系数
P_mf=P_mf_temp*Beta_mf;%%匹配滤波归一化

P_zf_temp=conj(H_user)/(H_user.'*conj(H_user));%%迫零未归一化
Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%归一化系数
P_zf=P_zf_temp*Beta_zf;%%迫零归一化

P_mmse_temp=conj(H_user)/(H_user.'*conj(H_user)+rou./SNR*eye(N_user));%%mmse未归一化
Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%归一化系数
P_mmse=P_mmse_temp*Beta_mmse;%%mmse归一化

%%%%%计算信道容量%%%%%%%%%%%
C_mu_rand_mf(S_list)=C_mu_access_cal(H_user,P_mf,SNR);%%计算接入用户的信道容量
C_mu_rand_zf(S_list)=C_mu_access_cal(H_user,P_zf,SNR);
C_mu_rand_mmse(S_list)=C_mu_access_cal(H_user,P_mmse,SNR);
%     S_list_zero(S_list)=S_list;
%     T(:,1)=T(:,1).*( T(:,1) ~= S_list_zero );%排除掉上一次调度的用户，进行下一次的用户调度；

end