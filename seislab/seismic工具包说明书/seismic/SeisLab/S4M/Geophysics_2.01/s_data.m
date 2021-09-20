function seismic=s_data
% Generate test data set consisting of 12 traces of filteres random Gaussian
% noise (1000 ms long, 4 ms sample interval)
% Written by: E. R.: August 27, 2003
% Last updated: September 24, 2004: set field "name".
%
%            seismic=s_data

global S4M

if isempty(S4M)
   presets
   S4M.script='';
end

randn('state',99999)
seismic=s_convert(randn(251,12),0,4);
seismic.name='Test data';
seismic=s_filter(seismic,{'ormsby',10,15,30,60});
seismic=s_header(seismic,'add','CDP',101:100+size(seismic.traces,2),'n/a','CDP number');

