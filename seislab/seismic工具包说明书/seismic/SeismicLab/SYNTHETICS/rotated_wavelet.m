function [w,t,A,P,freq] = make_a_rotated_wavelet(dt,fl,fh,c);
%ROTATED_WAVELET: bandlimited wavelet with phase rotation c
%                 (analytical sol) 
%  [w,t,A,P,freq] = rotated_wavelet(dt,fl,fh,c);
%
%  IN     dt:   sampling interval in sec
%         fl:   min freq. in Hz
%         fh:   max freq. in Hz
%         c:    rotation in degs
%
%  OUT    w:    wavelet (column)
%         t:    time axis in secs
%         A:    Amplitude spectrum
%         P:    phase spectrum in degs
%         freq: freq. axis in Hz
%
%  Examples:
%
%             [w,t,A,P,freq] = rotated_wavelet(0.002,10,60,90);
%             subplot(221); plot(t,w);    xlabel('Time (s)'); axis tight; grid
%             subplot(223); plot(freq,A); xlabel('f (Hz)');
%             subplot(224); plot(freq,P); xlabel('f (Hz)');
%
%  Notes:
%  Phase for f>fh and f<hl does not make any sense, I take it as zero;
%  it should be taken as undefined.
%  
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%


% Define a characterisic length for the wavelet 

 fc = (fh-fl)/2
 L = 4*floor(2.5/fc/dt);

 t = dt*[-L:1:L]';
 B = 2*pi*fh;
 b = 2*pi*fl;
 c = c*pi/180;

 w = sin(c+B*t)-sin(c+b*t);

% avoid 0/0 (Use L'Hopital rule)

 I = find(t==0);
 t(I)=99999;

 w = w./(t*pi);
 w(I) = (B/pi)*cos(c)-(b/pi)*cos(c);
 t(I) = 0.;

% Normalize with dt to get unit amplitude spectrum 
% and smooth with a Hamming window

 w = dt*w.*hamming(length(w));

 nw = 2*L+1;  nh=L+1;

 nf = 4*2^nextpow2(nw);

% Take into account the wavelet in non-causual
% This will remove linear phase shift and
% show the actual phase of the wavelet

 ww = [w(nh:nw,1);zeros(nf-nw,1);w(1:nh-1,1)];

 W = fft(ww);
 M = length(W)/2+1;
 A = abs(W(1:M,1));
 P = (180/pi)*(angle(W(1:M,1)));
 Kh = floor(fh*nf*dt)+1;
 Kl = floor(fl*nf*dt)+1;
 P(Kh+1:M,1)=0;
 P(1:Kl,1)=0;

% freq axis in Hz
 freq = (0:1:M-1)/dt/nf;


