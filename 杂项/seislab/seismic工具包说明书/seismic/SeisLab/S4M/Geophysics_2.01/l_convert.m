function wlog=l_convert(curves,info,aux_wlog)
% Function converts a matrix of curve values, curve names, curve units of measurement, 
% curve description, etc. into a well log structure.
% Written by E. R.: Date Feb. 12, 2000;  
% Last updated: September 1, 2003: Change input
%
%          wlog=l_convert(curves,info,aux_wlog)  
% INPUT
% curves       Matrix of log curves; the first column represents depth 
%              or equivalent (e. g. travel time)
% info         cell array of the form {mnemonic,units,description}; 
%              one row for each column of "curves".
%              Example: {'rho','g/cm3','Density'; 'DTp','us/ft','Sonic'}
% aux_wlog     optional log structure from which some of the fields not
%              specified with the data above can be copied
% OUTPUT
% wlog		Structure
%               wlog.type       'well_log'
%		wlog.curves	Matrix of curve values
%               wlog.curve_info	Cell array with curve mnemonics, units of measurement,
%                               and curve descriptions for each curve
%               wlog.first	Start of log (first depth in file)
%		wlog.last	Stop of log (last depth in file)
%		wlog.step	Depth increment (0 if unequal)
%		wlog.null	Null value
%               wlog.date	Date  (current date)
%
% The above fields do not represent all the fields required to create a valid LAS
% file. In particular, the LAS standard requires the following information:
%       wlog.company     Company
%       wlog.well        Name of well
%       wlog.field       Field name
%       wlog.location    Location of well
% Sometimes there already exists a log structure which has this information. In this
% case the optional input parameter aux_wlog can be used to copy these parameters to the
% new log structure.      

% 	Check for input compatibility
[n,m]=size(curves);
if n == 0
  error('Curve array empty')
end

ninfo=size(info,1);

if  ninfo ~= m
  error(['Number of curve mnemonics (',num2str(ninfo),...
    ') different from number of curves (',num2str(m),')'])
end

% 	Store input in structure
wlog.type='well_log';
wlog.name='Log created from matrix';
wlog.curve_info=info;

if curves(1,1) > curves(end,1)
   wlog.curves=flipud(curves);
else
   wlog.curves=curves;
end

wlog.first=wlog.curves(1,1);
wlog.last=wlog.curves(end,1);
if n == 1
   wlog.step=0;
elseif n == 2
   wlog.step=wlog.end-wlog.start;
else
   dd=diff(wlog.curves(:,1));
   if any(dd <= 0)
      error(' First column of curves does not increase monotonically')
   end
   madd=max(dd);
   midd=min(dd);
   wlog.step=round(500*(madd+midd))/1000;
   if abs(madd-midd) > abs(wlog.step)*0.00001
      wlog.step=0;
   end
end

if ~isempty(find(isnan(curves)))
   wlog.null=NaN;
end

wlog.date=date;
%    For internal use
     wlog.company='Generic Contractor';
     wlog.field='unknown field';
     wlog.location='unknown location';
     wlog.wellname='unknown well';
%    End of internal-use fields
     
if nargin == 5   	% Check if input arguments include a log structure
  if isstruct(aux_wlog)
    if isfield(aux_wlog,'company'), wlog.company=aux_wlog.company; end
    if isfield(aux_wlog,'wellname'),wlog.wellname=aux_wlog.wellname; end 
    if isfield(aux_wlog,'field'),   wlog.field=aux_wlog.field; end
    if isfield(aux_wlog,'location'),wlog.location=aux_wlog.location; end  
    if isfield(aux_wlog,'api'), 	  wlog.api=aux_wlog.api; end
    if isfield(aux_wlog,'province'),wlog.province=aux_wlog.province; end
    if isfield(aux_wlog,'state'),   wlog.state=aux_wlog.state; end
    if isfield(aux_wlog,'county'),  wlog.county=aux_wlog.county; end
    if isfield(aux_wlog,'country'), wlog.country=aux_wlog.country; end
    if isfield(aux_wlog,'service'), wlog.service=aux_wlog.service; end
    if isfield(aux_wlog,'uwi'),     wlog.uwi=aux_wlog.uwi; end
  else
    fprintf('Input parameter "aux_wlog" is not a structure\n')
  end
end


