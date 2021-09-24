function [nois, meaa, vari, skew] = exponential(lambda, sseed, nterms);

% ============================================================================
% function [nois, meaa, vari, skew] = exponential(lambda, sseed, nterms);
%
% To generate exponentially distributed noise.
% Uses matlab's rand routine.
%
% INPUTS: lambda of the exponential dist.
%         sseed = seed to initiate uniform distribution.
%                 if sseed = 0; seed is dis-enabled.
%	  nterms= howmany terms are required...
% 
% OUTPUT: exponentially distributed nois with parameter lambda.
%
% meaa=first cum.=mean = 1/lambda 
% vari=second cum.= var = 1/(lamda^2)
% skew = third cum = 2/(lambda^3); 
% NOTE : ALL ARE THEORETICAL FIGURES.... NOT FROM actual distribution... 
%
% Author: U. Abeyratne
% ============================================================================


if sseed==0
  % no seed is forced...Let Matlab take control...
else
  rand('seed',sseed);
end

nois=rand(1,nterms);
nois= -log(1-nois)/lambda;
meaa= 1/lambda; 
vari= meaa^2; 
skew = 2*meaa^3;  
