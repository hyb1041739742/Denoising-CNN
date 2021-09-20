function [x] = laplace_mixture(N,arg);
%LAPLACE_MIXTURE: compute deviates distributed according to
%                 a Laplace mixture
%
%  [x] = laplace_mixture(N,arg);
%
%  IN   N:        Number of deviates
%       arg = [lambda1,lambda2,p] where 
%          lambda1:  Laplace paramater of first distribution
%          lambda2:  Laplace paramater of the second distribution
%          p:        Mixing paramter (0,1)
%
%  OUT  x(N,1): deviates
%
%  Example: This is used to simulate reflectivity sequences 
%
%           Use lambda1, lambda2, and p according to Walden and Hosken
%           or Martinez (MSc, 2002, UofA, page 22)
%
%           lambda1 = 0.007; lambda2 = 0.017; p = 0.24; 
%           r = laplace_mixture(500, [lambda1, lambda2, p]);
%           plot(r); title('Reflectivity');
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2005 SeismicLab
%  Revision: 1.2  Date: Ago/2005
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 lambda1 = arg(1);
 lambda2 = arg(2);
 p = arg(3);

 x1 = laplace(N,lambda1);
 x2 = laplace(N,lambda2);

 x = zeros(N,1);
for k=1:N
  if  p>rand(1,1); x(k,1) = x1(k);
         else;
                   x(k,1) = x2(k);
   end
end

%expected_var = (p)*2*lambda1^2 + (1.-p)*2*lambda2^2
%var(x) 

return


