function [D] = impulse(nt,nx,f,dt);
%IMPULSE: Band-limited impulse in the center of a 2D grid.
%  Place a wavelet of central frequency f in the center
%  of an x-t grid.
%
%  [D] = impulse(nt,nx,f,dt);
%
%  IN    nt: number of time samples (vertical samples)
%        nx: number of horizontal samples
%        f:  central freq. of the Ricker wavelet in Hz
%        dt: sampling interval  in sec
%
%  OUT   D:  a matrix with a ricker wavelet in the center
%
%  Example:
%          wigb(impulse(100,20,25,0.004));
%         
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

wave = ricker(f,dt);  nw = max(size(wave));

D = zeros(nt,nx); 
n = floor(nt/2)-floor(nw/2);
D(n:n+nw-1,nx/2) = wave(:); 

return 


