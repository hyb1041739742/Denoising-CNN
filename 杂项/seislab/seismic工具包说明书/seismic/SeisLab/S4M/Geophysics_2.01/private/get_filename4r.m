function [selected_file,ierr]=get_filename4r(ext)
% Function interactively gets a file name with extension ext for reading a data set
% Written by: E. R., December 13, 2000
% Last updated: October 30, 2005: fixed file selection
%
%              [selected_file,ierr]=get_filename4r(ext)
% INPUT
% ext          file extension. Extensions for which paths are defined are: 
%              'sgy','log','tbl','mat'.   Default: 'mat'
%              This extension is used to choose the initial directory path
%              and to show only files with this extension. Both can be changed 
%              in the file selector box
% OUTPUT
% selected_file  filename including path
%              global variables: S4M.filename   name of the file selected
%                                S4M.pathname   name of the path selected
%                                ABORTED (same as ierr)
%              this means that   selected_file = [S4M.pathname,S4M.pathname]
% ierr         error indicator: logical(1) if error
% GLOBAL VARIABLE
%              The filename is stored in  S4M.filename
%              the path name in S4M.pathname;


global ABORTED S4M

if isempty(S4M)
   presets
end

if nargin == 0
  ext='mat';
end

ierr=logical(0);

oldDir=pwd;

%        Open file selector window
if strcmpi(ext,'sgy')
   filter_spec={'*.sgy;*.segy', 'Seismic files (*.segy, *.sgy)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Read SEG-Y file';
   try
      cd(S4M.seismic_path)
   catch
   end

elseif strcmpi(ext,'mat')
   filter_spec={'*.mat', 'Matlab mat files (*.mat)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Read Matlab MAT file';
   try
      cd(S4M.mat_path)
   catch
   end

elseif strcmpi(ext,'las')
   filter_spec={'*.las', 'Well log files (*.las)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Read LAS file';
   try
      cd(S4M.log_path)
   catch
   end
elseif strcmpi(ext,'tbl')
   filter_spec={'*.tbl;*.txt;*.dat', 'Table files (*.tbl, *.txt, *.dat)'; ...
                '*.*',          'All files (*.*)'};
   dialogue='Read TABLE from file';
   try
      cd(S4M.table_path)
   catch
   end
else
   filter_spec=ext;
   dialogue='Select file for input';
end 

try
   [filename,pathname]=uigetfile(filter_spec,dialogue);
catch
   alert('Failure to get a file name (uigetfile aborted)')
   filename=0;
end

cd(oldDir)

if filename == 0;
   uiwait(errordlg(' No file selected. Task terminated',S4M.name,'modal'))
   selected_file='';
   ierr=logical(1);
   ABORTED=logical(1);
   return;
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

