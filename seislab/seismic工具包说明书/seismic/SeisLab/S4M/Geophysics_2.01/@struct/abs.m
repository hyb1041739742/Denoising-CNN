function ds=abs(ds)
% Function takes the absolute value of the traces of a seismic dataset
% Written by: E. R.: August 18, 2005
% Last updated:

if isstruct(ds)  &  strcmp(ds.type,'seismic')
   ds.traces=abs(ds.traces);
else
   error('Operator "abs" is not defined for this argument.')
end

