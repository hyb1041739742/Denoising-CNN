function [cum,mom] = moments (x,M,order)

% ======================================================
% function [cum,mom] = moments (x,M,order)
% ------------------------------------------------------
% Computes higher-order (3rd-4th) cumulants and moments
%
% x      :  the signal or portion of it
% M      :  the number of lags; the routine computes
%           a matrix of (2M-1)^2 or (2M-1)^3 moments.
% order  :  3 (3rd-order) or 4 (4th-order)
%
% cum    :  the output cumulants (BIASED)
% mom    :  the output moments (BIASED)
%
% Author: H. Pozidis,   September 23, 1998
% ======================================================

x = x(:).';                    % 1-by-N
N = length(x);
L = 2*M-1; 

X = repmat(x,L,1);             % (2*M-1)-by-N
C = [zeros(M-1,1);x(1:M).'];
R = [x(M:N) zeros(1,M-1)];
X1 = hankel(C,R);              % (2*M-1)-by-N

if (order == 2)
  
  mom = (1/N)*(X1*x(:));
  cum = mom;

elseif (order == 3)

  X2 = X1.';                   % N-by-(2*M-1)
  mom = (1/N)*(X.*X1)*X2;      % (2*M-1)-by-(2*M-1)
  cum = mom;
  clear X C R X1 X2

elseif (order == 4)

  Y = X1.';                    % N-by-(2*M-1)
  X2 = repmat(Y,1,L);          % N-by-(2*M-1)^2
  Y1 = repmat(Y,L,1);          % N*(2*M-1)-by-(2*M-1)
  X3 = reshape(Y1,N,L*L);      % N-by-(2*M-1)^2
  Z = (X.*X1)*(X2.*X3);        % (2*M-1)-by-(2*M-1)^2
  mom = (1/N)*reshape(Z,L,L,L);
  clear X Y C R X1 X2 X3 Y1 Z
  x1 = [-M+1:M-1]; x2 = x1;  x3 = x1;
  [X1,X2,X3] = meshgrid(x1,x2,x3);
  Rx = xcorr(x,conj(x),2*(M-1),'biased');
  c1 = Rx(X1+L) .* Rx(X3-X2+L);
  c2 = Rx(X2+L) .* Rx(X3-X1+L);
  c3 = Rx(X3+L) .* Rx(X2-X1+L);
  cum = mom-(c1+c2+c3); 
  clear X Y Z c1 c2 c3 Rx

end
