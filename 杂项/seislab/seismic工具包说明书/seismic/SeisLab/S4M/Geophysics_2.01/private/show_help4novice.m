function hmsgh=show_help4novice(index)
% Display message window with help info if the field "experience" of global
% structure S4M is set to -1.

global S4M HELP4NOVICE

hmsgh=[];

if isempty(HELP4NOVICE)
   return
end

if S4M.experience < 0
   txt=tokens(HELP4NOVICE{index},'\');
   CreateMode.WindowStyle='replace';
   CreateMode.Interpreter='tex';
   hmsgh=msgbox(txt,S4M.name,'help',CreateMode);  
%   uiwait(hmsgh);
   drawnow
end
 