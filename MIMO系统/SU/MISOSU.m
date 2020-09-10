clear 
close all
clc

%%%%�������%%%%%%%%%%%%%%%%%%%%%%%%%%%
N_rece = 1;%����������Ŀ
N_trans = [1,2,4];%����������Ŀ
SNR=-10:1:30;%���������
SNR_linear=10.^(SNR/10);%���������
SNR_Len=length(SNR);%��������ȵ�����
Pn=1./SNR_linear;%�������ʣ������źŹ���Ϊ1��
C_csit=zeros(SNR_Len,1);%
EPOCH=10000;
figure;
for Ant_index = 1:length(N_trans)
    for index=1:SNR_Len
        for epoch=1:EPOCH
            H = 1/sqrt(2)*(randn(N_rece,N_trans(Ant_index))+1i*randn(N_rece,N_trans(Ant_index)));
%             C_csit(index)=C_csit(index)+log(1+SNR_linear(index)/N_trans(Ant_index)*(sum(abs(H).^2)));
            lambda0=svd(H);
            C_csit(index)=C_csit(index)+ log2(1+SNR_linear(index)*lambda0^2);
        end
    end
    C_csit=C_csit/EPOCH;
    plot(SNR,C_csit,'linewidth',2);
    hold on 
end
grid on 
legend('1\times1','2\times1','4\times1');
title('SU-MISO:C~SNR');
xlabel('E_S/N_0');
ylabel('C');