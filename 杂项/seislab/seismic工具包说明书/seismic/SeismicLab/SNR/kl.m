function [D_out,s] = kl(D_in,P);  
%KL: Karhunen Loeve filtering of seismic data.
%    The Karhunen Loeve transform can be used to enhance
%    lateral coherence of seismic events, this transform 
%    works quite well with NMO corrected CMP gathers, or
%    common offset sections.
%
%  [D_out,s] = kl(D_in,P)
%
%  IN   D_in:  data (the data matrix)
%       P:     number of eigenvectors to used by the
%              KL filter
%
%  OUT  D_out: output data after kl filtering
%       s:     the eigen-values of the covariance
%              matrix in descending order
%
%  Example : Filter a cdp; only 5 eigenvectors
%            are kept
%
%            [D_in,H]=readsegy('cdp.linux.su');
%            [D_out,s]=kl(D_in,5); 
%            wigb(D_out);
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

[nt,nh]=size(D_in);

D_out=zeros(nt,nh);

R = D_in'*D_in;         % Data covariance 

[U,S]=eigs(R,P);        % Eigen-decomposition of R

U=U(:,1:P);             

D_out=(U*U'*D_in')';

s = diag(S);           
                        
return


