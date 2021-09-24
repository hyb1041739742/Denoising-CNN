function seisout=s_resample(seisin,sample_interval,varargin)
% Function resamples seismic data to new sample interval. If the new sample interval
% is greater than the old sample interval and interpolation is done in the time domain
% an Ormsby filter with corner frequencies 0,0,0.8*fnyquist,fnyquist is applied 
% to the data prior to resampling. 
% "fnyquist" is the Nyquist frequency associated with the new sample interval.
% Written by E. R., April 14, 2000
% Last update: January 1, 2005: remove trace nulls prior to interpolation
%
%                 seisout=s_resample(seisin,sample_interval,varargin)
% INPUT
% seisin      seismic structure
% sample_interval new sample interval (can be larger or smaller than seisin.step);
% varargin    one or more cell arrays; the first element of each cell array is a keyword,
%             the other elements are parameters. Presently, keywords are:
%        'option'   parameter which specifies the kind of interpolation. Possible values are:
%             'standard' Staightforward interpolation. Frequency-domain antialias filter.
%                        if sample_interval > seisin.step.
%             'smooth'   Staightforward interpolation. Time domain smoothing if 
%                        sample_interval > seisin.step
%             'wavelet'  Interpolation intended for wavelets. This interpolation includes  
%                        the sample prior to the first and the one after the last in the 
%                        interpolation, assuming they are zero.
%              Default: {'option','standard'}
%        'domain'   parameter specifies it interpolation is to be done in the frequency 
%                   domain ('frequency') or in the time domain ('time').
%              Default: {'domain','time')  if the new sample interval is an integer 
%                       multiple of the old sample interval or vice versa; otherwise
%                       {'domain','time')
%        'filter'   parameter specifies if band-pass filter is to be applied 
%                   (to the input data  if seisin.step < sample_interval (anti-alias)  
%                    to the output data if seisin.step > sample_interval)
%              Default: {'filter','yes'}
% OUTPUT
% seisout     seismic structure after resampling

global S4M

%       Do nothing if sample interval is not changed
if seisin.step == sample_interval
   seisout=seisin;
   return
end

if seisin.step > sample_interval
   frac=seisin.step/sample_interval;
else
   frac=sample_interval/seisin.step;
end

%       Set default values
resample.filter='yes';
if abs(round(frac)-frac) < 1.0e6*eps
%   resample.domain='frequency';
   resample.domain='time';
else
   resample.domain='time';
end
resample.option='standard';

%       Decode input arguments
resample=assign_input(resample,varargin);

ntr=size(seisin.traces,2);

%	Remove trace nulls
seisin=s_rm_trace_nulls(seisin);


switch resample.option

               case 'standard'

seisout.first=ceil(seisin.first/sample_interval)*sample_interval;
new_times=(seisout.first:sample_interval:seisin.last)';
seisout.last=new_times(end);
seisout.step=sample_interval;
nsampout=length(new_times);

if isfield(seisin,'null') & isnan(seisin.null)
   error(' Handling of null values not yet implemented')
end  

if seisin.step > sample_interval
  seisout.traces=interpolate(seisin.first:seisin.step:seisin.last,seisin.traces,new_times, ...
          resample.domain,resample.filter);
%  if strcmpi(resample.filter,'yes')
%    fnyquist=500/seisin.step;
%    seisout.traces=ormsby(seisout.traces,seisout.step,0,0,fnyquist,1.2*fnyquist);
%  end
else
%  if strcmpi(resample.filter,'yes')
%    fnyquist=500/sample_interval;
%    temp=ormsby(seisin.traces,seisin.step,0,0,0.8*fnyquist,fnyquist);
%    seisout.traces=interpolate(seisin.first:seisin.step:seisin.last,temp,new_times,resample.domain);
%  else
  seisout.traces=interpolate(seisin.first:seisin.step:seisin.last,seisin.traces,new_times, ...
          resample.domain,resample.filter);
end

               case 'smooth'

seisout.first=ceil(seisin.first/sample_interval)*sample_interval;
new_times=(seisout.first:sample_interval:seisin.last)';
seisout.last=new_times(end);
seisout.step=sample_interval;

