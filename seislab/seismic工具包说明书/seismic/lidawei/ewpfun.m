function wave=ewpfun(data,lag);
% 子波估计主函数
% ewpfun(data);
% data：输入矩阵

[M,N]=size(data);
if exist('lag')~=1
    lag=99;  
end
nw=2*lag+1;
for k=1:M
    k
    s=data(k,:);
    B=bispectra(s,lag);    
    ph=bmuph(B);% 估计相位       
    %b=bicmagn(s,lag);% 估计振幅 
    if length(s)<=2*lag+1    
        b=abs(fft(s,2*lag+1 ));
    else        
        tmpb=abs(fft(s));
        b(1:lag+1)=tmpb(1:lag+1);
        b(lag+2:2*lag+1)=tmpb(length(s)-lag+1:length(s));
    end
    wave(k,:)=ifftshift(real(ifft(b.*exp(ph.*j))));% 合成子波
end
wave=wave/max(wave);