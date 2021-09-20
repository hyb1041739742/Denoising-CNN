function description=l_gd(wlog,mnem)
% Function extracts description of curve with mnmeonic "mnem" from log data set "wlog"
% If global variable CASE_SENSITIVE is set to false, the case of the curve
% mnemonic is disregarded
% Written by: E. R., December 30, 2000
% Last updated: June 10, 2001: semantic changes
%
%             units=l_gd(wlog,mnem);
% INPUT
% wlog        log data set
% mnem        curve mnemonic
% OUTPUT
% description string with description of curve with mnmonic "mnem"

global CASE_SENSITIVE

mnems=wlog.curve_info(:,1);
if CASE_SENSITIVE
   idx=find(ismember(mnems,mnem));
else
   idx=find(ismember(lower(mnems),lower(mnem)));
end
if ~isempty(idx) & length(idx) == 1
   description=wlog.curve_info{idx,3};
   return
end

% Handle error condition
if isempty(idx)
  disp([' Curve "',mnem,'" not found. Available curves are:'])
  disp(mnems')
else
  disp([' More than one curve found: ',cell2str(mnems(idx),', ')])
end

error(' Abnormal termination')

