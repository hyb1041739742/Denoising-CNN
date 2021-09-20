function [Hs] = shannon(x);
%SHANNON: Comptues Shannon entropy using 
%         a Gaussian Kernel Density estimator

  xmin = min(x)*0.9;
  xmax = max(x)*1.1;
  xa = linspace(xmin,xmax,40);

 [Nt,Nx] = size(x);
 if Nx>1; x = reshape(x,Nt*Nx,1);end;
  L = length(x);
  h = 1.06*(L^-0.2)*std(x);
  f = kernel(xa,x,h);
  Hs = -(1/L)* sum (log(f));

