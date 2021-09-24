function [z] = zeros_wav(w);
%ZEROS_WAV: computes the zeros of the Z-transform of a wavelet.
%
%  [z] = zeros(w);
%
%  IN   w: a wavelet;
%
%  OUT  z: complex zeros
%
%  Example:  
%            w = [2 1 2 2.3 3 -10,1]; 
%            z = zeros_wav(w);
%            polar_plot(z); 
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

[N,M] = size(w);
if N == 1; wr = fliplr(w); z = roots(wr); end;
if M == 1; wr = flipud(w); z = roots(wr); end;
 
return

