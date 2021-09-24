function [S,ARG] = propagator(v,nx,nz,nt,dx,dz,dt,con);
%PROPAGATOR: Compute downward and upward propagators in constant v media.
%  Called by gazdag.m  
%
%  [S,ARG] = propagator(v,nx,nz,nt,dx,dz,dt,con);
%
%  IN   v:     propagation velocity in m/s
%       nx,nz: image size
%       dx,dz: grid size in meters
%       dt:    time interval in secs
%       con:   1:modelling, -1:Migration
%
%  OUT  S:     phase shift propagator for forward modeling or migration
%       ARG:   wavenumber matrix
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 dkx=2*pi/(nx*dx);
 dw=2*pi/(nt*dt);
 kx=[0:dkx:(nx/2)*dkx -((nx/2)*dkx-dkx):dkx:-dkx];
 w =[0:dw:(nt/2)*dw -((nt/2)*dw-dw):dw:-dw];
 index=find(w == 0);
 w(index)=1E-18;
 [kx,w] = meshgrid(kx,w);
 ARG = 1.0-(kx.^2*v^2)./(w.^2);
 index=find(ARG < 0.);
 ARG(index) = 0.;

 if con==1;
 S = zeros(nt,nx);
 S = exp(-i*w/v.*sqrt(ARG)*dz);
 S(index) = 0.0;
 end

 if con==-1;
 S = zeros(nt,nx);
 S = exp(i*w/v.*sqrt(ARG)*dz);
 S(index) = 0.0;
 end

return

