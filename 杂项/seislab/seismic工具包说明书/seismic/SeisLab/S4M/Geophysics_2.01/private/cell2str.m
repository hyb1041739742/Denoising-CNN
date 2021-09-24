function string=cell2str(cellvec,sep)
% Function converts cell vector of strings to a string
%
%          string=cell2str(cellvec,sep)
% INPUT
% cell    Cell array of strings
% sep     separator between strings output; default is blank
% OUTPUT
% string  All strings in the cell array lined up

if nargin == 1
   sep=' ';
end
string=cellvec{1};
for ii=2:length(cellvec)
   string=[string,sep,cellvec{ii}]; 
end 

