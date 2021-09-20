function fig2eps(repfig,figno)
% Export figure for use in reports
% Written by: E. R.: March 4, 2003
% Last updated: April 14, 2004: Use also workflow name, global variable  
%               WF.name (if it exists)
%
%      fig2eps(repfig,figno)
% INPUT
% repfig  unique figure number for report (required)
% figno   figure number 
%         Default: figno=gcf
%
% global variable S4M.eps_directory  Directory name in directory with papers
%                 e.g.  S4M.eps_directory='Papers\Euclid_wavelet_length'
%                 The full path is "fullfile(S4M.report_path,S4M.eps_directory)"

global S4M WF

if nargin == 0
   alert(' Figure number in report is required for an EPS file to be saved')
   return
end
if nargin == 1
   figno=gcf;
end
figure(figno)
pos=get(figno,'PaperOrientation');
if strcmpi(pos,'portrait')
   bool=0;
   set(figno,'PaperPosition',[0.8 0.5 4.4 5.5]);
else
   set(figno,'PaperPosition',[0.8 0.5 10 5.5]);
   set(figno,'PaperOrientation','portrait')
   bool=1;
end

set(gcf, 'InvertHardcopy', S4M.invert_hardcopy)

name1='';
if isfield(S4M,'eps_directory') & ~isempty(S4M.eps_directory)
   if isfield(WF,'name')  &  ~isempty(WF.name)      % Prepend workflow name followed by "."
      name1=[WF.name,'.'];
   end
 
   try
      filepath=fullfile(S4M.eps_directory,[name1,S4M.script,'_',num2str(repfig),'.eps']);
      print('-depsc2',filepath)
   catch
      try
         filepath=fullfile(S4M.report_path,S4M.eps_directory,[name1,S4M.script,'_',num2str(repfig),'.eps']);
         print('-depsc2',filepath)
      catch
         alert(['File "',filepath,'" could not be created. EPS file has not been saved.'])
         return
      end
   end
   

else
   alert(' Field "eps_directory" of global variables "S4M" is empty.');
   if S4M.interactive
      S4M.eps_directory=uigetfolder_standalone('Directory for EPS files', 'C:\');
      if isempty(S4M.eps_directory)
         return
      end
      filepath=fullfile(S4M.eps_directory,[name1,S4M.script,'_',num2str(repfig),'.eps']);
      print('-depsc2',filepath)
   else
      disp(' Figure not saved.')
      return
   end
end

if bool
   set(figno,'PaperOrientation','landscape')
end

[directory,filename,ext]=fileparts(filepath);
if S4M.interactive
   msgdlg(['Figure saved in file "',filename,ext,'" in directory "',directory,'" as an Encapsulated PostScript file'])
end
disp(['Figure saved in file "',filename,ext,'" in directory "',directory,'" as an Encapsulated PostScript file'])

