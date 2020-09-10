clear 
close all
clc

addpath('./MIMOMU_plot');
addpath('../function2use');

SNR=-10:2:30;
EPOCH=10000;
SNR_Len=length(SNR);
[C_mf_rand,C_zf_rand,C_mmse_rand,C_k_mf_rand,C_k_zf_rand,C_k_mmse_rand]=MIMORandom_plot(EPOCH,SNR);


[C_mf_sus,C_zf_sus,C_mmse_sus,C_k_mf_sus,C_k_zf_sus,C_k_mmse_sus]=MIMOSus_plot(EPOCH,SNR);
C_mf_rand=reshape(C_mf_rand,SNR_Len,1);
C_zf_rand=reshape(C_zf_rand,SNR_Len,1);
C_mmse_rand=reshape(C_mmse_rand,SNR_Len,1);
C_mf_sus=reshape(C_mf_sus,SNR_Len,1);
C_zf_sus=reshape(C_zf_sus,SNR_Len,1);
C_mmse_sus=reshape(C_mmse_sus,SNR_Len,1);
figure;
plot(SNR,C_mf_rand,'linewidth',2);
hold on
plot(SNR,C_mf_sus,'linewidth',2);
grid on
xlabel('E_S/N_0');
ylabel('R');
title('MF:Random vs Sus');
legend('Random','SUS');

figure;
plot(SNR,C_zf_rand,'linewidth',2);
hold on
plot(SNR,C_zf_sus,'linewidth',2);
grid on
xlabel('E_S/N_0');
ylabel('R');
title('ZF:Random vs Sus');
legend('Random','SUS');

figure;
plot(SNR,C_mmse_rand,'linewidth',2);
hold on
plot(SNR,C_mmse_sus,'linewidth',2);
grid on
xlabel('E_S/N_0');
ylabel('R');
title('MMSE:Random vs Sus');
legend('Random','SUS');

N_user=20;
SNR_index=[4,16];
plot_index=1;
figure;

for index_snr=1:length(SNR_index)
    subplot(length(SNR_index),2,plot_index);
    for ii=1:N_user
        ecdf(C_k_mf_rand(ii,:,SNR_index(index_snr)));
        hold on
    end
    grid on
    title(['Random User CDF:SNR=',num2str(SNR(SNR_index(index_snr)))]);
    plot_index=plot_index+1;
    subplot(length(SNR_index),2,plot_index);
    for ii=1:N_user
        ecdf(C_k_mf_sus(ii,:,SNR_index(index_snr)));
        hold on
    end
    grid on
    title(['SUS User CDF:SNR=',num2str(SNR(SNR_index(index_snr)))]);
    plot_index=plot_index+1;
end
plot_index=1;
figure;

for index_snr=1:length(SNR_index)
    subplot(length(SNR_index),2,plot_index);
    for ii=1:N_user
        ecdf(C_k_zf_rand(ii,:,SNR_index(index_snr)));
        hold on
    end
    grid on
    title(['Random User CDF:SNR=',num2str(SNR(SNR_index(index_snr)))]);
    plot_index=plot_index+1;
    subplot(length(SNR_index),2,plot_index);
    for ii=1:N_user
        ecdf(C_k_zf_sus(ii,:,SNR_index(index_snr)));
        hold on
    end
    grid on
    title(['SUS User CDF:SNR=',num2str(SNR(SNR_index(index_snr)))]);
    plot_index=plot_index+1;
end

plot_index=1;
figure;

for index_snr=1:length(SNR_index)
    subplot(length(SNR_index),2,plot_index);
    for ii=1:N_user
        ecdf(C_k_mmse_rand(ii,:,SNR_index(index_snr)));
        hold on
    end
    grid on
    title(['Random User CDF:SNR=',num2str(SNR(SNR_index(index_snr)))]);
    plot_index=plot_index+1;
    subplot(length(SNR_index),2,plot_index);
    for ii=1:N_user
        ecdf(C_k_mmse_sus(ii,:,SNR_index(index_snr)));
        hold on
    end
    grid on
    title(['SUS User CDF:SNR=',num2str(SNR(SNR_index(index_snr)))]);
    plot_index=plot_index+1;
end

