function seismic=s_rm_trace_nulls(seismic,option)
% Function removes NaNs at the beginning and end that are common to all traces and replaces
% any other NaNs with zeros
% No action is taken if the field 'null' does not exist in the seismic data set
% Written by: E. R., July 12, 2000
% Updated May 9, 2005: add input parameter "option"
%
%            seismic=s_rm_trace_nulls(seismic,option)
% INPUT
% seismic    seismic data set
% option     logical variable; optionally replace all other NaN's by zeros
%            if option == 1;
%            Default: option=1
% OUTPUT
% seismic    seismic after NaN removal
%
% SEE ALSO:

global ABORTED S4M  

if nargin == 1
   option=logical(1);
end

if isfield(seismic,'null')
  nsamp=size(seismic.traces,1);
  seismic=rmfield(seismic,'null');
  test=max(seismic.traces,[],2);
  index=find(~isnan(test));
  if isempty(index) 
     if S4M.interactive
        disp(' Seismic traces have only null values.')
        msgdlg('Seismic traces have only null values.')
	ABORTED=logical(0);
	return
     else
        error(' Seismic traces have only null values')
     end
  end
  seismic.traces=seismic.traces(index(1):index(end),:);
  seismic.first=seismic.first+(index(1)-1)*seismic.step;
  seismic.last=seismic.last-(nsamp-index(end))*seismic.step;
  if option
%     index=find(isnan(seismic.traces));
     seismic.traces(isnan(seismic.traces))=0;
  end

  if isfield(seismic,'history') & S4M.history
    seismic=s_history(seismic,'append', ...
           [num2str(nsamp-size(seismic.traces,1)),' samples removed']);
  end
end



