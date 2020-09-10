function [C_mu_rand_mf,C_mu_rand_zf,C_mu_rand_mmse,S_list]=MuSus(N_trans,N_rece,SNR,N_user,N_user_sum,rou)
%%%������gkΪ�������������õ���������
Alpha=0.4;
% H = 1/sqrt(2)*(randn(N_trans,N_rece*N_user_sum)+1i*randn(N_trans,N_rece*N_user_sum));%%hkΪ��k��
T=zeros(N_user_sum,N_user_sum);%%��i�κ�ѡ���ȵ��û�
T(:,1)=1:N_user_sum;%%
ii=1;
User2Access=zeros(N_user_sum,1);
S_list=zeros(N_user,1);%%���յ��ȵ��û�˳��,ÿ�ε���N_user���û�
% S_list_zero=zeros(N_user_sum,1);
% g_sum=zeros(N_user_sum,N_user_sum);
T_nonzero=(1:N_user_sum).';
% UserEpoch=N_user_sum/N_user;%%%һ�����е��ȵĴ���

C_mu_rand_mf=zeros(N_user_sum,1);
C_mu_rand_zf=zeros(N_user_sum,1);
C_mu_rand_mmse=zeros(N_user_sum,1);

G_user=zeros(N_trans,N_user);%%%�洢ɸѡ���ŵ�

%     T=zeros(N_user_sum,N_user_sum);%%��i�κ�ѡ���ȵ��û�
%     T(:,1)=1:N_user_sum;%%
%%%�����ŵ������Ԥ�������%%%%

%%%ƥ���˲�Ԥ����%%%%%%%%%%%%%
H = 1/sqrt(2)*(randn(N_trans,N_rece*N_user_sum)+1i*randn(N_trans,N_rece*N_user_sum));
%%%���ɽ����û��б�
%%%ÿ�ε���N_user���û�����ĿҪ��Ϊ5
while(length(find(S_list))<N_user)%%%������Ϊ�ﵽ�������߸���Ϊֹ������ĿҪ����Ϊ�ﵽÿ��Ҫ���ȵ��û���ĿΪֹ
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
            g_sum=g_sum+conj(G_user(:,jj))*G_user(:,jj).'/(G_user(:,jj)'*G_user(:,jj));%%��j��Ϊgj
        end
        G=(H(:,T_nonzero).'*(eye(N_trans)-g_sum)).';%��k��Ϊgk���洢ʣ���û���gk

    end

    [~,index]=max(sum(abs(G).^2));%%ȡgkģ�����ֵ��Ӧ�����  
    User2Access(ii)=T_nonzero(index);
    S_list(ii)=User2Access(ii);
%         H(:,ii)=H(:,User2Access(ii));
    G_user(:,ii)=G(:,index);%%%��ɸѡ��G����G_user��

    ii=ii+1;
end

H_user=H(:,S_list);
P_mf_temp=conj(H_user);%%ƥ���˲�δ��һ��
Beta_mf=diag(sqrt(1./sum(abs(P_mf_temp).^2)));%%��һ��ϵ��
P_mf=P_mf_temp*Beta_mf;%%ƥ���˲���һ��

P_zf_temp=conj(H_user)/(H_user.'*conj(H_user));%%����δ��һ��
Beta_zf=diag(sqrt(1./sum(abs(P_zf_temp).^2)));%%��һ��ϵ��
P_zf=P_zf_temp*Beta_zf;%%�����һ��

P_mmse_temp=conj(H_user)/(H_user.'*conj(H_user)+rou./SNR*eye(N_user));%%mmseδ��һ��
Beta_mmse=diag(sqrt(1./sum(abs(P_mmse_temp).^2)));%%��һ��ϵ��
P_mmse=P_mmse_temp*Beta_mmse;%%mmse��һ��

%%%%%�����ŵ�����%%%%%%%%%%%
C_mu_rand_mf(S_list)=C_mu_access_cal(H_user,P_mf,SNR);%%��������û����ŵ�����
C_mu_rand_zf(S_list)=C_mu_access_cal(H_user,P_zf,SNR);
C_mu_rand_mmse(S_list)=C_mu_access_cal(H_user,P_mmse,SNR);
%     S_list_zero(S_list)=S_list;
%     T(:,1)=T(:,1).*( T(:,1) ~= S_list_zero );%�ų�����һ�ε��ȵ��û���������һ�ε��û����ȣ�

end