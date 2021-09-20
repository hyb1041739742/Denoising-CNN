function l_tools(keyword)
% Without argument, function lists all functions that process log data
% The argument allows restrictions to those functions which have the keyword 
% as part of the description
%
% Written by E. R., May, 6, 2000
% Last updated: October 29, 2005: Check if S4M is defined
%
%           l_tools(keyword)   or   l_tools keyword
% INPUT
% keyword   Search string to restrict the output of this command to lines that contain
%           this string (needs to be in quotes if used as argument)
%
% EXAMPLES     
%           l_tools             % shows all log-related functions
%           l_tools plot        % shows log-related functions referring to plots
%           l_tools('plot')     % same as above

global S4M

if isempty(S4M)
   presets
end

list=list_of_log_functions;

if S4M.pd
%   index=find(cell2mat(list(:,1))> 0);
   list=list(cell2mat(list(:,1))> 0,2:3);
else
   list=list(:,2:3);
end

nl=size(list,1);

if nargin == 0
   disp([char(list{:,1}),blanks(nl)',char(list{:,2})]);
else
   jj=0;
   index=zeros(nl,1);
   for ii=1:nl
      if ~isempty(findstr(lower(list{ii,1}),lower(keyword))) | ~isempty(findstr(lower(list{ii,2}),lower(keyword)))
         jj=jj+1;
         index(jj)=ii;
      end
   end
   if jj == 0
      disp('  No matching well log tool found')
   else
      disp([char(list{index(1:jj),1}),blanks(jj)',blanks(jj)',char(list{index(1:jj),2})]);
   end
end    

