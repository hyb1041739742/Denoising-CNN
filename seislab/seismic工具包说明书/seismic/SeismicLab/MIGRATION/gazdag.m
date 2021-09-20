function [Dout] = gazdag(Din,v,nx,nz,nt,dx,dz,dt,fmax,con) 
%GAZDAG: Constant velocity migration using Gazdag method.
%
%  [Dout] = gazdag(Din,v,nx,nz,nt,dx,dz,dt,fmax,con) 
%
%  Note that the  i/o Matrices Din and Dout
%  change according to the flag con 
%
%  IN   con  = 0       Migration flag
%       Din(nt,nx):    the poststack data
%       conj = 1       Modeling flag
%       Din(nz,nx):    image of the subsurface        
%       dx,dx:         image grid size in meters
%       dt:            sampling interval in secs
%       fmax:          maximum freq. in the data (Hz)
%
%        
%  OUT  con  = 1       Modeling flag
%       Dout(nt,nx):   data
%       conj = 0       Migration flag 
%       Dout(nz,nx):   migrated image
%
%  This code needs the input variables S ad ARG that
%  are generated by propagator.m. Note that propagator.m
%  computes the downward and the upward operator choose
%  one according to variable conj.
%
%
%  Author(s): M.D.Sacchi and H. Kuehl (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

[S,ARG] = propagator(v,nx,nz,nt,dx,dz,dt,con);


if1=2;
if2=floor(fmax*(nt*dt))+1;

n1 = if1;     n2 = if2;
n3 = nt-n2+2; n4=nt-n1+2;

Band = zeros(1,nt);
Band(1,n1:n2) = 1;
Band(1,n3:n4) = 1;

 tc = (nt-1)*dt;

% Migration 

 sumv = ones(1,nt);
 sumv = Band;

if con==0;

 FFTD=fft2(Din); 
 IMAGE = zeros(nz,nx); 
 
 for iz=1 : nz
  FFTD = FFTD.*S;
   aperture = ones(nt,nx);
   t0 = (iz-1)*dz/v;
   index=find(ARG <= (t0/tc)^2);
   aperture(index) = 0.0; 
  IMAGE(iz,:) = sumv*(aperture.*FFTD/nt);
 end
 Dout=real(ifft(IMAGE,[],2)); 

end;

% Modeling 

spray = ones(nt,1);
spray = Band';

if con==1;
  IMAGE=fft(Din,[],2);
  FFTD = zeros(nt,nx);
  for iz=nz:-1:1
   aperture = ones(nt,nx);
   t0 = (iz-1)*dz/v;
   index=find(ARG <= (t0/tc)^2+.1);
   aperture(index) = 0.0;
  FFTD = FFTD+aperture.*(spray*IMAGE(iz,:));
  FFTD = FFTD.*S;  
  end
 Dout=real(ifft2(FFTD));
end;

return;
