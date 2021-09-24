function f = kernel(xa,x,h);
%KERNEL:  Density (1D) estimation using a Gaussian Kernel
%         Density Estimator. This is  used to compute the plugin 
%         estimators of entropy
%
% Silverman, B. W. (1986). Density Estimation for 
% Statistics and Data Analysis. Chapman and Hall: London
%
%  IN   xa:       density axis f=f(xa)   
%       x:        deviates 
%       h:        Kernel width
%
%  OUT  f:        Gaussian Kernel Density Estimator
%
%  Recommended h,  h = 1.06 * nx^-0.2 * sigma
%  but not sure if this is a good value.
%
%  Example:
%           x = randn(100,1); 
%           xa = [-5:0.1:5]; 
%           nx = length(x);
%           h = 1.06 * (nx^-0.2) * std(x);
%           f = kernel(xa,x,h);
%           plot(xa,f);
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2005 SeismicLab
%  Revision: 1.2  Date: Ago/2005
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 nxa = length(xa);
 f = zeros(nxa,1);
 nx = length(x);
 c = 1/sqrt(2*pi);
 [X,Xa] = meshgrid(x,xa);
 arg = (X-Xa)/h;
 f = exp(-0.5*arg.^2);
 f = sum(f,2);
 f = c*f'/nx/h;







