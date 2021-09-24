function [index,ier]=curve_indices(wlog,mnem,abort)
% Function outputs indices of curves in log structure "wlog".
% For any mnemonic in "mnem" for which there is no curve in "wlog" the 
% corresponding value of "index" is set to zero and the corresponding value 
% of "ier" is set to 1.
% Written by: E. R.: May 2000
% Last updated: August 23, 2004: make ier a logical variable
%
%         [index,ier]=curve_indices(wlog,mnem)
% INPUT
% wlog   log structure whose curve are requested
% mnem   curve mnemonic or cell array of curve mnemonics
% abort  optional parameter indicating if function should terminate abnormally
%        if one or more mnemonics are not found
%        abort = 1 ==> terminate abnormally
%        abort = 0 ==> do not terminate abnormally (default)
% OUTPUT
% index  row vector of indices of curves with mnemonics "mnem" length of index is equal 
%        to the number of mnemonics "mnem". 
% ier    logical row vector of error indicators (same length as index); zero if corresponding 
%        mnemonic has been found; 1 otherwise (if all requested mnemonics have been 
%        found sum(index = 0)  

global S4M

if iscell(mnem)
   lmnem=length(mnem); 
   index=zeros(1,lmnem);
   ier=zeros(1,lmnem);
else
%  lmnem=1;
%   mnem={mnem};
   mnem=tokens(mnem,',');
   ier=0;
   lmnem=length(mnem);
end


if nargin < 3
  abort = 0;
end

for ii=1:lmnem
  if S4M.case_sensitive
    temp=find(ismember(wlog.curve_info(:,1),mnem{ii}));
  else
    temp=find(ismember(lower(wlog.curve_info(:,1)),lower(mnem{ii})));
  end

%       Check for errors
  if length(temp) ~= 1
    if nargout < 2 
      if isempty(temp)     % Print error message
        disp([' Curve with mnemonic "',mnem{ii},'" not found'])

      elseif length(temp) > 1     % Print error message
        disp([' More than one curve with mnemonic "',mnem{ii},'" found'])
      end
    end
    ier(ii)=1;
  else
    index(ii)=temp;
  end
end

if sum(ier) > 0  &  nargout < 2
   disp(' The following curve mnemonics exist: ')
   disp(wlog.curve_info(:,1)');
   if abort
      error(' Abnormal termination')
   end
end

ier=logical(ier);

