function  [w,tw] =  trapezoidal_wavelet(dt,f1,f2,f3,f4,c);
%TRAPEZOIDAL_WAVELET: Computes a FIR band-pass filter with 
%                     phase rotation c
% 
%  [w,tw] = make_a_trapezoidal_wavelet(dt,f1,f2,f3,f4,c);
%
%  IN     dt:   sampling interval in sec
%         f1:   freq. in Hz
%         f2:   freq. in Hz
%         f3:   freq. in Hz
%         f4:   freq. in Hz
%         c:    rotation in degs
%
%   ^
%   |     ___________
%   |    /           \   Amplitude spectrum
%   |   /             \
%   |  /               \
%   |------------------------>
%      f1 f2        f3 f4
%
%  OUT    w:    wavelet (column)
%        tw:    time axis in secs
%
%
%  Example:
%   
%     dt =4./1000; f1=10; f2=20; f3=40; f4=60; c=90
%     [w,tw] = trapezoidal_wavelet(dt,f1,f2,f3,f4,c);
%     plot_area(tw,w,4,-10);
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%


 fc = (f3-f2)/2;
 L = floor(1.5/(fc*dt));
 nt = 2*L+1;
 k = nextpow2(nt);
 nf = 4*(2^k);

 i1 = floor(nf*f1*dt)+1;
 i2 = floor(nf*f2*dt)+1;
 i3 = floor(nf*f3*dt)+1;
 i4 = floor(nf*f4*dt)+1;

 up =  (1:1:(i2-i1))/(i2-i1);
 down = (i4-i3:-1:1)/(i4-i3);
 aux = [zeros(1,i1), up, ones(1,i3-i2), down, zeros(1,nf/2+1-i4) ];
 aux2 = fliplr(aux(1,2:nf/2));

 F = ([aux,aux2]');
 Phase = (pi/180.)*[0.,-c*ones(1,nf/2-1),0.,c*ones(1,nf/2-1)];
 Transfer = F.*exp(-i*Phase');
 temp = fftshift((ifft(Transfer)));
 temp =real(temp);

 
 w = temp(nf/2+1-L:nf/2+1+L,1);
 nw = length(w);
 w = w.*hamming(nw);

 if nargout>1;
  tw = (-L:1:L)*dt;
 end;
 

