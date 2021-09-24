function [s,w,g] = eigen_filtering(y,p,mu);
%EIGEN_FILTERING: 1D ARMA Prediction also called projection filter.
%                 This function is used  by function fx_arma.m,
%
%  [s,w,g] = eigen_filtering(y,p,mu);
%
%  IN   y:     input 1D data (a trace or a freq. slice in fx)
%       p:     order of the arma(p,p) process
%       mu:    pre-whitening in percent
%
%  OUT  s:     clean output data
%       w:     noise estimate
%       g:     arma(p,p) operator (Pisarenko filter!)
%%
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%
%
 N = length(y);
 Y = convmtx(y,p+1);
 R = Y'*Y/N;                         % data correlation matrix
[g,Pw] = eigs(R,1,'SM');             % compute 1 eigenvalue (the SMallest)
 g0 = g(1)
 g  = g/g0;
 e = Y*g;                            % non-white sequence e
 G = convmtx(g,N);                   % correlation matrix of the filter
 D = eye(N)*mu;                      % regularization term
 w = inv(G'*G+D)*G'*e;                     % estimate of the noise
 s = y-w;                            % estimate of the clean signal

 return


