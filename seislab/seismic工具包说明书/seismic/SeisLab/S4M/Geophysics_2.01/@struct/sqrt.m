function ds=sqrt(ds)
% Function takes the square root of the traces of a seismic dataset
% Written by: E. R.: September 12, 2005
% Last updated:

if isstruct(ds)  &  strcmp(ds.type,'seismic')
   ds.traces=sqrt(ds.traces);
else
   error('Operator "SQRT" is not defined for this argument.')
end

