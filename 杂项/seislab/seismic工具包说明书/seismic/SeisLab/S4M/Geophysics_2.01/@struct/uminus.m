function ds=uminus(ds)
% Function takes the unitary minus of the traces of a seismic dataset
% Written by: E. R.: August 18, 2005
% Last updated:

if isstruct(ds)  &  strcmp(ds.type,'seismic')
   ds.traces=-ds.traces;
else
   error('Operator "-" is not defined for these arguments.')
end