if isfield(seisin,'null') & isnan(seisin.null)
   error(' Handling of null values not yet implemented')
end  

if seisin.step > sample_interval
   seisout.traces=interp1(seisin.first:seisin.step:seisin.last,seisin.traces,new_times,resample.domain);
else
   ratio=sample_interval/seisin.step;
   for ii=1:ntr
      temp=seisin.traces(:,ii);
      idx=find(~isnan(temp));
      temp(idx)=smooth(temp(idx),ratio);
      seisout.traces(:,ii)=interpolate(seisin.first:seisin.step:seisin.last,temp,new_times, ...
             resample.domain,resample.filter);
   end
end
nsampout=size(seisout.traces,2);

              case 'wavelet'
seisout.first=ceil((seisin.first-seisin.step)/sample_interval)*sample_interval;
new_times=(seisout.first:sample_interval:seisin.last+seisin.step)';
seisout.last=new_times(end);
seisout.step=sample_interval;
nsampout=length(new_times);
if seisin.step > sample_interval
   seisout.traces=interpolate((seisin.first-seisin.step:seisin.step:seisin.last+seisin.step)', ...
      [zeros(1,ntr);seisin.traces;zeros(1,ntr)],new_times,resample.domain,resample.filter);
else
   fnyquist=500/sample_interval;
   temp=ormsby([zeros(1,ntr);seisin.traces;zeros(1,ntr)],seisin.step,0,0,0.8*fnyquist,fnyquist);
   seisout.traces=interpolate((seisin.first-seisin.step:seisin.step:seisin.last+seisin.step)', ...
       temp,new_times,resample.domain,resample.filter);
   idx=sum(isnan(seisout.traces));
   if idx > 0
      seisout.traces=NaN;
      temp=S4M.history;            
      S4M.history=0;        % Make no entry in "history" field
      seisout=s_rm_trace_nulls(seisout);
      S4M.history=temp;
   end
end

            case 'otherwise'
error([' Unknown RESAMPLE option "',resample.option,'"'])

end         % End of switch block

%       Copy all other fields to output data set
seisout=copy_fields(seisin,seisout);

%       Compatibility test (for frequency-domain interpolation)
if strcmpi(resample.domain,'frequency')
   if size(seisout.traces,1) ~= nsampout
      seisout.traces=seisout.traces(1:nsampout,:);
   end
end

%       Check for NaNs
idx=find(isnan(seisout.traces));
if ~isempty(idx)
   seisout.null=NaN;
end

%    Append history field
if isfield(seisin,'history') & S4M.history
   htext=['to ',num2str(sample_interval),' ',seisin.units, ...
         ' (',resample.option,', ',resample.domain,' domain)'];
   seisout=s_history(seisout,'append',htext);
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ynew=interpolate(xold,yold,xnew,type,filter)
% Function performs interpolation in time or frequency domain, 
% assumes "xold" and "xnew" are uniform
% "type" is either 'time' or 'frequency';
% "filter" is either 'yes' or 'no' (only used if "type" is 'time')

%dxold=xold(2)-xold(1);
%dxnew=xnew(2)-xnew(1);

dxold=mean(diff(xold));
dxnew=mean(diff(xnew));

if strcmpi(type,'time')
  
   if (dxold < dxnew) & strcmpi(filter,'yes')
      fnyquist=500/dxnew;
      yold=ormsby(yold,dxold,0,0,0.8*fnyquist,fnyquist);
   end
   ynew=interp1(xold,yold,xnew,'*cubic');
   if (dxold > dxnew) & strcmpi(filter,'yes')
      fnyquist=500/dxold;
      ynew=ormsby(ynew,dxold,0,0,fnyquist,1.2*fnyquist);
   end

elseif strcmpi(type,'frequency')
 
  if dxnew > dxold
     [nsamp,ntr]=size(yold);
     ratio=round(dxnew/dxold);
     lold=ratio*length(xnew);
     if lold > nsamp
        yold=[yold;zeros(lold-length(xold),ntr)];
     end
  end
 
  ynew=interpf(yold,dxold,dxnew);

else
   error([' Unknown domain for resampling: ',type'])
end

