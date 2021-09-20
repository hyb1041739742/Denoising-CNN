function bi=bicmagn(s,lag,nsamp,overlap,flag,nfft)
% 倒双谱幅值重构
% bicmagn(s,lag,nsamp,overlap,flag,nfft)
% s：      输入信号
% lag：    延迟（default=fix[length(s)/2]）
% nsamp：  每段参加计算的采样点数（default=2*lag+1）
% overlap：重叠百分比（default=0）
% flag：   'biased'为有偏估计，'unbiased'为无偏估计（default='biased'）
% nfft：   傅氏变换长度（default=2*lag+1）

% ----------程序-----------
n=length(s);
if(exist('lag')~=1)
    lag=fix(n/2);
end
if(exist('nsamp')~=1)
    nsamp=2*lag+1;
end
if(exist('overlap')~=1)
    overlap=0;
end
if(exist('flag')~=1)
    flag='b';
end
if(exist('nfft')~=1)
    nfft=2*lag+1;
end
B=bispeci(s,lag,nsamp,0,flag,nfft);
%B=fftshift(fft(ifftshift(c3x(s,lag))));
[M,N]=size(B);
B=B+randn(M,N)*0.001;
dM=ifft2(ifftshift(2*(log(abs(B)))));
dM(1,:)=0;
dd=dM(:,1)';
b=real(sqrt(exp(fft(dd))));
b=b-min(b); % 最小化
bi=ifftshift(smooth(fftshift(b),3).');
bi=bi-min(bi);