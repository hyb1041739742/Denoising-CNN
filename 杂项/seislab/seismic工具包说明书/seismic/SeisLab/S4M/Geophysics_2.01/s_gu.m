function units=s_gu(seismic,mnem)
% Function gets units of header with mnmeonic "mnem" from seismic data set "seismic"
% If global variable CASE_SENSITIVE is set to false, the case of the header mnemonic
% is disregarded
% Written by: E. R., December 30, 2000
% Last updated: December 30, 2000; compact header representation
%
%            units=s_gu(seismic,mnem)
% INPUT
% seismic    seismic data set
% mnem       header mnemonic
% OUTPUT
% units      string with units of measurements of header with mnemonic "mnem"

global CASE_SENSITIVE

if strcmpi(mnem,'trace_no')       % Implied header "trace_no"
  units='n/a';
  return
end

mnems=seismic.header_info(:,1);

if CASE_SENSITIVE
   idx=find(ismember(mnems,mnem));
else 
   idx=find(ismember(lower(mnems),lower(mnem)));
end

if ~isempty(idx) & length(idx) == 1
   units=seismic.header_info{idx,2};
   return
end

% Handle error condition
if isempty(idx)
  disp([' Header "',mnem,'" not found. Available headers are:'])
  disp(mnems')
else
  disp([' More than one header found: ',cell2str(mnems(idx),', ')])
end

error(' Abnormal termination')

