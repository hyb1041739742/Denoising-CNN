function cstr=tokens(str,sep)
% Decompose string into individual strings separated by "sep"
%
%         cstr=tokens(str,sep)
% INPUT
% str     string
% sep     separator; Default: ','
% OUTPUT
% cstr    cell vector with strings

if nargin == 1
   sep=',';
end

lstr=length(str);
lstrh=fix(lstr*0.5);
cstr=cell(lstrh+1);

for ii=1:lstr
   [tok,str]=strtok(str,sep);
   cstr(ii)={tok};
   if isempty(str)
      cstr(ii+1:end)=[];
      break      
   end
end

