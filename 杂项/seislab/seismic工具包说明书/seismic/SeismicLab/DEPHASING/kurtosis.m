function [K] = kurtosis(x)
%KURTOSIS: Compute the kurtosis of a time series or
%          of a multichannel series
%
%  [K] = kurtosis(x);
%
%  IN   x:      data (vector or matrix)
%
%  OUT  K:      Kurtosis
%
%
%  Kurtosis is defined as K = E(x^4)/ (E(x^2))^2;
%
%    K = 3 for a Gaussian series 
%
%  There is a different definiton k' = K-3
%
%    k' = 0 for a Gaussian series
%
%  k' is called the Kurtosis Excess. This matlab 
%  function computes K not k'.
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2005 SeismicLab
%  Revision: 1.2  Date: Ago/2005
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 N = ndims(x);

[n1,n2]=size(x);
 Ns = n1*n2;

 if N==1; 
  sum1 = sum(x.^4)/Ns;
  sum2 = (sum(x.^2)/Ns)^2;
 end;
 
 if N==2; 
  sum1 = sum(sum(x.^4)/Ns);
  sum2 = (sum(sum(x.^2))/Ns)^2;
 end;

 K = sum1/sum2;
