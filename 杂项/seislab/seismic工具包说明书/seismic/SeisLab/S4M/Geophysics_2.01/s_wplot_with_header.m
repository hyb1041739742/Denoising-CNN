function aux=s_wplot_with_header(seismic,varargin)
% Function plots one or more header values above a seismic data set
% Written by: E. R.: August 1, 2005
% Last updated: October 23, 2005: Fixed misalignment of headers and 
%                                 corresponding traces
%
%           aux=s_wplot_with_header(seismic,varargin)
% INPUT
% seismic   seismic data set
% varargin  one or more cell arrays; the first element of each cell array is a keyword,
%           the other elements are parameters. Presently, keywords are:
%      'aindex annotation index; used to annotate specific traces with the
%           value of the header selected via keyword annotation.
%           EXAMPLE: {'aindex',10:10:1000}   every tenth trace annotated, 
%                                           starting with trace 10
%           Default: {'aindex',[]}          automatic annotation
%      'annotation'    mnemonic of the header to use for trace annotation
%           Default: {'annotation','trace_no'}
%      'deflection'    Trace deflection (multiple of trace-to-trace separation)
%           Default: {'deflection',1.25}
%      'headers2plot'  header mnemonic or cell array with the mnemonics of 
%           the headers to plot
%           Default: {'headers2plot','rms'}
%      'height_ratio'  Ratio of height if top window to bottom
%      'legendposition' position of the legend in header window; see "help legend"
%           Default: {'legendposition',1}
%      'linewidth'  width of lines in header plot
%           Default: {'linewidth',1}
%      'linkedzoom'  possible values are 'on' and 'off'. If linked zoom is on 
%           legends will disappear; they can be recreated with 
%           legend(aux.legend_handle,aux.legend_text); but then the
%           linked zoom will no longer be in effect
%           Default: {'linkedzoom','on'}
%      'marker'  marker to use;
%           Default: {'marker','s'}
%      'orient'  Figure orientation; possible values are 'portrait' and 'landscape'
%           Default: {'orient','landscape'}
%      'scale'   Specifies if traces should be scaled individually or not
%           Possible vales are 'yes' and 'no'.
%           Default: {'scale','no'}
%      'title'  strung with the plot title
%           Default: {'title',seismic.name}
% OUTPUT
% aux       structure with handles of plot elements
%     figure_handle      Figure handle
%     axis_handles       Handles of the two axes
%     legend_handle      Handle of the legend
%     legend_text        Text of legend
%     line_handles       Handles of the header curves plotted
%     title_handle       Handle of title


param.aindex=[];
param.annotation='trace_no';
param.deflection=1.25;
param.headers2plot='rms';
param.height_ratio=0.5; % Ratio of header window to seismic window
%             Default: {'height_ratio',0.5}    this means the header window 
%                                     is half as high as the seismic window
param.legendposition=1;
param.linewidth=1;
param.linkedzoom='yes';
param.marker='';
param.orient='landscape';
param.scale='no';
param.title=seismic.name;

%       Replace defaults by input parameters
param=assign_input(param,varargin);


if strcmpi(param.orient,'landscape')
   figure_handle=lfigure;
   time_stamp
else
   figure_handle=pfigure;
   time_stamp_p
end

headers2plot=param.headers2plot;
if ischar(headers2plot)
   headers2plot={headers2plot};
end

%       Create upper subplot axes

ratio=param.height_ratio;
height1=0.68*ratio/(1+ratio);
haxis1=subplot('position',[0.13,0.65,0.7750,height1]);
set(haxis1,'XTickLabel',blanks(length(get(haxis1,'XTick')))')
ntraces=size(seismic.traces,2);
nheaders=length(headers2plot);
x=[(1-param.deflection),1:ntraces,ntraces+(param.deflection)];
ltext=cell(nheaders,1);
hline=zeros(nheaders,1);

marker=param.marker;
for ii=1:nheaders
   if isempty(param.marker)
      marker=get_marker(ii);
   end
   hvalue=[NaN,s_gh(seismic,headers2plot{ii}),NaN];
   hline(ii)=line(x,hvalue,'Color',get_color(ii), ...
     'LineWidth',param.linewidth,'Marker',marker, ...
     'MarkerfaceColor',get_color(ii));
   ltext(ii)=headers2plot(ii);
end
grid on
axis tight

aux1=suptitle(param.title);
%legend_handle=legend(haxis1,ltext,param.legendposition);
%plot_box(axis,'k')
box

%	Create lower subplot axes
height2=0.68/(1+ratio);
haxis2=subplot('position',[0.13,0.1100,0.7750,height2]);
s_wplot(seismic,{'aindex',param.aindex},{'figure','old'}, ...
     {'orient',param.orient},{'quality','high'}, ...
     {'scale',param.scale},{'deflection',param.deflection}, ...
     {'annotation',param.annotation},{'title',''})

figure_export_menu(figure_handle)
if strcmpi(param.linkedzoom,'yes')
   linkedzoom(figure_handle,'onx2');
   disable_zoom(figure_handle)
end
legend_handle=legend(haxis1,ltext,param.legendposition);

if nargout > 0
   aux.figure_handle=figure_handle;
   aux.axis_handles=[haxis1,haxis2];
   aux.legend_handle=legend_handle;
   aux.legend_text=ltext;
   aux.line_handles=hline;
   aux.title_handle=aux1.title_handle;
end

