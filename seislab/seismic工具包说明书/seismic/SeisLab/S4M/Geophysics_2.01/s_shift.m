function seisout=s_shift(seisin,varargin)
% Function applies user-specified time shifts to seismic traces
% Written by: E. R.: July 2001
% Last updated: August 22, 2005: Handle null values in shift header;
%                                associated traces are set to NaN
%
%             seisout=s_shift(seisin,varargin)
%INPUT
% seisin    seismic structure
% varargin  allows four cell arrays with the following keywords in the first 
%      'shifts'  the second cell is either a constant time shift applied to 
%                all traces, cell an array with a shift for each trace of 
%                "seisin", or a header mnemonic.
%                Shifts are rounded to the nearest integer multiples of the  
%                sample interval "seisin.step"
%      'header'  header mnemonic to be used if shifts should be put into header (if they
%                are not already there). It must not yet exist in the input data set.
%                Default: {'header',[]}; i.e. not used                
%      'interpol'  interpolate trace values if the shifts are not integer
%                multiples of the sample interval; default is 'no' (shifts are 
%                rounded to the nearest multiple of the sample interval.
%      'scale'   factor to apply to the shifts before they are applied to 
%                the traces this is generally meant for shifts stored in a 
%                header (e.g. multiplication by -1).
%      'option'  this keyword determines what should be done with data that 
%                are shifted outside the time range of seisin. Options are:
%                'extend'   extend the time range to accomodate all shifts. It means that
%                           seisout.first=seisin.first+min(shifts)
%                           seisout.last=seisin.last+max(shifts)                          
%                'truncate' trace values that fall outside the time range of seisin are 
%                           discarded  
%                'circular' a circular time shift is applied.
%                Default: {option','extend'}
%      'null'    value to use for samples that have been shifted into the time range of
%                "seisout". This will happen whenever different traces are shifted by 
%                different amounts AND 'type' is not 'circular'. 
%                Default: {'null',0}.
%                If seisin has no null field and null=0, then a seisout will have no null
%                field either.
% OUTPUT                          
% seisout        seismic structure with shifts applied                  

param.shifts=0;
param.header=[];
param.interpol='no';
param.scale=1;
param.option='extend';
param.null=0;

%       Check input arguments
param=assign_input(param,varargin);
if ~strcmp(param.interpol,'no')
   alert(' Interpolation not yet implemented; rounded instead')
end

[nsamp,ntr]=size(seisin.traces);

if ~ischar(param.shifts)
  if iscell(param.shifts)
    error(' Cell array with keyword "shifts" can have only two elements (including ''shifts'')')
  end
  nsh=length(param.shifts);
  if nsh == 1
    seisout=seisin;
    shifts=round(param.shifts/seisin.step)*seisin.step;
    seisout.first=seisout.first+shifts;
    seisout.last=seisout.last+shifts;

%    Append history field
    if isfield(seisin,'history')
      htext=['Shift: ',num2str(shifts)];
      seisout=s_history(seisout,'append',htext);
    end 
    return

  elseif nsh ~= ntr
    error([' Number of shifts (',num2str(nsh), ...
           ') differs from number of traces (',num2str(ntr),')']) 
  end

  shifts=round(param.shifts/seisin.step);

else         % Get shifts from headers
   idx=find(ismember(seisin.header_info(:,1),param.shifts));
   if isempty(idx)
      error([' Header "',param.shifts,'" does not exist in seismic data set'])
   end
   shifts=(seisin.headers(idx,:)/seisin.step);
   shifts=round(shifts);
end

%	Apply scale factor
shifts=param.scale*shifts;

%    Apply shifts
shmin=min(shifts);
shmax=max(shifts);
null=0;

switch param.option

               case 'extend'
seisout.first=seisin.first+shmin*seisin.step;
seisout.last=seisin.last+shmax*seisin.step;
if shmin == shmax
   seisout.traces=seisin.traces;
else
   nsampn=nsamp+(shmax-shmin);
   if param.null == 0
      seisout.traces=zeros(nsampn,ntr);
   else
%    seisout.traces=param.null*ones(nsampn,ntr);
     seisout.traces=repmat(param.null,nsamp,ntr);
     seisout.null=param.null;
   end
 
   idx=1:nsamp;
   for ii=1:ntr
      if isnan(shifts(ii))
         seisout.traces(:,ii)=NaN*seisout.traces(:,ii);
         null=NaN;
      else
         idxi=idx-shmin+round(shifts(ii));
         seisout.traces(idxi,ii)=seisin.traces(:,ii);
      end
   end   
end

             case 'truncate'
if param.null == 0
  seisout.traces=zeros(nsamp,ntr);
else
  seisout.traces=param.null*ones(nsamp,ntr);
  seisout.null=param.null;
end
seisout.first=seisin.first;
seisout.step=seisin.step;
seisout.last=seisin.last;

for ii=1:ntr
  if shifts(ii) >=0
    seisout.traces(shifts(ii)+1:nsamp,ii)=seisin.traces(1:nsamp-shifts(ii),ii);
  else
    seisout.traces(1:nsamp+shifts(ii),ii)=seisin.traces(-shifts(ii)+1:nsamp,ii);
  end
end

             case 'circular'
seisout.traces=zeros(nsamp,ntr);
seisout.first=seisin.first;
seisout.step=seisin.step;
seisout.last=seisin.last;

for ii=1:ntr
   if shifts(ii) >=0
      seisout.traces(shifts(ii)+1:nsamp,ii)=seisin.traces(1:nsamp-shifts(ii),ii);
      seisout.traces(1:shifts(ii),ii)=seisin.traces(nsamp-shifts(ii)+1:nsamp,ii);
   else
      seisout.traces(1:nsamp+shifts(ii),ii)=seisin.traces(-shifts(ii)+1:nsamp,ii);
      seisout.traces(nsamp+shifts(ii)+1:nsamp,ii)=seisin.traces(1:-shifts(ii),ii);
  end
end

             otherwise
error(['Option ',param.option,' not defined'])

end		% End of switch block


%       Copy rest of fields
seisout=copy_fields(seisin,seisout);

%	Add header (if requested)
if ~isempty(param.header)
  seisout=s_header(seisout,'add',param.header,shifts,seisout.units,'Shifts applied');
end

if isnan(null)
   seisout.null=NaN;
end

%    Append history field
if isfield(seisin,'history')
  htext=[param.option,': Minimum shift: ',num2str(seisin.step*shmin), ...
                   ', maximum shift: ',num2str(seisin.step*shmax)];
  seisout=s_history(seisout,'append',htext);
end 
 


