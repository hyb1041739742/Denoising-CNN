function [x] = laplace(N,lambda);
%LAPLACE: compute laplace deviates with parameter lambda
%         f(x) = 1/2/lambda * e{-{x}/lambda}...
%
%  [x] = laplace(N,lambda);
%
%  IN   N:      Number of deviates
%       lambda: Laplace parameter
%
%  OUT  x(N,1): deviates
%
%           r = bernoulli(500,0.8,1); plot(r); title('Reflectivity');
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2005 SeismicLab
%  Revision: 1.2  Date: Ago/2005
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA


 y = rand(N,1);

 for k=1:N;
   if y(k)<=0.5; x(k)= lambda*log(2*y(k)     );    else
                 x(k)=-lambda*log(2*(1-y(k)));
  end;
 end;

 return;
