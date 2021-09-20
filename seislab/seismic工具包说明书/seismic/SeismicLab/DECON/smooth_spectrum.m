function [P,f,w,tw]  = smooth_spectrum(d,dt,L,io);
%SMOOTH_SPECTRUM: Power spectrum estimate by smoothing the periodogram.
%                 For more than one trace provides the average spectrum
%                 followed by smoothing.
%
%  [P,f,w,tw]  = smooth_spectrum(d,dt,L,io);
%
%  IN     d:  data (traces are columns)
%         dt: sampling interval in secs
%         L:  Lenght of the freq. smoothing operator
%             L=0  means no snoothing 
%         io: 'db' in db, 'li' for linear scale 
%
%  OUT    P:  normalized smoothed power spectrum in linear or dB scale.
%         f:  frequency axis 
%         w:  wavelet (zero phase with Power spectrum P)
%         tw:  time axis for wavelet;
%
%  Example: Make a trace and compute the amplitude spectrum and estimate 
%           the wavelet assuming zero phase.
%            
%                    dt = 4./1000; f1 = 2; f2 = 24; c = 0; L = 60;
%                    [w,tw] = make_a_rotated_wavelet(dt,f1,f2,c);
%                    x = conv(randn(200,1),w);
%                    [P,f,we,te] = smooth_spectrum(x,dt,L,'li'); 
%                    subplot(221);plot(f,P); title('Spectrum');
%                    subplot(222);plot(tw,w/max(abs(w)) );hold on;
%                    subplot(222);plot(te,we,'r');axis tight;title('b= true  r=estimated'); 
%
%                    You can also run 
%                    [P,f] = smooth_spectrum(x,dt,L,'li'); 
%                    in this case only the spectrum is computed
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 [nt] = size(d,1);
 wind = hamming(2*L+1);

 nf = max(2*2^nextpow2(nt),2048);

 f = 1:1:nf/2+1;
 f = (f-1)/dt/nf;      % Freq. axis in Hz 

 D = fft(d,nf,1);

 D = abs(D).^2;


 ND = ndims(d);
 

  if ND==2; 
  [nt,nx]=size(d) ;  D =  sum(D,2)/nx; 
  end;

  if ND==3; 
  [nt,nx,ny]=size(d);  
  nx
   ny
D =  sum(squeeze(sum(D,3)),2)/(nx*ny); 

 
  end;

 D = conv(D,wind);     % Smooth 
 N = length(D);
 D = D(L+1:N-L);
 A = sqrt(D);

 D = D(1:nf/2+1,1);
 D = D/max(D);

if(io=='db'); 
 P = 10*log10(D);      % Power spectrum in dB
 I = find(P<-20); P(I)=-20;
else
P = D;
end

if (nargout>2); 

% Make a wavelet    
% For the length I am assuming a wavelet with central
% freq. 30Hz

  f0 = 30;

  L = 3/(f0*dt);
  w = real(fftshift( ifft(A)));
  w = w(nf/2+1-L:nf/2+1+L,1);
  w = w.*hamming(2*L+1);
  w = w/max(abs(w));
  tw = [-L:1:L]*dt;

end;

