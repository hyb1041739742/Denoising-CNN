function bi=bicmagn(s,lag,nsamp,overlap,flag,nfft)
% ��˫�׷�ֵ�ع�
% bicmagn(s,lag,nsamp,overlap,flag,nfft)
% s��      �����ź�
% lag��    �ӳ٣�default=fix[length(s)/2]��
% nsamp��  ÿ�βμӼ���Ĳ���������default=2*lag+1��
% overlap���ص��ٷֱȣ�default=0��
% flag��   'biased'Ϊ��ƫ���ƣ�'unbiased'Ϊ��ƫ���ƣ�default='biased'��
% nfft��   ���ϱ任���ȣ�default=2*lag+1��

% ----------����-----------
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
b=b-min(b); % ��С��
bi=ifftshift(smooth(fftshift(b),3).');
bi=bi-min(bi);