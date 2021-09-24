function plot_spectral_attributes(t0,w,dt,fmax,N,pos1,pos2);
%PLOT_SPECTRAL_ATTRIBUTES: plot amplitude and phase of a wavelet
%                          in a nice way (read disclaimer..)
%
%  plot_spectral_attributes(t0,w,dt,fmax,N,pos1,pos2);
%
%  IN     t0:    time in sec of the first sample of the
%         w:     wavelet 
%         w:     data                  "           "
%         dt:    sampling interval in secs
%         famx:  max. freq. to display in Hz
%         N:     plot phase in the interval -N*180,N*180
%         pos1:  position of Ampl. in the figure (221)
%         pos2:  position of Phase in the figure (222);
%
%  Out    A figure in the current figure.
%         
%  Example: ampitude and phase of a 90 degree rotated wavelet
%
%         dt = 4./1000; fl=2; fh=90; c=90;
%         [w,tw] = rotated_wavelet(dt, fl, fh, c);
%         plot_spectral_attributes(min(tw),w,dt,110,1,221,222);
%
%
% Disclaimer: Phase  does not look good when the amplitude is close
%             to zero. If you are plotting the phase of a
%             BL signal you may need to plot the phase in
%             the range where the Band of the signal is non-zero
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 nf = 4*2^nextpow2(length(w));
 n2 = nf/2+1;
 X = fft(w,nf); 
 fa = [0:1:nf-1]'/nf/dt;

% 
% Tell the dft that first sample is at t0 -> to avoid unramping
%
% This is important - Should be shown in an assignment..
%

  Phase_Shift = exp(-i*2*pi*fa*t0);
  X = X.*Phase_Shift;
  n2 = floor( fmax* (nf*dt)) +1;
  X = X(1:n2,1);
  f = [1:1:n2]'; f = (f-1)/nf/dt;
  A = abs(X);
  A  = A/max(A);
  Theta = unwrap(angle(X));
  Theta(1,1) = 0.;
  Theta = Theta*180/pi;

% Plot Amplitue and Phase

  subplot(pos1); plot(f,A);     xlabel('Frequency [Hz]'); ylabel('Ampitude')
                 axis([0,fmax,0,1.1])
                 grid;

  subplot(pos2); plot(f,Theta); xlabel('Frequency [Hz]'); ylabel('Phase [Deg]')
                 axis([0,fmax,-N*180,N*180]);
                 grid;

