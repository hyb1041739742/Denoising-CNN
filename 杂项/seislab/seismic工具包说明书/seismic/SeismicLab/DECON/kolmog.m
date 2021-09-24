function [w_min] = kolmog(w,type_of_input,L);  
%KOLMOG: Kolmogoroff spectral factorization.
%        Given an arbitrary wavelet this function retrieves the minimum 
%        phase wavelet using Kolmogoroff factorization.
%
%  
%  [w_min] = kolmog(w,type_of_input,L)
%
%  IN   w:     a wavelet of arbitrary phase 
%              or seismic trace (column vector)
%              type_of_input = 'w': wavelet
%              type_of_input = 't': seismic trace
%              L: lenght of wavelet if type_of_input='t'
%
%  OUT  w_min: a min phase wavelet 
%
%
%  Example:
%            w = [1,2]';   
%            w_min = kolmog(w);  
% 
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%



[n1,n2]=size(w);


if n2~=1; error('Input wavelet or trace must be a column vector');end;


if isequal(type_of_input,'w')

nw = length(w);    % lenght of the wavelet
nfft = 8*( 2^nextpow2(nw));

W = log ( abs(fft(w,nfft)) +0.00001);
W = ifft(W);

for k=nfft/2+2:nfft; W(k)=0.;end;
W = 2.*W;
W(1) =W(1)/2.;

W = exp(fft(W)) ;
w_min = real(ifft(W));
w_min = w_min(1:nw); 

else;

nt = length(w);    % size of the trace

nfft = 8*( 2^nextpow2(nt));
nw = L;

A = xcorr(w,w,L);
A = A.*hamming(2*L+1);

W = log ( sqrt(abs(fft(A,nfft))) +0.00001);
W = ifft(W);

for k=nfft/2+2:nfft; W(k,1)=0.;end;
W = 2.*W;
W(1,1) =W(1,1)/2.;

W = exp(fft(W)) ;
w_min = real(ifft(W));
w_min = w_min(1:nw,1); 

w_min_max = max(abs(w_min));
w_min = w_min/w_min_max;
end;

return

