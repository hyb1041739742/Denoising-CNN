function fig2pp(figure_handle,reverse)
% Export figure for use in PowerPoint
% Written by: E. R.: January 20, 2003
% Last updated: November 4, 2005: Use exportfig instead of print
%
%          fig2pp(figure_handle,reverse)
% INPUT
% figure_handle    figure number 
%          Default (if not given or empty): figure_handle=gcf
% reverse  Reverse the figure background and axis colors and adjust graphs
%          (see "whitebg")
%          Default: reverse=logical(1);
%          S4M.invert_hardcopy must be set to 'off' to have an effect
%          (See figure property 'InvertHardcopy')

global S4M
persistent figure_number

directory=S4M.pp_directory;

if nargin == 0
   figure_handle=gcf;
   reverse=logical(0);
elseif nargin == 1
   reverse=logical(0);
else
   if isempty(figure_handle)
      figure_handle=gcf;
   end
end

if isempty(figure_number)
   figure_number=1;
else
   figure_number=figure_number+1;
end

figure(figure_handle)	% Make figure the current figure
pos=get(figure_handle,'PaperOrientation');

if isempty(S4M.script)
   filename=['Figure_',num2str(figure_handle),'_x',num2str(figure_number),'.emf'];
else
   filename=[S4M.script,'_',num2str(figure_handle),'_x',num2str(figure_number),'.emf'];
end

	% Create file name for plot file
filepath=fullfile(directory,filename);

if reverse
   whitebg(figure_handle)         % Change background to complementary colors
end

set(figure_handle,'InvertHardcopy',S4M.invert_hardcopy);

try 
   filename
   if strcmp(pos,'portrait')
      width=6.5;
   else
      width=10;
   end
   exportfig(figure_handle,filepath,'Format','meta','Width',width,'Color','rgb')

catch 
  [filepath,ierr]=get_filename4w('.emf');
   if ierr & reverse
      whitebg(figure_handle)         % Change background to complementary colors
      return
   end
   [directory,name,ext]=fileparts(filepath);
   filename=[name,ext];
   exportfig(figure_handle,filepath,'Format','meta','Width',width,'Color','rgb')
end

if reverse
   whitebg(figure_handle)         % Change background to complementary colors
end

if S4M.interactive
   msgdlg(['Figure saved in file "',filename,'" in directory "',directory,'" as a Windows Enhanced Meta File.'])
end


