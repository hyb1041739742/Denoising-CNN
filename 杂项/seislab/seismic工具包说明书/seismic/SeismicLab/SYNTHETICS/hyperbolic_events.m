function [d] = hyperbolic_events(dt,f0,tmax,h,tau,v,amp,snr,L);
%HYPERBOLIC_EVENTS: A program to generate data containing linear events.
%
%  [d] = linear_events(dt,f0,tmax,h,tau,p,amp,snr);
%
%  IN   dt:        sampling interval in secs
%       f0:        central freq. of a Ricker wavelet in Hz
%       tmax:      maximun time of the simulation in secs
%       h:         vector of offsets in meters
%       tau,v,amp: vectors of intercept, rms velocities
%                  and amplitude of each linear event
%                  (p is in sec/m and tau in secs)
%       snr:       signal to noise ratio (max amplitude in the clean
%                  signal/standard error of the Gaussian noise)
%         L:       The random noise is average over L-time samples
%                  to simulate band-pass noise (L=1 means no averaging)
%            
%
%  OUT  d:         data that consist of a superposition of linear events
%  
%  Example 1: Plot 3 linear events using default parameters 
%
%             d = linear_events; wigb(d);
%
%  Example 2: Generation of two linear events with user defined parameters
%
%             dt = 4/1000; f0 = 20; tmax = 2.2; 
%             h=20:10:1500
%             tau = [0.1,0.2,.9,2.]; 
%             v = [1200,2000,2000,3000]; 
%             amp = [1,-1,1,-1]; 
%             snr = 10; L = 4;
%             [d] = hyperbolic_events(dt,f0,tmax,h,tau,v,amp,snr,L);
%             wigb(d);       
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

if nargin == 0
  dt = 4./1000;
  tmax = 1.5;
  h = [0:20:20*(50-1)];
  tau = [0.2, 0.4, 0.5,1,1.1];
  v = [1000,1200,1400,2000,1900];
  amp = [2., -1., 1.,1,-1];
  f0 = 20;
  snr = 30;
  L = 15;
end;
 
 nt = floor(tmax/dt)+1;
 nfft = 4*(2^nextpow2(nt));
 n_events = length(tau);
 nh = length(h);
 wavelet = ricker(f0,dt); 
 nw = length(wavelet);
 W = fft(wavelet,nfft);
 D = zeros(nfft,nh);
 i = sqrt(-1);

% Important: this is to have the maximum of the ricker
% wavelet at the right intercept time...

 delay = dt*(floor(nw/2)+1);

 for ifreq=1:nfft/2+1
  w = 2.*pi*(ifreq-1)/nfft/dt;
   for k=1:n_events
    Shift = exp(-i*w*(  sqrt(tau(k)^2 + (h/v(k)).^2) - delay));
   D(ifreq,:) = D(ifreq,:) +amp(k)* W(ifreq)*Shift;
  end
 end

% Apply w-domain symmetries

 for ifreq=2:nfft/2
  D(nfft+2-ifreq,:) = conj(D(ifreq,:));
 end 

 d = ifft(D,[],1);
 d = real(d(1:nt,:));

% my definition of snr = (Max |d|)/sigma_noise 

 dmax  = max(max(d));

 op = hamming(L);
 ops = sum(sum(op));
 op = op/ops;
 Noise = conv2(randn(size(d)),op,'same');

 sigma = dmax/snr; 

 d = d + sigma * Noise;

 return;
