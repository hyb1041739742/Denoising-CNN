function [d,t,h] = linear_events(dt,f0,tmax,h,tau,p,amp,snr,L);
%LINEAR_EVENTS: A program to generate data containing linear events.
%
%  [d] = linear_events(dt,f0,tmax,h,tau,p,amp,snr,L);
%
%  IN   dt:        sampling interval in secs
%       f0:        central freq. of a Ricker wavelet in Hz
%       tmax:      maximun time of the simulation in secs
%       h:         vector of desire offsets in meters
%       tau,p,amp: vectors of intercept, ray paramter 
%                  and amplitude of each linear event
%                  (p is in sec/m and tau in secs)
%       snr:       signal to noise ratio (max amplitude in the clean
%                  signal/standart error of the gaussian noise)
%         L:       The random noise is average over L-time samples
%                  to simulate band-pass noise (L=1 means no averaging)
%            
%
%  OUT  d:         data that consist of a superposition of linear events
%  
%  Example 1: Plot 3 linear events using default parameters 
%
%             [d,t,h] = linear_events; wigb(d,1,h,t); xlabel('offset [m]'); ylabel('t [s]');
%
%  Example 2: Generation of two linear events with user defined parameters
%
%             dt = 4./1000; f0=20; tmax=1.; 
%             h=1:5:100; 
%             tau=[0.1,0.6];
%             p=[0.001,-0.005];
%             amp=[2.,-1];
%             snr = 6.;
%             L = 6;
%             [d] = linear_events(dt,f0,tmax,h,tau,p,amp,snr,L);
%             wigb(d);       
%
%  Note: Program used to test fx deconv and interpolation methods
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
  tmax = 0.5;
  h = [0:6:200];
  tau = [0.12, 0.2, 0.2];
  p = [0.001,-0.0001,0.0004];
  amp = [.5, -0.9, 0.9];
  f0 = 20;
  snr = 25;
  L = 5;
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


 delay = dt*(floor(nw/2)+1);

 for ifreq=1:nfft/2+1
  w = 2.*pi*(ifreq-1)/nfft/dt;
   for k=1:n_events
    Shift = exp(-i*w*(tau(k)+h*p(k)-delay));
   D(ifreq,:) = D(ifreq,:) + amp(k)* W(ifreq)*Shift;
  end
 end

% w-domain symmetries

 for ifreq=2:nfft/2
  D(nfft+2-ifreq,:) = conj(D(ifreq,:));
 end 

 d = ifft(D,[],1);
 d = real(d(1:nt,:));

% my definition of snr = (Max Amp of d)/sigma 

 dmax  = max(max(d));
 op = hamming(L);
 ops = sum(sum(op));
 op = op/ops;
 Noise = conv2(randn(size(d)),op,'same');

 sigma = dmax/snr; 

 d = d + sigma * Noise;

if nargout>1;
 t = (0:1:nt-1)*dt; 
end;

 return;
