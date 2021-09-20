function [signal,A]=dwconv(wavelet,reflectance)
% �����޻��������Ӳ��ͷ���ϵ�����У���������ź�
% �൱�ڽ�conv(wavelet,reflectance)��ͷȥβ
% [signal,A]=dwconv(wavelet,reflectance)
% wavelet�������Ӳ�����(row)
% reflectance������ϵ������(row)
% signal�������ź�����(row)
% A����wavelet����ɾ���

%--------------����--------------
M=length(wavelet);
N=length(reflectance);
F=reflectance.';
a=wavelet(M:-1:1);
if(M>N)
    error('�Ӳ����ȱ���С�ڷ���ϵ��');
end
A=zeros(N);
kmax=max(a);
for k=1:M
    if(a(k)==kmax)
        m=k-1;
    end
end
temp=0;
for k=1:N    
    for kk=1:N    
        if(kk+m-temp<=M & kk+m-temp>=1)       
            A(k,kk)=a(kk+m-temp);
        end
    end
    temp=temp+1;
end
signal=(A*F).';
return