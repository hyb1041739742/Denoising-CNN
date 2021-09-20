function sgrid(d,type,color,lw)
% Function plots grid lines at coordinate(s) d
% Written by: E. R.
% Last updated: March 9, 2004: make handle of grid invisible so that it is not 
% used by the "legend" command
% 
%       sgrid(d,type,color,lw)
% INPUT
% d     array denoting the location of grid lines
%       grid line locations outside the range of axis values are discarded
% type  string variable
%       'v'  vertical lines
%       'h'  horizontal lines
% color Color and style of the lines (default: color='k-')
% lw    Line width (default: lw=1)
%
%	See also SGRID1

if nargin < 3
   color='k';
   linestyle='-';
   lw=1;
else
   if length(color) > 1
      linestyle=color(2:end);
   else
     linestyle='-';
   end
   color=color(1);
end
if nargin < 4
   lw=1;
end
if isempty(color), 
   color='k';
   linestyle='-';
end
  
hold on

v=axis;
% nl=length(d);
if strcmp(type,'v') == 1
%   idx=find(d >= v(1) & d <=v(2));
   x=d(d >= v(1) & d <=v(2));
   handles=zeros(length(x),1);
   for ii=1:length(x);
      handles(ii)=line([x(ii),x(ii)],[v(3),v(4)],'Color',color,'LineStyle', ...
            linestyle,'LineWidth',lw);
   end

elseif strcmp(type,'h') == 1
%   idx=find(d >= v(3) & d <=v(4));
   x=d(d >= v(3) & d <=v(4));
   handles=zeros(length(x),1);
   for ii=1:length(x);
      handles(ii)=line([v(1),v(2)],[x(ii),x(ii)],'Color',color,'LineStyle', ...
            linestyle,'LineWidth',lw);
   end
else
   error('Unknown argument type')
end
set(handles,'HandleVisibility','off')

