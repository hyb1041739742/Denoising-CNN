function [d]=forward_radon(m,dt,h,p,N,flow,fhigh);
%FOR_RADON: Forward linear and parabolic Radon transform. 
%  Given a Radon panel (tau-p), this function  maps 
%  the tau-p gather into time-offset space (data).
%
%  [d] = forward_taup(m,dt,h,p,N,flow,fhigh);
%
%  IN   m:     the Radon panel, a matrix m(nt,np)
%       dt:    sampling in sec
%       h(nh): offset or position of traces in mts
%       p(np): ray parameter  to retrieve if N=1
%              curvature of the parabola if N=2
%       N:     N=1 linear tau-p
%              N=2 parabolic tau-p
%       flow:  min freq. in Hz
%       fhig:  max freq. in Hz
%
%  OUT  d:     data
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%


[nt,nq] = size(m);
     nh = length(h);

 if N==2; h=(h/max(abs(h))).^2; end;   

 nfft = 2*(2^nextpow2(nt));

 M = fft(m,nfft,1);
 D = zeros(nfft,nh);
 i = sqrt(-1);

 ilow  = floor(flow*dt*nfft)+1; 
 if ilow < 1; ilow=1; end;
 ihigh = floor(fhigh*dt*nfft)+1;
 if ihigh > floor(nfft/2)+1; ihigh = floor(nfft/2)+1; end
 
 for ifreq=ilow:ihigh
  f = 2.*pi*(ifreq-1)/nfft/dt;
  L = exp(i*f*h'*p);
  x = M(ifreq,:)';
  y = L * x; 
  D(ifreq,:) = y';
  D(nfft+2-ifreq,:) = conj(y)';
 end

 D(nfft/2+1,:) = zeros(1,nh);
 d = real(ifft(D,[],1));
 d = d(1:nt,:);

return;
