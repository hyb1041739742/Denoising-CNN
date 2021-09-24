function [f,o] = ls_inv_filter(w,NF,Lag,mu);  
%LS_INV_FILTER: Given a wavelet compute the LS inverse filter.
%
%  [f,o] = LS_INV_FILTER(w,NF,Lag,mu)
%
%  IN   w:   the wavelet
%       NF:  lenght of the inverse filter
%       Lag: the position of the spike in the desired output     
%            Lag=1 for minimum phase wavelets 
%       mu:  prewhitening     
%
%  OUT  f:   the filter
%       o:   the ouput or convolution of the filter with 
%            the wavelet 
%
%  Example:
%           w = [2,1];                            % the wavelet
%           [f,o] =  ls_inv_filter(w,20,1,2);     % the filter and the output
%           figure(1); plot(f);title('Filter')     
%           figure(2); plot(o);title('Wavelet * Filter')
%
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%
%

NW = length(w);              % lenght of the wavelet

NO = NW+NF-1;                % Leght of the output      

[mc,mr]=size(w);
if mc <= mr; w = w'; end;

b = [zeros(1,NO)]';          % Desire output 
b(Lag,1) = 1.;               % Position of the spike

C = convmtx(w,NF);           % Convolution matrix 
 
R = C'*C+mu*eye(NF)/100.;    %  Toeplitz Matrix
rhs = C'*b;                  %  Right hand side vector 
f = R\rhs;                   %  Filter 

if nargout == 2
o = conv(f,w);               %  Actual output
end

return

