function ds=sign(ds)
% Function takes the absolute value of the traces of a seismic dataset
% Written by: E. R.: September 11, 2005
% Last updated:

if isstruct(ds)  &  strcmp(ds.type,'seismic')
   ds.traces=sign(ds.traces);
else
   error('Operator "sign" is not defined for this argument.')
end

