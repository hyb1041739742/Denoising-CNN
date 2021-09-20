function wav=minimum_phase(amp,nsamp)
% Function computes minimum-phase wavelet with given amplitude spectrum
% INPUT
% amp    amplitude spectrum
% nsamp  number of samples of desired wavelet
% OUTPUT
% wav    minimum-phase wavelet with amplitude spectrum "amp"

amp(amp <=0 )=eps;
temp=fft(log(amp));
namp=length(amp);
namph=fix(namp/2);

temp=real(temp(2:nsamp)).*(1:nsamp-1)'/namph;
wav=ones(nsamp,1);
wav(2)=temp(1);
for ii=2:nsamp-1
   wav(ii+1)=sum(wav(ii:-1:1).*temp(1:ii))/ii;
end

