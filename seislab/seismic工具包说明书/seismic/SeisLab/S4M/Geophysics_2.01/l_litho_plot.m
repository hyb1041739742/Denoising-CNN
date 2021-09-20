function aux=l_litho_plot(wlog,varargin)
% Function plots log curves with lithology indicated by markers and/or color
% Written by: E. R., November 5, 2000
% Updated: January 19, 2005: Replace "CURVE_MNEMONICS" by "CURVES"
%
%         aux=l_litho_plot(wlog,varargin)
% INPUT
% wlog    log structure; it must contain curves representing lithology; the
%	  curve values are 1 (true) if the lithology is present and zero 
%         otherwise.
% varargin   one or more cell arrays; the first element of each cell array is
%         a keyword, the other elements are parameters. Presently, keywords are:
%      'axis' Possible values are: 
%             'top'  horizontal axis is located on top of figure
%             'bottom' horizontal axis is located on bottom of figure
%             'alternate' horizontal axis axis alternates between top and bottom
%             Default: {'axis' 'top'}
%      'curves'  cell array with mnemonics of curves to display
%             Default: all curves except those describing lithology
%      'depths'  start and end depth values to plot
%             Default: the whole depth range
%      'figure'  Specifies if new figure should be created or if the seismic
%             traces should be plotted to an existing figure. Possible values
%             are 'new' and any other string. 
%             Default: {'figure','new'} 
%      'lithos'  cell array of lithologies. 
%             Default: {'litho',all_lithologies_present_in_the_log_structure}
%      'lloc'    legend location;
%             Default: {'lloc',0} 
%      'linewidth' Line width of symbols (can be used to "fill" open 
%             symbols such as triangles, squares, diamonds.
%             Default: {'linewidth',1} 
%      'markersize'   Marker size. 
%             Default: {'markersize',5')
%      'orient'  plot orientation. Possible values are 'portrait' and 
%             'landscape'.
%             Default: {'orient','portrait'} for four or fewer curves
%                        {'orient','landscape'} for more than 4 curves
%      'title' plot title; Default: {'title',''}
%
%         Additional keywords are all the lithology curves (unit 'logical')
%         They can be used to assign color, marker type, marker size, and
%         line width. The first two must always be given, the last two are
%         optional and the defaults for markersize and line width are used
%         if they are not given or empty.
%               Defaults are:
%               {'coal','k','*'}
%               {'dolomite','m','^'}
%               {'gas_sand','r','d'}
%               {'hc_sand','m','d'}
%               {'limestone','c','^'}
%               {'oil_sand','g','d'}
%               {'sand', [1.0,0.8,0.0],'d'}
%               {'sh_sand',[0.6,0.6,0.6],'d'}
%               {'shale',[0.6,0.6,0.6],'.'}
%               {'volcanics','m','v'}
%               {'wet_sand','b','d'}
%         Any lithology which is to be used but does not have a preset 
%         color/marker must have at least these two parameters defined in 
%         the argument list.
%         EXAMPLES 
%              {'salt','b','+'}        Use defaults for marker size
%                                      and line width
%              {'salt','b','+',[],4}   Use default for marker size
%              {'salt','b','+',7}      Use default for line width
%
% OUTPUT
% aux     optional output argument. Structure with field "axis_handles"
%         which contains the handles to the axes of all subplots

global CURVES

if ~isstruct(wlog)
  error(' Input data set must be a log structure')
end

%       Set default lithologies (all lithologies in log structure)       
idx=find(strcmpi(wlog.curve_info(:,2),'logical'));
lidx=length(idx);
if lidx == 0
   alert(['log "',inputname(1),'" has no lithology curves'])
   return
end
param.lithos=wlog.curve_info(idx,1);

%       Set default color/symbol defaults
param=setfield(param,CURVES.shale,{[0.6,0.6,0.6],'.','',''});
param=setfield(param,CURVES.sand,{[1.0,0.8,0.0],'d','',''});
param=setfield(param,CURVES.gas_sand,{'r','d','',''});
param=setfield(param,CURVES.hc_sand,{'m','d','',''});
param=setfield(param,CURVES.oil_sand,{'g','d','',''});
param=setfield(param,CURVES.sh_sand,{[0.6,0.6,0.6],'d','',''});
param=setfield(param,CURVES.wet_sand,{'b','d','',''});
param=setfield(param,CURVES.coal,{'k','*','',''});
param=setfield(param,CURVES.limestone,{'^','c'});
param=setfield(param,CURVES.dolomite,{'^','m'});
param=setfield(param,CURVES.volcanics,{'v','m'});

%       Set default color/symbol defaults for other lithologies
%       defined in log structure
idx=find(~ismember(param.lithos,fieldnames(param)));
for ii=1:length(idx)
   param=setfield(param,param.lithos{ii},cell(1,4));
end

%     Set other default values
param.axis='top';
param.curves=[];
param.depths=[wlog.first,wlog.last];
param.figure='new';
param.lloc=0;
param.linewidth=1;
param.markersize=5;
param.orient=[];
param.title=inputname(1);

%       Decode input arguments
[param,cm]=l_assign_input(param,varargin);

if isempty(param.curves)
   param.curves=wlog.curve_info(2:end,1)';
%   index=find(~ismember(param.curves,param.lithos));
   param.curves=param.curves(~ismember(param.curves,param.lithos));
elseif ~iscell(param.curves)
   param.curves={param.curves};
end
param.curves=lower(param.curves);

%       Determine number of lithologies
litho=param.lithos;

if iscell(litho)
   nlitho=length(litho);
else
   nlitho=1;
   litho={litho};
end

%       Determine number of curves
ncurves=length(param.curves);

if isempty(param.orient)
   if ncurves > 4
      param.orient='landscape';
   else
      param.orient='portrait';
   end
end

%       Depth range to plot
if iscell(param.depths)
   param.depths=[param.depths{1},param.depths{2}];
end
index0=find(wlog.curves(:,1) >= param.depths(1) & ...
       wlog.curves(:,1) <= param.depths(2));

if strcmp(param.figure,'new')
   if strcmpi(param.orient,'portrait')
      pfigure
      font_size=(40/max([4,ncurves]))+1;    % Adjust font size to the number of curves to plot
      hold on

   elseif strcmpi(param.orient,'landscape')
      lfigure
      font_size=(60/max([6,ncurves]))+1;    % Adjust font size to the number of curves to plot
      hold on

   else
      error([' Unknown orientation:',param.orient])
   end
end

%       Plot curves
ier=0;
ltext=cell(1,nlitho);	% Prepare room for legend
hh=zeros(ncurves,1);    % reserve room for subplot handles

for ii=1:ncurves
   if ncurves > 1        % Avoid "subplot" command if there is only one curve to plot
      hh(ii)=subplot(1,ncurves,ii);
   else
      hh=gca;
   end
   xx=get(gca,'Position');
   set(gca,'Position',[xx(1:3),0.8]);   % Place sub-plots in figure
   if exist('font_size','var')
      set(gca,'FontSize',font_size);
   end
   idx=curve_index1(wlog,param.curves{ii});
   if isempty(idx)
      disp([' Requested curve mnemonic "',param.curves{ii},'" not available'])
      ier=1;
   elseif length(idx) > 1
      error([' More than one curve with mnemonic "',param.curves{ii},'"'])
   else
      for kk=1:nlitho
         idx0=curve_index1(wlog,litho{kk});
         if isempty(idx0)
            disp([' Requested curve mnemonic "',litho{kk},'" not available'])
            ier=1;
         elseif length(idx0) > 1
            error([' More than one curve with mnemonic "',litho{kk},'"'])
         else
            temp=getfield(param,litho{kk});
            col=temp{1};            % Set color
            marker=temp{2};         % Set marker

            if length(temp) < 3     % Set marker size
               markersize=param.markersize;
            else
               if ~isempty(temp{3})
                  markersize=temp{3};
               else
                  markersize=param.markersize;
               end
            end

            if length(temp) < 4     % Set line width
               linewidth=param.linewidth;
            else
               if ~isempty(temp{4})
                  linewidth=temp{4};
               else
                  linewidth=param.linewidth;
               end
            end

            if isempty(col) | isempty(marker)
               disp([' No color and/or marker defined for lithology "',litho{kk},'"'])
               ier=1;
            else
               index=index0(find(wlog.curves(index0,idx0)));
               line(wlog.curves(index,idx(1)),wlog.curves(index,1),'Color', ...
                    col,'Marker', marker,'MarkerSize',markersize, ...
                    'LineStyle','none','Linewidth',linewidth)
               hold on
 
               if ii == 1		% Create text for label 
                  ltext(kk)=wlog.curve_info(idx0,3);
               end
            end       
         end
      end
      title(mnem2tex(wlog.curve_info{idx,1}));
      if strcmpi(param.axis,'alternate')
         if mod(ii,2) 		% Alternate location of annotation (top or bottom)
            set(gca,'XAxisLocation','top')
         end
      elseif strcmpi(param.axis,'top')
         set(gca,'XAxisLocation','top')
      end

      xlabel(units2tex(wlog.curve_info{idx,2}));
      set(gca,'YDir','reverse')
      if ii == 1
         ylabel([wlog.curve_info{1,3},' (',units2tex(wlog.curve_info{1,2}),')'])
      end
      if ii > 1 & ii < ncurves
         set(gca,'YtickLabel','')
      end
      if ii == ncurves & ii ~= 1
         set(gca,'YAxisLocation','right')
         ylabel([wlog.curve_info{1,3},' (',units2tex(wlog.curve_info{1,2}),')'])
      end
   end
   grid, zoom on
end

if ier
   error(' Abnormal termination')
end

if strcmpi(param.orient,'portrait')
%   set(gca,'Position',[0.13,0.11,0.775,0.75]); % Restore paper position to the one in pfigure
   time_stamp_p
else
%   set(gcf,'PaperPosition',[0.8 0.8 9.0 7]);   % Restore paper position to the one in lfigure
   time_stamp
end

if ~isempty(param.title)
   if ncurves > 1
      suptitle1(mnem2tex(param.title))
   else
      mytitle(mnem2tex(param.title))
   end
end

legend(ltext,param.lloc)
if nargout > 0
   aux.axis_handles=hh;
end


