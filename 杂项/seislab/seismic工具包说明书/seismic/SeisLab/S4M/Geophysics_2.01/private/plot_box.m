function handle=plot_box(loc,color,linewidth)
% Function plots a rectangular box
%
%        handle=plot_box(loc,color,linewidth)
% INPUT
% loc    vector with elements xa xe ya ye
%        so the box has the corner coordinates (xa,ya), (xe,ya), (xe,ye), (xa,ye)
%        This vector is identical to the one output by the command AXIS
% color  string with color and line style. Default: 'r-'
% linewidth  line with of the box. Default: 2
% OUTPUT
% handle "handle" to box

if nargin < 3
  linewidth=2;
end
if nargin < 2
  color='r';
end
if length(color) > 1
  marker=color(2:end);
else
  marker='-';
end

%hold on
axis manual
if nargout == 1
  handle=line([loc(1),loc(2),loc(2),loc(1),loc(1)], ...
      [loc(3),loc(3),loc(4),loc(4),loc(3)],'Color',color(1),'LineWidth',linewidth, ...
      'LineStyle',marker','EraseMode','none');
else
  line([loc(1),loc(2),loc(2),loc(1),loc(1)], ...
      [loc(3),loc(3),loc(4),loc(4),loc(3)],'Color',color(1),'LineWidth',linewidth, ...
      'LineStyle',marker','EraseMode','none');
end
%hold off



