function seisout=s_convolve(seisin1,seisin2,varargin)
% Function convolves two data sets
% If one of the data sets has only one trace then it is convolved with all traces of the other data set.
% The headers of the data set with more traces are retained; If the data sets have the same number of
% traces, the headers of the first data set are retained.
%
% Written by: E. R.: April 2000
% Last updated: January 2, 2001: Return to compact header structure
%
%               seisout=s_convolve(seisin1,seisin2,varargin)
% INPUT
% seisin1     first seisnic input dataset
% seisin2     second seismic input dataset
% varargin    one or more cell arrays; the first element of each cell array is a keyword,
%             the other elements are parameters. Presently, keywords are:
%             Options not yet implemented 
% OUTPUT
% seisout     output dataset; convolution of the two input datasets

[nsamp1,ntr1]=size(seisin1.traces);
[nsamp2,ntr2]=size(seisin2.traces);

%	Set default parameters
if ntr1 >= ntr2
   param.header=1;
else
   param.header=2;
end
param.type='corresponding';

%	Replace defaults by input parameters (if there are any)
param=assign_input(param,varargin);   

seisout.first=seisin1.first+seisin2.first;
seisout.last=seisin1.last+seisin2.last;

if seisin1.step == seisin2.step
   seisout.step=seisin1.step;
else
   error([' The two input data sets have different sample intervals (', ...
         num2str(seisin1.step),' vs. ',num2str(seisin2.step),')'])
end

seisout.traces=zeros(nsamp1+nsamp2-1,max([ntr1,ntr2]));
if ntr1 == 1
   for ii=1:ntr2
      seisout.traces(:,ii)=conv(seisin1.traces,seisin2.traces(:,ii));
   end
elseif ntr2 == 1
   for ii=1:ntr1
      seisout.traces(:,ii)=conv(seisin2.traces,seisin1.traces(:,ii));
   end  
elseif ntr1 == ntr2 
   if strcmpi(param.type,'corresponding')
      for ii=1:ntr1
         seisout.traces(:,ii)=conv(seisin2.traces(:,ii),seisin1.traces(:,ii));
      end
   end
else
  error('This option has not yet been implemented')
end

%    Append history field and copy rest of fields

if param.header == 1
%       Copy rest of fields
  seisout=copy_fields(seisin1,seisout);
  if isfield(seisin1,'history') & isfield(seisin2,'history')
    seisout=s_history(seisout,'append',' ');
    seisout=s_history(seisout,'merge',seisin2.history);
  end

else
%       Copy rest of fields
  seisout=copy_fields(seisin2,seisout);
  if isfield(seisin1,'history') & isfield(seisin2,'history')
    seisout=s_history(seisout,'append',' ');
    seisout=s_history(seisout,'merge',seisin1.history);
  end

end
    

