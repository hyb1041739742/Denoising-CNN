function ds=uplus(ds)
% Function takes the unitary plus of the traces of a seismic dataset
% Written by: E. R.: August 18, 2005
% Last updated:

if isstruct(ds)  &  strcmp(ds.type,'seismic')
%	do nothing
else
   error('Operator "+" is not defined for these arguments.')
end

