function [Dout] = fx_arma(Din,p,flow,fhigh,dt,mu);
%FX_ARMA: ARMA model based projection filter.
%
%  [Dout = fx_arma(Din,p,flow,fhigh,dt,mu);
%
%  IN   Din:   input data matrix, columns are traces
%       p:     lenght of arma(p,p) model
%       flow:  min  freq. in the data in Hz
%       fhigh: max  freq. in the data in Hz
%       dt:    sampling interval in sec
%       mu:    pre-whitening in percent (if too large there
%              is no noise attenuation, if too small both
%              noise and clean signal are attenuated)
%
%  OUT  Dout:  filtered data
%
%  Example: 
%          [d] = linear_events; d = d +0.3*randn(size(d));
%          [dc] = fx_arma(d,2,0.1,120.,0.004,0.1); 
%          wigb([d,dc,d-dc]); 
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%
%

[nt,nh]=size(Din);
nf = 2^nextpow2(nt);

Din = fft(Din,nf,1);
Dout = zeros(nf,nh);

i = sqrt(-1);

ilow  = floor(flow*dt*nf)+1; if ilow<1; ilow=1;end;
ihigh = floor(fhigh*dt*nf)+1;if ihigh>floor(nf/2)+1; ihigh=floor(nf/2)+1;end

for k=ilow:ihigh

y = Din(k,:)';
[s,w,g] = eigen_filtering(y,p,mu);

Dout(k,:) = s';
end;

for k=nf/2+2:nf;
Dout(k,:) = conj(Dout(nf-k+2,:));
end

Dout = real(ifft(Dout,[],1));
Dout = Dout(1:nt,:);
 
return

