function [f,o] = spiking(d,NF,mu);  
%SPIKING: Spiking deconvolution using Levinson's recursion
%
%  [f,o] = spiking(d,NF,mu)
%
%  IN     d:  data (a column trace)
%         NF: lenght of the spiking operator
%         mu: prewhitening in percentage  
%
%  OUT    f:  the filter
%         o:  the ouput or convolution of the data with 
%             the filter (adjusted to the length of the
%             input data) 
%
%  Note: We assume a minimum phase wavelet, we also assume
%        that the reflectivity is a white process. The latter
%        allows us to estimate the autocorrelation of
%        the wavelet from the autocorrelation of the trace.
%
%  Example:
%          w = kolmog(ricker(4/1000,25));   % Min phase wavelet 
%          x = conv(w,randn(400,1));     % Trace
%          [f,o] = spiking(x,30,.1);
%          subplot(211); plot(x); title('data');
%          subplot(212); plot(o); title('deconvolution');
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

NF = NF - 1;

[ns,ntraces] = size(d);
dmax = max(max(d));

R = xcorr(d(:,1),d(:,1),NF);          % Compute data autocorrelation
if ntraces>1;
Ra = R;
for k=2:ntraces;
R = xcorr(d(:,k),d(:,k),NF);          % Compute data autocorrelation
Ra = Ra + R;
end;
R = Ra/ntraces;
end;

Rs = R(:,1).*hamming(NF*2+1);
r = Rs(NF+1:2*NF+1,1);
r(1,1) = r(1,1)*(1 + mu/100.);    % Add pre-whitening for stability

[f] = levinson(r,NF);       % Fast inversion of Toeplitz system 
                            % via Levinson's recursive algorithm
 f = f';                    % I like column vectors

if nargout == 2

 o = conv2(d,f);          
 o = o(1:ns,:);
 omax = max(max(o));
 o = o * dmax/omax;
end
return

