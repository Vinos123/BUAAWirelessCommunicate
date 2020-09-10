clear
close all
clc

addpath('./MIMOMU_plot');
addpath('../function2use');

EPOCH=10000;
SNR=-10:2:30;
N_user=[3];
N_trans=[16,64,256];
N_Len=length(N_trans);


% %%%%不同用户数%%%%%%%%%%%%
% C_miso_mf_user=zeros(length(SNR),N_Len);
% C_miso_zf_user=zeros(length(SNR),N_Len);
% C_miso_mmse_user=zeros(length(SNR),N_Len);
% 
% for user_index=1:length(N_user)
% 
%     [C_miso_mf_user(:,user_index),C_miso_zf_user(:,user_index),C_miso_mmse_user(:,user_index),C_mu_mf,C_mu_zf,C_mu_mmse]=MISOMU_plot(EPOCH,SNR,N_user(user_index),N_trans);
%     
% end
% 
% figure;
% for ii=1:length(N_user)
%     plot(SNR,C_miso_mf_user(:,ii),'linewidth',2);
%     hold on 
% end
% grid on
% legend(['N_user=',num2str(N_user(1))],['N_user=',num2str(N_user(2))],['N_user=',num2str(N_user(3))],['N_user=',num2str(N_user(4))]);
% xlabel('E_S/N_0');
% ylabel('R');
% title('MF:R~E_S/N_0');
% 
% figure;
% for ii=1:length(N_user)
%     plot(SNR,C_miso_zf_user(:,ii),'linewidth',2);
%     hold on 
% end
% grid on
% legend(['N_user=',num2str(N_user(1))],['N_user=',num2str(N_user(2))],['N_user=',num2str(N_user(3))],['N_user=',num2str(N_user(4))]);
% xlabel('E_S/N_0');
% ylabel('R');
% title('ZF:R~E_S/N_0');
% 
% figure;
% for ii=1:length(N_user)
%     plot(SNR,C_miso_mmse_user(:,ii),'linewidth',2);
%     hold on 
% end
% grid on
% legend(['N_user=',num2str(N_user(1))],['N_user=',num2str(N_user(2))],['N_user=',num2str(N_user(3))],['N_user=',num2str(N_user(4))]);
% xlabel('E_S/N_0');
% ylabel('R');
% title('MMSE:R~E_S/N_0');


%不同预处理方式，相同天线数
[C_miso_mf,C_miso_zf,C_miso_mmse,C_mu_mf,C_mu_zf,C_mu_mmse]=MISOMU_plot(EPOCH,SNR,N_user,N_trans);
for ii=1:N_Len
    figure;
    plot(SNR,C_miso_mf(:,ii),'linewidth',2);
    hold on 
    plot(SNR,C_miso_zf(:,ii),'linewidth',2);
    hold on
    plot(SNR,C_miso_mmse(:,ii),'linewidth',2);
    grid on
    legend('mf','zf','mmse')
    xlabel('E_S/N_0');
    ylabel('R');
    title(['R~E_S/N_0:n_t=',num2str(N_trans(ii))]);
end




