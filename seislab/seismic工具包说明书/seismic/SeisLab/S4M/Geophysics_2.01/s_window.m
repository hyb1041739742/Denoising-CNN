function seismic=s_window(seismic,window)
% Function applies window to seismic traces.
% Written by: E. R.: March 21, 2004
% Last updated:
%
%           seismic=s_window(seismic,window)
% INPUT
% seismic   seismic data set
% window    string specifying the type of window
%           Possible windows are (not case-sensitive):
%           'Hamming', 'Hanning', 'Nuttall',  'Papoulis', 'Harris',
% 	    'Rect',    'Triang',  'Bartlett', 'BartHann', 'Blackman'
% 	    'Gauss',   'Parzen',  'Kaiser',   'Dolph',    'Hanna'.
% 	    'Nutbess', 'spline','none'
% OUTPUT
% seismic   input data set with window applied to each trace

global S4M

[nsamp,ntr]=size(seismic.traces);

wndws={'Hamming', 'Hanning', 'Nuttall',  'Papoulis', 'Harris', ...
       'Rect',    'Triang',  'Bartlett', 'BartHann', 'Blackman', ...
       'Gauss',   'Parzen',  'Kaiser',   'Dolph',    'Hanna', ...
       'Nutbess', 'spline'};

idx=find(ismember(lower(window),lower(wndws)));

if ~isempty(idx)
   wndw=mywindow(nsamp,wndws{idx});
else
  disp([' Unknown window type: ',window])
  disp(' Possible types are:')
  disp(cell2str(wndws,','));
  error('Abnormal termination')
end

for ii=1:ntr
   seismic.traces(:,ii)=seismic.traces(:,ii).*wndw;
end

%    Append history field
if S4M.history & isfield(seismic,'history')
   htext=[typ,' applied to seismic'];
   seismic=s_history(seismic,'append',htext);
end


