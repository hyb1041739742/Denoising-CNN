function ds=mrdivide(i1,i2)
% Function divides traces of seismic dataset by a constant factor
% Written by: E. R.: August 18, 2005
% Last updated:

if isstruct(i1)  &  strcmp(i1.type,'seismic')  &  isnumeric(i2)
   ds=i1;
   ds.traces=ds.traces/i2;

elseif  isstruct(i2)  &  strcmp(i2.type,'seismic')  &  isnumeric(i1)
   ds=i2;
   ds.traces=i1 ./ ds.traces;

else
   error('Operator "/" is not defined for these arguments.')
end

