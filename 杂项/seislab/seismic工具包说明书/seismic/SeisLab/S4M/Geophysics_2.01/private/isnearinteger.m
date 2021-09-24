function logical=isnearinteger(x,epsilon)
% Function checks if x is approximately integer
%
%          logical=isnearinteger(x,epsilon)
% INPUT
% x        variable to check
% epsilon  maximum deviation from integer; 
%          default 0
% OUTPUT
% logical logical variable (1  if abs(x-round(x)) <= epsilon, 
%                           0  otherwise)

if nargin == 1
  epsilon=0;
end
logical=abs(x-round(x)) <= epsilon;

