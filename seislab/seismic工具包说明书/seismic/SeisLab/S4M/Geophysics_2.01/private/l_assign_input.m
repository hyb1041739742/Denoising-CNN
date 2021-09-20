function [param,cm]=l_assign_input(param,arguments,fcn)
% Function matches keywords in cell array "arguments" to fields of "param", and 
% replaces them with new values. Used to assign input data in certain functions
% In addition it modifies default curve mnemonics (original curve mnemonic is used
% like a keyword
% Written by: E. R.: December 20, 2000
% Last updated: October 28, 2005: Handle differences in dbstack between R13 and R14
%
%                     [param,cm]=l_assign_input(param,arguments}
% INPUT
% param     structure
% arguments cell array, each element of "arguments" is a 2-element cell array whose 
%           first element is a field name of "param"
% fcn       string with the name of the function calling "assign_input";
%           optional
% OUTPUT
% param     input structure updated with values in "arguments"
% cm        structure with curve mnemonics. This structure is generally equal to 
%           CURVES defined in "presets", except for those curve mnemonics 
%           changed via the cell array "arguments".
%           It can also be input via {'cm',cm}
% EXAMPLE:  Assume "arguments" contains a cell array {'dtp','DTCO'}. Then
%           cm.dtp is set to 'DTCO' (whereas the default of "cm.dtp" would be 'dtp').
%           Assume "arguments" contains a cell array {'cm',cmx}. Then cell array
%           "cm" is set to "cmx". 
%           Any arguments such as {'dtp','DTCO'} in the calling program must 
%           come after {'cm',cmx}
%
% Input can also be provided via global variable "PARAMETERS4FUNCTION"
% GLOBAL VARIABLE
%          PARAMETERS4FUNCTION   structure with field "fcn" which, in turn, has fields
%                   'default' and/or 'actual'
%          Example: PARAMETERS4FUNCTION.s_iplot.default
%                   PARAMETERS4FUNCTION.s_iplot.actual
%          PARAMETERS4FUNCTION.s_iplot.actual is a structure with the actually used parameters
%          i.e. it has has the same fields as "param" on output


global CURVES PARAMETERS4FUNCTION

cm=CURVES;

if isempty(cm)
  disp(' Global structure "CURVES" is empty.')
  disp(' It is very likely that function "presets" has not been run.')
  error(' Abnormal termination')
end


ier=0;

%	Check if arguments are supplied via global variable "PARAMETERS4FUNCTION.fcn.default"

			if nargin > 2

if isfield(PARAMETERS4FUNCTION,fcn)
%   temp=PARAMETERS4FUNCTION.(fcn);
   temp=getfield(PARAMETERS4FUNCTION,fcn);
   if isfield(temp,'default')  &  ~isempty(temp.default)
      defaults=temp.default;
      fields=fieldnames(defaults);
      params=fieldnames(param);
      bool=ismember(fields,params);
      if ~all(bool)
         disp(['Parameters specified via "PARAMETERS4FUNCTION.',fcn,'.default":'])
         disp(cell2str(fields,', '))

         fields=fields(~bool);
         disp('Parameters that are not keywords of function:')
         disp(cell2str(fields,', '))

         disp('Possible keywords: ')
         disp(cell2str(params,', '))
	 temp.default=[];
%	Set "PARAMETERS4FUNCTION.functionname.default" to the empty matrix to prevent
                                % it from being used again in another function
%	 PARAMETERS4FUNCTION.(fcn)=temp; 
         PARAMETERS4FUNCTION=setfield(PARAMETERS4FUNCTION,fcn,temp);
	
         error(['Not all fields of "PARAMETERS4FUNCTION.',fcn,'.default" are keywords'])
      end
  
      for ii=1:length(fields)
 %        param.(fields{ii})=temp.default.(fields{ii});
         param=setfield(param,fields{ii},getfield(temp.default,fields{ii}));
      end

%     Set "PARAMETERS4FUNCTION.functionname.default" to the empty matrix to prevent
                                % it from being used again in another function
%      keyboard
      temp.default=[];
%      PARAMETERS4FUNCTION.(fcn)=temp; 
     PARAMETERS4FUNCTION=setfield(PARAMETERS4FUNCTION,fcn,temp);
   end
end
			end

for ii=1:length(arguments)
   arg=arguments{ii};
   field=lower(arg{1});
   if ~isfield(param,field)
      if strcmpi(field,'cm')
         cm=arg{2};                       % Use curve mnemonics of structure "cm"
      elseif isfield(cm,field)
%         cm.(field)=arg{2};    % Change a standard curve mnemonic
         cm=setfield(cm,field,arg{2});
      else
         if ier == 0
            funct=name_of_calling_function(3);
            ier=1;
         end
         disp([' "',field,'" is neither a valid input keyword for "',funct,'" nor a standard curve mnemonic'])
      end
   else
      if length(arg) == 2 & ~iscell(arg{2})      % Modification 
%         param.(field)=arg{2};
         param=setfield(param,field,arg{2});
      else
%         param.(field)=arg(2:end);
         param=setfield(param,field,arg(2:end));
      end
    end
end

if ier
   if ~isempty(param)
      disp('Recognized keywords are:')
      disp(fieldnames(param)')
   end
   disp('Recognized standard curve mnemonics are:')
   disp(fieldnames(CURVES)')
   error(['Input error in ',funct]) 
end

if nargin > 2
   temp.actual=param;
%   PARAMETERS4FUNCTION.(fcn)=temp; 
   PARAMETERS4FUNCTION=setfield(PARAMETERS4FUNCTION,fcn,temp);
end

