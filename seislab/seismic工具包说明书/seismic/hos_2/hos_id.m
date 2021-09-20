function [hh,HH] = hos_id(Ainv,spec,order,nfft,l1,l2,m1,m2,r,h)

% ---------------------------------------------------------------
% function [hh,HH] = hos_id(Ainv,spec,order,nfft,l1,l2,m1,m2,r)
% ---------------------------------------------------------------
%
% spec  :  the n-th order output spectrum
% nfft  :  the FFT size
% l1    :  the reference slice (bispectrum)
% l2    :  the second slice index (for trispectrum)
% r     :  the distance between the reference slice
%          and the other slice used (l1+r or l1+l2+r)
% m1,m2 :  the actual slice index in the polyspectrum
%
% Author: H. Pozidis,   September 23, 1998
% ---------------------------------------------------------------

HH=[];
if (order == 3)
  p1=spec(:,l1+r);
  p2=spec(:,l1);
  n1=m1+r;  n2=m1;
elseif (order == 4)
  p1=spec(:,l1,l2+r);
  p2=spec(:,l1,l2);
  n1=m1+m2+r;  n2=m1+m2;
end 
d=log(p2)-log(p1);

cw1=(1/nfft)*sum(-d);

arr=[-n1+1:-1:-n1-nfft+3];
arr=modulo(arr,nfft);
c=d(arr+1)+cw1;

Hl=Ainv*c;
Hl=Hl(:).';

HH=[1 exp(Hl)];

hh=(ifft(HH));
[o,p]=max(abs(hh));
hh=hh/hh(p);
[o,p]=max(abs(h));
hh=hh*h(p);
