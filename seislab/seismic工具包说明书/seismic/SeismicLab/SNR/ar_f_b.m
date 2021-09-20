function [D_pred] = ar_f_b(D_in,lf,mu,type)
%AR_F_B: 1D Forward and Backward Prediction filter.
%        (called by fx_deconv.m)
%        
%  [D_pred] = ar_f_b(D_in,lf,mu,type)
% 
%  IN     D_in:   input data in a colunm vector
%         lf:     lenght of the ar process 
%         mu:     pre-whitening in %
%         type:   type=1 forward prediction 
%                 type=-1 backward prediction
%       
%  OUT    D_pred: the predicted TS 
%
%  NOTE: This is also the basis for AR model fitting and
%        and AR parametric spectral analysis
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA


% Forward prediction 
        
if type==1;
n = length(D_in);
C = convmtx(D_in,lf);
d = zeros(n+lf-1,1); d(1:n-1,1) = D_in(2:n);  
f = (C'*C+mu*eye(lf))\C'*d; 
aux = C*f;
D_pred(1,1) = 0;
D_pred(2:n,1) =aux(1:n-1); 
end

% Backward prediction 

if type==-1;
n = length(D_in);
C = fliplr(convmtx(D_in,lf));
d = zeros(n+lf-1,1); d(lf+1:n+lf-1,1) = D_in(1:n-1);  
f = (C'*C+mu*eye(lf))\C'*d; 
aux = C*f;
D_pred(n,1) = 0;
D_pred(1:n-1,1) =aux(lf+1:lf+n-1); 
end;

return
