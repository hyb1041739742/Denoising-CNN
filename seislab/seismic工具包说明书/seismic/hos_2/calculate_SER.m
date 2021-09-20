function [uest,mmse,symb,err,SER] = calculate_SER (fl,dim,real_h,hrec,snr,Lf,ni)

% =============================================================================
% function [uest,mmse,symb,err,SER] = calculate_SER (fl,dim,real_h,hrec,snr,Lf,ni)
%
% dim    =  the QAM dimension (4,16,64,...) (fl = 'q')
%           or PAM dimension (2,4,8,...)    (fl = 'p')
% real_h =  the actual channel
% hrec   =  the estimated channel
% snr    =  the SNR at the receiver input
% Lf     =  the equalizer filter length
% ni     =  for the random number generator
%
% uest   =  the estimated source symbols
% mmse   =  the output mean-square-error (optimized over system delay)
% symb   =  the slicer's decision
% err    =  the error between source symbols and slicer decisions
% SER    =  the Symbol-Error-Rate
%
% Author: H. Pozidis,   September 23, 1998
% =============================================================================

L = 1000;  d = sqrt(dim);
for k=1:50
  see(k,1)=sum(clock)*1e6; see(k,2)=sum(clock)*1e6;
  gaus(k,1)=sum(clock)*1e6; gaus(k,2)=sum(clock)*1e6;
  gaus(k,3)=sum(clock)*1e6; gaus(k,4)=sum(clock)*1e6;
end
[y,x,w,u]=arma_gen(fl,dim,L,real_h,1,snr,1,1,see(ni,:),gaus(ni,1),gaus(ni,2));

[mmse,mse,f_opt,delta] = MMSE_bse (real_h,hrec,snr,Lf);

uest = conv(y,f_opt);
if (delta <= Lf)
  uest = uest(delta:delta+L-1);
else
  uest = uest(delta:length(uest));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (fl == 'p')
  alphabet=-(dim-1):2:(dim-1);                % values for PAM letters
  cons=alphabet/sqrt(mean(abs(alphabet).^2));
elseif (fl == 'q')
  alphabet = -(d-1):2:(d-1);                  % values for PAM letters
  [X,Y] = meshgrid(alphabet,alphabet);
  cons = X + Y*j;
  cons = cons(:);
  cons = cons/sqrt(mean(abs(cons).^2));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ue = uest(:)*ones(1,length(cons));
CONS = ones(length(ue),1)*cons(:).';
eucl = abs(ue-CONS);
[dist,alpha] = min(eucl');

symb = cons(alpha);
u = u(1:length(uest));
err = u(:) - symb(:);

SER = nnz(err)/length(err);
disp([mmse SER]);

%figure(1);plot(y,'*');axis('square');
%figure(2);plot(uest,'*');axis('square');
