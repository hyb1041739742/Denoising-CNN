function seismic=s_filter(seismic,varargin)
% Function filters seismic input data
%
% Written by: E. R.: May, 2001
% Last updated: January 10, 2005: break big data sets down into smaller ones before filtering
%
%            seismic=s_filter(seismic,varargin)
% INPUT
% seismic    seismic structure
% varargin   one or more cell arrays; the first element of each cell array is a keyword,
%            the other elements are parameters. Presently, keywords are:
%        'ormsby'    Ormsby filter with corner frequencies f1,f2,f3,f4. The 
%              corner frequencies must satisfy the condition 0 <= f1 <= f2 <= f3 <= f4.
%              General form: {'ormsby',f1,f2,f3,f4}     or
%                            {'ormsby',[f1,f2,f3,f4]}
%              no default
% OUTPUT
% seismic     seismic structure after filtering

%    	Set default values
param.ormsby=[];

%   	Decode and assign input arguments
param=assign_input(param,varargin,'s_filter');

fields=fieldnames(param);
idx=ismember_ordered(fields,{'ormsby'});
if length(idx) > 0
   option=fields{idx(1)};
else
   error(' No filter type specified')
end

switch option

               case 'ormsby'

if isempty(param.ormsby)
   error(' No filter parameters specified')
end

%       Retrieve and check corner frequencies of Ormsby filter
if ~iscell(param.ormsby)
   freq=param.ormsby;
else
   freq=cell2num(param.ormsby);
end
idx=find(diff(freq) < 0);
ftext=num2str(reshape(freq,1,[]));

if ~isempty(idx)
   error([' Corner frequencies for Ormsby filter are not monotonic: ',ftext]);
end

%       Handle big data sets by dividing them in smaller chunks
ntr=size(seismic.traces,2);
if ntr > 1000
   ia=1;
   for ii=1:ceil(ntr/1000)
      ie=min(ia+999,ntr);
      seismic.traces(:,ia:ie)=ormsby_filter(seismic.traces(:,ia:ie),seismic.step,freq);
      ia=ie+1;
   end
else
   seismic.traces=ormsby_filter(seismic.traces,seismic.step,freq);
end
ftext=[' with corner frequencies ',ftext];

               otherwise
disp([' Unknown FILTER option: ',option])

end	% End of switch block


%       Append history field

htext=[option, ftext];
seismic=s_history(seismic,'append',htext);

seismic.name=['filtered ',seismic.name];

