function [selected_file,ierr]=get_filename4w(ext,filename)
% Function interactively gets a file name with extrension ext for writing a data set
% Written by: E. R., December 13, 2000
% Last updated: October 30, 2005; fixed file selection
%
%              [selected_file,ierr]=get_filename4w(ext)
% INPUT
% ext          file extension (including .) or filename. Extensions for which paths are defined are: 
%              '.sgy','.log','.tbl','.mat'.   Default: '.mat'
%              This extension is used to choose the initial directory path
%              and to show only files with this extension. Both can be changed 
%              in the file selector box
% filename     optional file name (without path)
% OUTPUT
% selected_file  filename including path
% ierr         error code. ierr = logical(0) if a filename was selected and 
%              ierr = logical(1) if not.
%              global variables: S4M.filename   name of the file selected
%                                S4M.pathname   name of the path selected
%                                ABORTED (same as ierr)
%              this means that   selected_file = fullfile(S4M.pathname,S4M.filename)

global S4M ABORTED

if isempty(S4M)
   presets
end

if nargin < 2 
   filename='';
   if nargin == 0
      ext='.mat';
   end
end

ierr=logical(0);

oldDir=pwd;

%        Open file selector window
if strcmpi(ext,'.sgy') |  strcmpi(ext,'sgy')
   filter_spec={'*.sgy;*.segy', 'Seismic files (*.segy, *.sgy)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Write SEG-Y file';
   try
      cd(S4M.seismic_path)
   catch
   end

elseif strcmpi(ext,'.mat')
%   filter_spec=[S4M.mat_path,'.mat'];
   filter_spec={'*.mat', 'Matlab mat files (*.mat)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Write Matlab MAT file';
   try
      cd(S4M.mat_path)
   catch
   end



elseif strcmpi(ext,'.las') | strcmpi(ext,'las')
   filter_spec={'*.las', 'Well log files (*.las)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Write LAS file';
   try
      cd(S4M.log_path)
   catch
   end

elseif strcmpi(ext,'.tbl')  |  strcmpi(ext,'tbl')
%   filter_spec=[S4M.table_path,'*.tbl;*.txt;*.dat'];
   filter_spec={'*.tbl;*.txt;*.dat', 'Table files (*.tbl, *.txt, *.dat)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Write TABLE to file';
   try
      cd(S4M.table_path)
   catch
   end

else
   filter_spec=ext;
   dialogue='Select file for output';
end 

try
   [filename,pathname]=uiputfile(filter_spec,dialogue,filename);
catch
   alert('Failure to get a file name (uiputfile aborted)')
   filename=0;
end

cd(oldDir)

if filename == 0; 
   uiwait(errordlg(' No file selected. Task terminated',S4M.name,'modal'))
   selected_file='';
   ierr=logical(1);
   ABORTED=logical(1);
   return
end

selected_file=[pathname,filename];
if ~S4M.compiled
   disp(['File    ',selected_file,'    interactively selected']);
end
  
%   	Set path name to the path just used
if strcmpi(ext,'sgy')
   S4M.seismic_path=pathname;
elseif strcmpi(ext,'mat')
   S4M.mat_path=pathname;
elseif strcmpi(ext,'las')
   S4M.log_path=pathname;
elseif strcmpi(ext,'tbl')
   S4M.table_path=pathname;
end 

S4M.filename=filename;
S4M.pathname=pathname;
ABORTED=logical(0);

