function matrix=rd_columns(filename,skip,ncol)
% matrix=rd_columns(filename,skip,ncol)
%
% Function reads data in columnar form from file
% filename file name
% skip     number of lines to skip
% ncol     column indices (eg 1:5, [1 3 5 9], etc.)


fid=fopen(filename);
if fid==-1
   selected_file=get_filename4r('*');
   fid=fopen(selected_file,'rt');
end 

for ii=1:abs(skip)
   line=fgetl(fid);
   if skip > 0; disp(line); end
end

matrix=fscanf(fid,'%g',[ncol,inf])';
fclose(fid);

%       Make sure there are at least ncol columns
if(size(matrix,2)) ~= ncol
        fprintf(' file must contain at least %d columns \n',ncol);
	disp(' rd_columns1 unable to continue');
	return;
end

