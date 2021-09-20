function polar_plot(z);
%POLAR_PLOT: Plot the roots of a wavelet in polar coordinates.
%
%  polar_plot(z)
%
%  IN   z: zeros of the wavelet, they can be computed
%          with zeros_wav.m
%
%  NOTE: some zeros migth end up outside the plot (check axis)
%
%  Example:    w = conv([2 -1 0.6+i*1 ],[1 -2 0+1.1*i] );
%              z = zeros_wav(w);
%              figure(1); polar_plot(z);
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%
 
% Draw a circle of radio one, then draw the roots in
% polar coordinates
 
 x=cos(0:0.1:2*pi); y = sin(0:0.1:2*pi);
 
 II = find(abs(z)<1); z1=z(II);
 
 plot(x,y);hold on;plot(real(z),imag(z),'sk'); 
                  ;plot(real(z1),imag(z1),'*r'); 
axis equal;
 axis([-2,2,-2,2]);
return

