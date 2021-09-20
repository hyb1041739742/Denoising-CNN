function logout=l_select(login,varargin)
% Function retrieves subset of log from log structure
% An error message is printed if a column mnemonic is not found. 
% Column mnemonics are not case sensitive (corresponds to l_select1.m of folder Geophysics)
%
% Written by E. R.: October 7, 2000;
% Last updated: March 4, 2003: Allow string with comma-separated curve mnemonics
%  
%           logout=l_select(login,varargin)
% INPUT
% login	    log structure
% varargin  same number of traces
% varargin  one or more cell arrays; the first element of each cell array is a 
%           keyword, the other elements are parameters. Presently, keywords are:
%       'curves'  strings with curve mnemonics. 
%           Default: {'curves','*'} (implies all curves)
%           The depth (first column of "login.curves") is always included  
%       'depths'  start and end depth of log segment (two comma-separated numbers
%           or a two-element vector)
%           Default: {'depths',login.first,login.last}
%       'rows'  string with logical expression involving one more of the 
%           curve mnemonics
%           Default: {'rows',''} (implies all rows)
%           Keywords 'curves., 'depths' and 'rows' may be given at the same time               
%
% OUTPUT
% logout    output log with curves defined in "curves"
%
% EXAMPLES  logout=l_select(login,{'curves','depth','twt'},{'rows','depth > 5000'})
%           logout=l_select(login,{'curves','depth','twt'},{'depths',2000,3000})
%           logout=l_select(login,{'rows','depth > 1000 & twt < 2000'})
%           logout=l_select(login,{'depths',4000,4500},{'rows','vclay < 0.35})

%    Set default values for input parameters
param.curves='*';
param.depths=[login.first,login.last];
param.rows='';

%       Decode and assign input arguments
param=assign_input(param,varargin);

if iscell(param.depths)
   param.depths=cat(2,param.depths{:});
end

ncols=size(login.curves,2);

%       Select curves
if strcmp(param.curves,'*')
   cindex=1:ncols;
else
   cindex=curve_indices(login,param.curves);
   if ~isempty(find(cindex==0))
     error(' Abnormal termination')
   end
   if cindex(1) ~= 1
      cindex=[1,cindex];
   end
end

%       Select rows
param.depths=sort(param.depths);
dindex=find(login.curves(:,1) >= param.depths(1) & login.curves(:,1) <= param.depths(2));
if isempty(dindex)
   error([' Requested depth range (',num2str(param.depths(1)),', ',num2str(param.depths(2)), ...
        ') outside of range of log depths (',num2str(login.first),', ',num2str(login.last),')'])
end

if ~isempty(param.rows)

%       Find all the words in the logical expression
  words=lower(extract_words(param.rows));
  mnems=login.curve_info(find(ismember(lower(login.curve_info(:,1)),words)),1);  % Find curve mnemonics in logical expression   
  [index,ier]=curve_indices(login,mnems);
  index=unique(index);
  index=index(find(index > 0)); 
  if isempty(index)
     disp([' No colunm mnemonics in logical expression "',param.rows,'"'])
     error([' Available curve mnemonics are: ',cell2str(login.curve_info(:,1))])
  end

%       Create vectors whose names are the curve mnemonics in the logical expression
  for ii=1:length(index)
     eval([lower(char(login.curve_info(index(ii),1))),' = login.curves(dindex,index(ii));']);
  end

%       Modify expression to be valid for vectors
  expr=strrep(param.rows,'*','.*');
  expr=strrep(expr,'/','./');
  expr=strrep(expr,'^','.^');
  expr=lower(expr);

%       Evaluate modified expression
       	try
  rindex=eval(['find(',expr,')']);

     	catch
  disp([' Expression "',param.rows,'" appears to have errors'])
  disp([' curve mnemonics found in expression:',cell2str(login.curve_info(index,1))])
  disp([' curve mnemonics available:',cell2str(login.curve_info(:,1))])
  disp(' Misspelled curve mnemonics would be interpreted as variables')
  error(' Abnormal termination')
       	end

  if isempty(rindex)
     error([' No rows selected by condition "',param.rows,'"'])
  else
     dindex=dindex(rindex);
  end
end

logout.curve_info=login.curve_info(cindex,:);
logout.curves=login.curves(dindex,cindex);
logout.first=logout.curves(1,1);
logout.last=logout.curves(end,1);
dd=diff(logout.curves(:,1));

if ~isempty(dd)
   mad=max(dd);
   mid=min(dd);
   if mid*(1+1.0e6*eps) < mad
      logout.step=0;
   else
      logout.step=(logout.last-logout.first)/length(dd);
   end
else
   logout.step=1;
end

%       Copy rest of fields
logout=copy_fields(login,logout);

% 	Add null value if necessary
if ~isfield(logout,'null')
   if sum(isnan(logout.curves(:,2:end))) > 0
      logout.null=NaN;
   end
end
    

