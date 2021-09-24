function seismic=s_wavelet_from_landmark(filename)
% Read seismic data in Jason format from file 
% Written by: E. R.: May 11, 2004
% Last updated: 
%
%           [seismic,header]=s_wavelet_from_jason(filename)
% INPUT
% filename  file name (optional)
%           the filename and the directory are saved in global variable S4M
% OUTPUT
% seismic   seismic data set read in


global S4M

if nargin == 0
   cols=rd_columns('',1,1);
else
   cols=rd_columns(filename,1,1);
end

history=S4M.history;
S4M.history=0;
seismic=s_convert(cols(4:end),-cols(2)*cols(3),cols(3));
S4M.history=history;
seismic=s_history(seismic,'add',fullfile(S4M.pathname,S4M.filename));
[dummy,name]=fileparts(S4M.filename);
seismic.name=name;
seismic.tag='wavelet';

