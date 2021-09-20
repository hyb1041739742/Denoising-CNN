function [seismic,header]=s_wavelet_from_hr(filename)
% Read wavelet in Hampson-Russell format from ASCII file 
% Written by: E. R.: October 18, 2005
% Last updated:
%
%           [seismic,header]=s_wavelet_from_hr(filename)
% INPUT
% filename  file name (optional)
%           the filename and the directory are saved in global variable S4M
% OUTPUT
% seismic   seismic data set read from file
% header    text header of Hampson-Russell file

global ABORTED S4M

if nargin > 0
   fid=fopen(filename);
else
   fid =-1;
end
if fid == -1
   selected_file=get_filename4r('*.*');
   fid=fopen(selected_file,'rt');
   if ABORTED
      seismic=[];
      header=[];
      return
   end
else
   filename2S4M(filename)
end 
S4M.default_path=S4M.pathname;

header=cell(25,1);

line=deblank(fgetl(fid));
ik=0;

while ~strcmp(line,'#STRATA_WPARAMS')
   ik=ik+1;
   header{ik}=line;
   line=deblank(fgetl(fid));
end
header=header(1:ik);

%       Read wavelet parameters
ierr=0;
line=fgetl(fid);
if ~strcmp(line(1:2),'SR')
   step=str2double(line(4:end));
else
   ierr=1;
end


line=fgetl(fid);
if ~strcmp(line(1:2),'TZ')
   nt0=str2double(line(4:end));
else
   ierr=1;
end

line=fgetl(fid);
if ~strcmp(line(1:2),'NS')
   nsamp=str2double(line(4:end));
else
   ierr=1;
end

line=fgetl(fid);
if ~strcmp(line(1:2),'PR')
   pr=str2double(line(4:end));
else
   ierr=1;
end

if ierr > 0
   %error('Data apparently not in Hampson-Russell format.')
   fclose(fid)
   disp('File is not in Jason format')
   warndlg('File is not in Jason format!')
   ABORTED =logical(1);
   seismic=[];
   return
end

%       Prepare seismic structure
seismic.type='seismic';
seismic.tag='wavelet';
[dummy,name]=fileparts(S4M.filename);
seismic.name=name;
seismic.units='ms';
seismic.first=(1-nt0)*step;
seismic.last=seismic.first+(nsamp-1)*step;
seismic.step=step;


%	Read the first trace-data line to determine the number of columns
seismic.traces=fscanf(fid,'%g',[1,nsamp])';

fclose(fid);

if S4M.history
   seismic=s_history(seismic,'add',['File ',seismic.name,' from Hampson-Russell']);
end

