function ds=power(ds,a)
% Function takes the power of the traces of a seismic dataset
% Written by: E. R.: September 11, 2005
% Last updated:

if isstruct(ds)  &  strcmp(ds.type,'seismic')  &  isnumeric(a)
   ds.traces=ds.traces.^a;
else
   error('Operator ".^" is not defined for these arguments.')
end

