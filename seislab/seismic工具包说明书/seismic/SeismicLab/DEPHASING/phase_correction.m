function dout = phase_correction(din,c);
%PHASE_CORRECTION: Apply a constant Phase correction to seismic
%                  data. The opimal correction can be determined
%                  via the examination of the Kurtosis.
%              
%  see:  Longbottom, J., Walden, A.T. and White, R.E. (1988) Principles and 
%        application of maximum kurtosis phase estimation. Geophysical 
%        Prospecting, 36, 115-138.
%
%  [dout] = phase_correction(din,c);
%
%  IN   din:      Seismic data (traces in columns);
%       c:        Constant Phase rotation in degrees
%
%  OUT  dout:     data after correction
%
%  Example: Make a 90.deg rotated wavelet and correct
%           it back to 0.deg.  
%
%
%      dt = 4./1000; fl=4, fh=30, c=90;
%      [w,t] = rotated_wavelet(dt,fl,fh,c);
%      [wout] = phase_correction(w,-c);
%      plot_wb(t,[w,wout],50);
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2005 SeismicLab
%  Revision: 1.2  Date: Ago/2005
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA


  c = c*pi/180;
  [nt,nx]=size(din);
  nf = 2^nextpow2(nt);
  [nt,nx]=size(din);

  Din = fft(din,nf,1);

  Phase = exp(-i*[0;-c*ones(nf/2-1,1);0;c*ones(nf/2-1,1)]);

   for k=1:nx;
     Din(:,k) = Din(:,k).*Phase;
   end

 dout = ifft(Din,nf,1);
 dout = real(dout(1:nt,:));

