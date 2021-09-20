function [a,b]=l1_slope_intercept(x,y,alpha)
% Compute L2 approximation to slope and intercept
% y =a + b x
% With correction factor for Nsiko-well
% Written by: E. R.: August 8, 2003
% last updated:
%
%       [a,b]=l1_slope_intercept(x,y);
% INPUT
% x     abscissas
% y     ordinates
% OUTPUT
% a     intercept
% b     slope

if nargin < 3
   alpha=0.25;
end

nx=length(x);
nxh=nx/2;

ia=round(max(1,nxh*alpha));
ie=round(nxh*(1-alpha));
if ia > ie 
   error(' Parameter "alpha" must be between 0 and 0.5')
end

nxh=round(nxh);
temp=(y(end-nxh+1:end)-y(1:nxh))./(x(end-nxh+1:end)-x(1:nxh));

temp=sort(temp);
b=mean(temp(ia:ie));

temp=sort(y-b*x);
a=mean(temp(ia:ie));

