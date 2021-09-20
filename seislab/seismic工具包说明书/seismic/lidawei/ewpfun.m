function wave=ewpfun(data,lag);
% �Ӳ�����������
% ewpfun(data);
% data���������

[M,N]=size(data);
if exist('lag')~=1
    lag=99;  
end
nw=2*lag+1;
for k=1:M
    k
    s=data(k,:);
    B=bispectra(s,lag);    
    ph=bmuph(B);% ������λ       
    %b=bicmagn(s,lag);% ������� 
    if length(s)<=2*lag+1    
        b=abs(fft(s,2*lag+1 ));
    else        
        tmpb=abs(fft(s));
        b(1:lag+1)=tmpb(1:lag+1);
        b(lag+2:2*lag+1)=tmpb(length(s)-lag+1:length(s));
    end
    wave(k,:)=ifftshift(real(ifft(b.*exp(ph.*j))));% �ϳ��Ӳ�
end
wave=wave/max(wave);