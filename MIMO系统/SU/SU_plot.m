clear
clc
close all

addpath('./SU_func');
addpath('../function2use');

SNR=-10:1:30;%∑¬’Ê–≈‘Î±» 
EPOCH=10000;
N_Len=3;

C_MISO=MISOSU_plot(EPOCH,SNR);
[C_MIMO_csit,C_MIMO_csir]=MIMOSU_plot(EPOCH,SNR);

figure;
for ii=1:N_Len
    plot(SNR,C_MIMO_csit(:,ii),'linewidth',2);
    hold on
end
for ii=1:N_Len

    plot(SNR,abs(C_MIMO_csir(:,ii)),'linewidth',2);
    hold on 
end
grid on 
legend('csit:1\times1','csit:2\times2','csit:4\times4','csir:1\times1','csir:2\times1','csir:4\times1');
xlabel('E_S/N_0');
ylabel('C');
title('SU-MIMO:C~SNR');

figure;
for ii=1:N_Len
    plot(SNR,C_MIMO_csit(:,ii),'linewidth',2);
    hold on
end
for ii=1:N_Len

    plot(SNR,abs(C_MIMO_csir(:,ii)),'linewidth',2);
    hold on 
end
for ii=1:N_Len
    plot(SNR,C_MISO(:,ii),'linewidth',2);
    hold on
end
grid on 
legend('csit:1\times1','csit:2\times2','csit:4\times4','csir:1\times1','csir:2\times1','csir:4\times1','MISO:1\times1','MISO:2\times1','MISO:4\times1');
xlabel('E_S/N_0');
ylabel('C');
title('SU-MIMO:C~SNR');