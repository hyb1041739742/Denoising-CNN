function time_stamp(location)
% Function creates time stamp and possibly a label on plot
% Time used is in S4M.time, label is in S4M.plot_label.
%      default (value of global variable S4M.time (if given) or result of call to datum
% Written by: E. R.: 1995
% Last updated: September 13, 2004: change handle visibilty to "off"
%
%           time_stamp(location)
% INPUT
% location  location of time stamp. Possible values are "top" and 'bottom'.
%           Default: 'bottom'

global PARAMS4PROJECT S4M WF 

h_old=gca;
h=axes('Position',[0 0 1 1],'Visible','off');
if nargin == 0
   location='bottom';
end

%  	Add date/time stamp  
xt=0.85;
if strcmp(location,'top')
   yt=0.95; 
else
   yt=0.02; 
end
text(xt,yt,S4M.time,'FontSize',7); 

xt=0.05;

txt=strrep(S4M.plot_label,'_','\_');

if ~isempty(PARAMS4PROJECT)  & isfield(PARAMS4PROJECT,'name')  &  ~isempty(txt)
   txt={strrep(PARAMS4PROJECT.name,'_','\_');txt};

elseif ~isempty(WF) & ~isempty(txt)
   txt={strrep(WF.name,'_','\_');txt};
end

if strcmp(location,'top')
   yt=0.95;
else
   yt=0.025;
end

text(xt,yt,txt,'FontSize',7); 
set(h,'HandleVisibility','off');

axes(h_old);

