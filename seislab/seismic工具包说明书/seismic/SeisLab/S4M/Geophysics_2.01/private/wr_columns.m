function wr_columns(filename,data,text,format)
% Function writes array to ASCII file
% Written by: E. R.:
% Last updated: May 5, 2005: filename without path triggers file selection box
% 
%             wr_columns(filename,data,text)
%
% INPUT
%   filename  name of file to create (if empty, file will be interactively selected)
%   data      data to store in columnar format
%   text      cell array with ASCII text to be placed in front of data
%             If "text" is empty but global variable S4M is not empty
%             then the string ['Created by ',S4M.script] will be printed on 
%             the first line
%   format    optional string with format for coversion of numeric data
%             Default: '%10.6g'  

global S4M ABORTED

%  	Open the file
if isempty(filename)  |  (isempty(findstr(filename,filesep))  &  isempty(findstr(filename,':')))
   fid=-1;
else
   fid=fopen(filename,'wt');
end

if fid == -1 
   filename=get_filename4w('.txt',filename);
   if isempty(filename)
      return
   end
end 

	try
fid=fopen(filename,'wt');

%   Write text above data
if nargin > 2
  if isempty(text)
    if ~isempty(S4M)
      fprintf(fid,['Created by ',S4M.script,'\n']);
    end
  else
    if ~iscell(text)
      fprintf(fid,[strrep(text,'\','\\'),'\n']);
    else
      for ii=1:length(text)
        fprintf(fid,[strrep(text{ii},'\','\\'),'\n']);
      end
    end
  end
end

%   Write data
[n,m]=size(data);

if exist('format','var')
   format=[format,'%s'];
else
   format='%10.6g %s';
end

for ii=1:n
if fix(ii/1000)*1000==ii; fprintf('%d of %d lines of data written\n',ii,n); end
  for jj=1:m
    fprintf(fid,format,data(ii,jj),'   ');
  end
  fprintf(fid,'\n'); 
end

fclose(fid);

	catch
fclose(fid);
ABORTED=logical(1);
	end

