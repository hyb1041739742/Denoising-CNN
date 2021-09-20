function A = spec_est (cum,N,range1,range2,order)

% ========================================================
% function A = spec_est (cum,N,range1,range2,order)
%
% Reduced complexity estimation of polyspectrum slices.
% cum    : the n-th order cumulant sequence
% N      : the FFT size
% range1 : the desired slices
% range2 : the desired slices (only for trispectrum)
% order  : 3 for bispectrum, 4 for trispectrum
%
% A      : the desired polyspectrum slices
%
% Author: H. Pozidis,   September 23, 1998
% ========================================================

A1=fft(cum,N);

if (order == 3)

  [n1,n2] = size(cum);
  e1=exp(-j*[0:n1-1]'*range1*2*pi/N);
  A = A1*e1;

elseif (order == 4)

  [n1,n2,n3]=size(cum);
  e1=exp(-j*[0:n1-1]'*range1*2*pi/N);
  for k=1:n3
    A2(:,:,k)=A1(:,:,k)*e1;
  end

  e2=exp(-j*[0:n2-1]'*range2*2*pi/N);
  for k=1:length(range1)
    tmp=squeeze(A2(:,k,:))*e2;
    A(:,k,:)=reshape(tmp,N,1,length(range2));
  end

end
