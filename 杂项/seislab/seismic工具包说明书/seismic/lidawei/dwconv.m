function [signal,A]=dwconv(wavelet,reflectance)
% 计算褶积，输入子波和反射系数序列，输出地震信号
% 相当于将conv(wavelet,reflectance)掐头去尾
% [signal,A]=dwconv(wavelet,reflectance)
% wavelet：地震子波序列(row)
% reflectance：反射系数序列(row)
% signal：地震信号序列(row)
% A：将wavelet构造成矩阵

%--------------程序--------------
M=length(wavelet);
N=length(reflectance);
F=reflectance.';
a=wavelet(M:-1:1);
if(M>N)
    error('子波长度必须小于反射系数');
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