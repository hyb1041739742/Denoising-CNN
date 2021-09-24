function bool=isnumber(str)
% Check if a string contains only numbers, spaces, commas, decimal points,
% semicolons, +/- signs
%
% Written by: E. R.: August 16, 2003
% Last updated: 
%
%       bool=isnumber(str)
% INPUT
% str   string to be checked
% OUTPUT
% bool  logical variable; bool is set to logical(0) if it contains characters 
%       other than those listed above or if the string has length 0
%       bool=logical(1) otherwise

if isempty(str)
   bool=logical(0);
else
   bool=all(ismember(double(str),double('1234567890,.; +-')));
end

