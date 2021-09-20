function [mmse,mse,f_opt,delta] = MMSE (h,hrec,snr,Lf)

% =========================================================
% function [mmse,mse,f_opt,delta] = MMSE (h,hrec,snr,Lf)
% ---------------------------------------------------------
% Find the MMSE for a specific estimated channel.
% The two channels (h,hrec) must be of the same length.
% 
% h     : the actual channel
% hrec  : the reconstructed channel
% snr   : the SNR at the equalizer input
% Lf    : length of the equalizer to use
%
% mmse  : minimum-MSE achieved over all delays
% mse   : MSE as a function of delay
% f_opt : the equalizer that achieves the mmse
% delta : the optimal delay
%
% Author: H. Pozidis,   September 23, 1998
% =========================================================

if (length(h)-length(hrec) ~= 0)
  error('The channels must be of the same length');
end

if (snr >= 0)
  snr = 10^(snr/10);
  lambda = 1/snr;
else
  lambda = 0;
end
h = h(:);
hrec = hrec(:);
H = convmtx(h,Lf);
C = convmtx(hrec,Lf);
P = size(C,1);

A = inv(C'*C + lambda*eye(Lf));
f_eq = A*C';
h_del = eye(P);

mse_mat = (h_del-H*f_eq)'*(h_del-H*f_eq) + f_eq'*f_eq*lambda;
mse = diag(mse_mat);
[mmse,delta] = min(mse);
f_opt = f_eq(:,delta);
