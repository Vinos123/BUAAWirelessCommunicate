function C_csit=C_csit_cal(H,SNR)
s=svd(H);
Num2search=length(s);
for n=Num2search:-1:1
    mu_SNR=(SNR+sum(1./(s(1:n).^2)))/ n;
    if(mu_SNR>1/(s(n)^2))
        break;
    end
end

C_csit=sum(log2(1+max((mu_SNR-1./(s.^2)),0).*s.^2));

end
