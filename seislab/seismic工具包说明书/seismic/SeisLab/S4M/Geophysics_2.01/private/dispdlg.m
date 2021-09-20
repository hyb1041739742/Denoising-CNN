function dispdlg(txt)
% Generalization of disp function; text is written to screen if 
% S4M.interactive  == 0 and written to a dialog box if S4M.interactive  == 1
% Written by: E. R.: April 20, 2004
% Last updated:
%
%          dispdlg(txt)
% INPUT
% txt      Text to display
%
global S4M
  
if S4M.interactive
   msgdlg(txt)
else
   disp(txt)
end

