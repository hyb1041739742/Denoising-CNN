function [m] = inverse_radon(d,dt,h,q,N,flow,fhigh,mu,ttype);
%INV_RADON: Inverse linear or parabolic Radon transform. 
%
%  [m] = inverse_radon(d,dt,h,q,N,flow,fhigh,mu)
% 
%  IN   d:     seismic traces   
%       dt:    sampling in sec
%       h(nh): offset or position of traces in meters
%       q(nq): ray parameters  if N=1
%              residual moveout at far offset if N=2
%       N:     N=1 Linear tau-p  
%              N=2 Parabolic tau-p
%       flow:  freq.  where the inversion starts in HZ (> 0Hz)
%       fhigh: freq.  where the inversion ends in HZ (< Nyquist) 
%       mu:    regularization parameter 
%       ttype: 'ls' least-squares solution
%
%  OUT  m:     the linear or parabolic tau-p panel
%
%
% THis is the least squares solution proposed by Hampson (1985).
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 [nt,nh] = size(d);
 nq = max(size(q));

 if N==2; h=h/max(abs(h));end;  
 nfft = 2*(2^nextpow2(nt));

 D = fft(d,nfft,1);
 M = zeros(nfft,nq);
 i = sqrt(-1);

 ilow  = floor(flow*dt*nfft)+1; 
 if ilow < 2; ilow=2; end;
 ihigh = floor(fhigh*dt*nfft)+1;
 if ihigh > floor(nfft/2)+1; ihigh=floor(nfft/2)+1; end

% Initial parameters 

 Q = eye(nq);

 ilow = max(ilow,2);

 for ifreq=ilow:ihigh

  f = 2.*pi*(ifreq-1)/nfft/dt;
  L = exp(i*f*(h.^N)'*q); 
  y = D(ifreq,:)';
  xa = L'*y;
  A = L'*L + mu*Q;
  x  =  A\xa; 

 M(ifreq,:) = x';
 M(nfft+2-ifreq,:) = conj(x)';

end

 M(nfft/2+1,:) = zeros(1,nq);
 m = real(ifft(M,[],1));
 m = m(1:nt,:);
return


