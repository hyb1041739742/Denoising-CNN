function [r] = gauss_mixture(N,arg);
%GAUSS_MIXTURE: Compute a reflectivity  using a Gaussian Mixture model.
%               This is used to generate synthetic reflectivities.
%
% [r] = gauss_mixture(N,sigma1,sigma2,p);
%
%  IN     N:      mumber of samples
%         arg=[sigma1,sigma2,p] where
%            sigma1: variance of distribution with probability p
%            sigma2: variance of distribution with probability 1-p
%            p:      mixing parameter (0,1)
%
%  OUT    r:      reflectivity
%
%
%  Example: Make a sparse reflectivity
%
%           N = 500; p = 0.8; sigma1 = 0.01; sigma2 = 1;
%           [r] = gauss_mixture(N,[sigma1,sigma2,p]); plot(r);           
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%


 sigma1 = arg(1);
 sigma2 = arg(2);
 p = arg(3);

 r1 = randn(N,1)*sqrt(sigma1);
 r2 = randn(N,1)*sqrt(sigma2);

 for k=1:N
   if rand(1,1) < p; r(k)=r1(k); else
                     r(k)=r2(k); end;
 end
