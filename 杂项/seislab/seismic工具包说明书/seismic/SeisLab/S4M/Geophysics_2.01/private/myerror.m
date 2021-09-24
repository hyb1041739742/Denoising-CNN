function myerror(message)
% Generalization of Matlabs error message for compiled code
% S4M.compiled == 0   same as standard error message
% S4M.compiled == 1   Error message is displayed in dialog window and global
% variable ABORTED is set to logical(1).
% Written by: E. R.: January 25, 2004
% Last updated: May 5, 2005: Message window displayed also if S4M.interactive is true
%
%           myerror(message)
% INPUT
% message   string with error message to display

global S4M ABORTED

if S4M.compiled  |  S4M.interactive
   disp(message)
   myerrordlg(message)
   ABORTED=logical(1);

else
   error(message)
end

