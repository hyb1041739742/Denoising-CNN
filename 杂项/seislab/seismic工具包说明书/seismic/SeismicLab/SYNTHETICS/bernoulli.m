function r = bernoulli(N,arg);
% BERNOULLI: compute Bernoulli deviates with parameter lambda
%            and sigma 
%
%  [r] = bernoulli(N,[lambda,signa]);
%
%  IN   N:      Number of deviates
%       arg = [lambda, sigma]; where 
%             lambda: Occurrence of a non-zero sample lambda (0,1) 
%             sigma:  standard error for non-zero samples 
%
%  OUT  r(N,1): deviates
%
%  Example: This is used to simulate reflectivity
%           sequences
%
%           r = bernoulli(500,[0.8,1]); plot(r); title('Reflectivity');
%          
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2005 SeismicLab
%  Revision: 1.2  Date: Ago/2005
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA

lambda = arg(1);
sigma = arg(2);

r = zeros(N,1);
for k=1:N
if rand(1,1)>lambda; r(k,1)= sigma*randn(1,1); end
end;




