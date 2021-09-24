function table=s_ispectrum(seismic,varargin)
% Function computes the spectra of seismic data in interactively selected windows.
% Null values in the input data set are replaced by zeros.
%
% Written by: E. R.: January 1, 2001
% Last updated: April 15, 2004: default taper set to rectangle
% 
%                   s_ispectrum{seismic,varargin}
% INPUT
% seismic     seismic data set
% varargin    one or more cell arrays; the first element of each cell array is a keyword,
%             the other elements are parameters. Presently, keywords are:
%        'annotation'  Header mnemonic used to annotate the horizontal axis
%                     Default: {'annotation','trace_no'}
%        'average'    Average spectra of multi-trace data sets. 
%                     Possible values: 'yes', 'no'; Default: {'average','yes'}
%        'colors'     Colors to be used for consecutive curves.
%                     Possible values: any permissible colors and line styles
%                     Default: {'colors','r','g','b','m','k','c','y',...
%                               'r--','g--','b--','m--','k--','c--','y--' ...
%                               'r:','g:','b:','m:','k:','c:','y:'};
%        'frequencies'  Two positive numbers representing the range of frequencies to 
%                     display. The first number must be non-negative and smaller than 
%                     the second. If the second number is greater than the Nyquist 
%                     frequency of the data set with the smallest sample interval, it 
%                     is set to the Nyquist frequency.
%                     Default: {'frequencies',0,inf}
%        'legend'     Figure legend (curve annotation).
%                     Default: names of the seismic input data sets.
%        'lloc'       Location of figure legend. Possible values are 1,2,3,4,5;
%                     Default: {'loc',5}
%        'linewidth'  Line width of curves. Default: {'linewidth',2}           
%                     Default: {'plot','amp'} ... plot amplitude spectrum only
%        'padding'    Traces with fewer than "padding" samples are padded with
%                     zeros. This parameter is ignored if the number of samples 
%                     per trace exceed "padding". Default:{'padding',256}
%        'plottype'   Type of seismic plot to use. Options are 'color' and 'wiggle'.
%                     Default: {'plottype','wiggle') for fewer than 61 traces
%                              {'plottype','color'}  for more than 60 traces
%        'normalize'  Establish if the amplitude spectra are to be normalized.
%                     Possible values: 'yes' and 'no'. Default: {'normalize','yes'}
%        'scale'      Set linear or logarithmic scale (dB) for amplitude spectrum.
%                     Possible values: 'linear', 'log'. Default: {'scale','linear'}
%        'taper'      Tapering applied to the time window
%               Possible names are :
%               	'Hamming', 'Hanning', 'Nuttall',  'Papoulis', 'Harris',
%               	'Rect',    'Triang',  'Bartlett', 'BartHann', 'Blackman'
%               	'Gauss',   'Parzen',  'Kaiser',   'Dolph',    'Hanna'.
%               	'Nutbess', 'spline'
%                     Default: {'taper','rect'}   (no taper)
% OUTPUT
% table       table structure with corner points of windows used
%             table is set to [] if no windows are picked
%             Also, in this case, global variable ABORTED=logical(1);
%             it is set to logical(0), otherwise.
% EXAMPLES
%        s_ispectrum{seismic,{'frequencies',0,80},{'padding',128},{'header','cdp'})
%        s_ispectrum(seismic,{'scale','log'})

global S4M ABORTED

ABORTED=logical(1);

%       Set defaults for input parameters
param.annotation='trace_no';
param.average='yes';
param.colors={'r','g','b','k','c','m','y', ...
                 'r--','g--','b--','k--','c--','m--','y--', ...
                 'r:','g:','b:','k:','c:','m:','y:'};
param.linewidth=3;
param.lloc=1;
param.normalize='yes';
param.frequencies={0,inf};
param.padding=128;
param.plot='amp';
param.plottype=[];
param.scale='linear';
param.taper='no';
param.taper='rect';

%       Decode and assign input arguments
param=assign_input(param,varargin);
if isempty(param.plottype)
   if size(seismic.traces,2) <= S4M.ntr_wiggle2color
      param.plottype='wiggle';
   else
      param.plottype='color';
   end
end

if strcmpi(param.plottype,'color')
   aux=s_cplot(seismic,{'annotation',param.annotation},{'tracking','no'});
elseif strcmpi(param.plottype,'wiggle')
   aux=s_wplot(seismic,{'annotation',param.annotation},{'tracking','no'});
else
   error([' Unknown plot type: ',param.plottype])
end
SeisHandle=aux.figure_handle;
set(SeisHandle,'DoubleBuffer','on');

userdata=struct('SeisHandle',SeisHandle);
userdata.param=param;
userdata.seismic=seismic;
userdata.exit=logical(0);
set(SeisHandle,'UserData',userdata)

%	Create a menu button that allows interacive window picking
menu2pick_frequency_windows(SeisHandle);

if ~ishandle(SeisHandle)
   table=[];
   return
end

userdata=get(SeisHandle,'UserData');

if userdata.exit
   delete(SeisHandle)
end

if nargout > 0  
   temp=userdata.SpecWindows;
   if ~isempty(temp)
      ABORTED=logical(0);
      table.type='table';
      table.tag='unspecified';
      table.name='Windows for spectrum estimation';
      table.column_info={'left',s_gu(seismic,param.annotation),param.annotation;
                      'right',s_gu(seismic,param.annotation),param.annotation;
                      'first',seismic.units,'Window start time';
                      'last',seismic.units,'Window end time'};
      table.left=temp(:,1);
      table.right=temp(:,2);
      table.first=temp(:,3);
      table.last=temp(:,4);
   else
      table=[];
   end
end

