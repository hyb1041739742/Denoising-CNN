function time_stamp_p(location)
% Function creates time stamp and possibly program stamp on plot
%      date   date for time stamp (e.g. result of call to datum)
%      default (value of global variable TIME (if given) or result of call to datum
%      if global string variable PROGRAM is also set, the string PROGRAM is also 
%      written to the plot
%  Last updated: September 13, 2004: change handle visibilty to "off"

global PARAMS4PROJECT S4M WF

h_old=gca;
h=axes('Position',[0 0 1 1],'Visible','off');
if nargin == 1
  % do nothing
else
   location='bottom';
end

%  Add date/time stamp  
xt=0.70;
if strcmp(location,'top')
   yt=0.94; 
else
   yt=0.02; 
end
text(xt,yt,S4M.time,'FontSize',6); 

txt=strrep(S4M.plot_label,'_','\_');
if ~isempty(PARAMS4PROJECT) & isfield(PARAMS4PROJECT,'name') & ~isempty(txt)
   txt={strrep(PARAMS4PROJECT.name,'_','\_');txt};

elseif ~isempty(WF) & ~isempty(txt)
   txt={strrep(WF.name,'_','\_');txt};
end

xt=0.04;
if strcmp(location,'top')
  yt=0.94;
else
  yt=0.02;
end

text(xt,yt,txt,'FontSize',6); 
set(h,'HandleVisibility','off');

axes(h_old);
