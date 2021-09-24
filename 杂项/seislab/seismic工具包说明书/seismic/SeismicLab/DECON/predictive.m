function [f,o] = predictive(w,NF,L,mu);  
%PREDICTIVE: Predictive deconvolution filter.
%
%  [f,o] = predictive(w,NF,L,mu)
%
%  IN   w:  the wavelet or input trace 
%       NF: lenght of the inverse filter
%       L:  Prediction distance
%       mu: Prewhitening in %    
%
%  OUT  f:  the filter
%       o:  the ouput or convolution of the filter with 
%           the wavelet or trace 
%
%  Example:
%
%  w = kolmog(ricker(0.004,25));                               % A min phase wavelet;
%  a = 0.4;
%  x = conv(w,[a;zeros(20,1);-a^2;zeros(20,1);a^3]);           % Wavelet with reverberation...
%  [f,o] =  predictive(x,50,15,0.1);                           % the filter and the output
%  figure(1); subplot(221); plot(x);title('data');
%             subplot(222); plot(o);title('data* Filter')
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

NW = max(size(w));    % Lenght of the wavelet

NO = NW+NF-1;         % Leght of the output      

[mc,mr]=size(w);
if mc <= mr; w = w'; end;

b = zeros(NO,1);
b = [w(L+1:NW)',zeros(1,NO-NW+L)]';

C = convmtx(w,NF);           % Convolution matrix 
 
R = C'*C+mu*eye(NF)/100.;    %  Toeplitz Matrix
rhs = C'*b;                  %  Right hand side vector 
f = R\rhs;                   %  Filter 

if nargout == 2
if L==1; f = [1,-f']'; else
f = [1,zeros(1,L-1),-f']';
end;

o = conv(f,w);               %  Actual output
end

return

