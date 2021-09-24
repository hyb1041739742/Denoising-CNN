function b=modulo(a,N)

% ----------------------------------------------
% function b=modulo(a,N)
%
% Author: H. Pozidis,   September 23, 1998
% ----------------------------------------------

b=rem(a,N);
b(b<0)=b(b<0)+N;
