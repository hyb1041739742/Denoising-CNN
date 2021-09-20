function A = hos_matrix(N,r)

% ===================================================
% function A = hos_matrix(N,r)
%
% N  :  the FFT size
% r  :  the distance between the polyspectrum slices
%
% Author: H. Pozidis,   September 23, 1998
% ===================================================

A=diag(ones(N-r,1),r-1)+diag((-1)*ones(N-2,1),-1);
b=diag(ones(r-2,1),r-N-1);

if (nnz(b) > 0)
  A = A+b;
end
