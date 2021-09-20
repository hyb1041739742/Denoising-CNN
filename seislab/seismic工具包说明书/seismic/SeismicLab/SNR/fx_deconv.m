function [DATA_f] = fx_deconv(DATA,lf,mu,flow,fhigh,dt,type);
%FX_DECONV: SNR enhancement using FX-AR modelling.
%           This is  Canales' FX deconvolution.
%
%  [DATA_f] = fx_deconv(DATA,lf,mu,flow,fhigh,dt,itype)
% 
%  IN   DATA:   the data matrix, columns are traces
%       lf:     lenght of the AR process (lenght of the filter)
%       flow:   min  freq. in the data in Hz
%       fhigh:  max  freq. in the data in Hz
%       dt:     sampling interval in sec
%       mu:     pre-whitening 
%       type:   Forward prediction type=1
%               Backward prediction type=-1
% 
%  OUT  DATA_f: filtered data
%
%  Example:
%          [d] = linear_events; d = d +0.3*randn(size(d));
%          [dc] = fx_deconv(d,12,0.1,1,120.,0.004,1);
%          wigb([d,dc,d-dc]);
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

[nt,ntraces] = size(DATA);

nf = 2^nextpow2(nt);
 
DATA_FX_f = zeros(nf,ntraces);

% Lower and Upper samples of the DFT.

ilow  = floor(flow*dt*nf)+1; if ilow<1; ilow=1;end;
ihigh = floor(fhigh*dt*nf)+1;if ihigh>floor(nf/2)+1; ihigh=floor(nf/2)+1;end

% Go into FX

DATA_FX = fft(DATA,nf,1);

for k=ilow:ihigh;
  aux_in  = DATA_FX(k,:)';
  aux_out = ar_f_b(aux_in,lf,mu,type);
  DATA_FX_f(k,:) = aux_out';
end;
  for k=nf/2+2:nf
  DATA_FX_f(k,:) = conj(DATA_FX_f(nf-k+2,:));
end

% Back to TX (the output) 

 DATA_f = real(ifft(DATA_FX_f,[],1));
 DATA_f = DATA_f(1:nt,:);

return

