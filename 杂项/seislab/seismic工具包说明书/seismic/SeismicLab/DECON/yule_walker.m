function [P,f,a,w,w_min] = yule_walker(D,p,dt,perc,nw);
%YULE_WALKER: Yule-Walker estimate of a smooth AR spectrum.
%             compute average autoc. and crosscorrelations
%             to solve the AR problem using Yule Walker method.
%             The smooth spectrum is used to compute two wavelets:
%             min and zero phase wavelets                           
%             AR: means Autoregressive Model
%
%  [P,f,a,w,w_min] = jule_walker(D,p,dt,nw);
%
%  IN   D:      seismic traces (traces are columns)
%       p:      order of the AR process
%       dt:     sampling rate
%       perc:   % of pre-whitening 
% 
%  OUT  P:      the power spectrum (P(1:nf))
%       f:      freq. axis  (f(1:nf); this is to do plot(f,P) in Hz
%       a:      the AR operator
%       w:      the zero phase wavelet 
%       w_min:  the minimum  phase wavelet 
%
%  Note: Both wavelets share the same amplitude spectrum P(f)
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%
        
% Set convolution matrix and rhs term

 lf = p;
 [nt,nh] = (size(D));

% Average autocorrelation

 R = zeros(lf,lf);
 g = zeros(lf,1);
 for k=1:nh
  C = convmtx(D(:,k),lf);
  R = R + C'*C;
  d = [D(2:nt,k);zeros(lf,1)];  
  g = g + C'*d;
 end

 R = R/nh;
 g = g/nh;

% Compute the inverse filter 

 mu=R(1,1)*perc/100;

 f = (R+mu*eye(lf))\g ; 

 a = [1;-f];


% AR Spectrum of the wavelet

 nF=2^nextpow2(nw);

 A=abs(fft(a,nF));
 P = real(1./A.^2);

% Amplitude spectrum of the wavelet

 A = sqrt(P);

% Now compute the optimum zero phase wavelet

 w = fftshift(real(ifft(A)));
 w = w/max(abs(w));

% Min Phase wavelet 

 W = log (A +0.00001);
 W = ifft(W);

 W(nF/2+2:nF,1) = 0;
 W = 2.*W;
 W(1) =W(1)/2.;

 W = exp(fft(W)) ;
 w_min = real(ifft(W));
 w_min = w_min/max(abs(w_min));


% Spectrum 

 P = real(P(1:nF/2+1,1));
 Pmax = max(P);
 P = P/Pmax;
 df=1./(dt*nF);
 f=0:df:(nF/2)*df;

