function val=param(var,parameter,default)
% This function searches the text string parameter for an assignment to 
% the variable var (also a text string). If it finds it it outputs 
% the assigned value; otherwise it assignes the default value (if given).
% Assignments are of the form var=value (e.g. dt=8) separated by commas
% or spaces.
%        val=parameter(var,param,default)
%
if ~ischarr(var)
   disp('Variable var is not a text string')
   return
end
if ~ischar(parameter)
   disp('Variable parameter is not a text string')
   return
end
[np,mp]=size(parameter);
var=[var,'='];
[nv,mv]=size(var);
if mv ==1; 
   disp('Variable var is empty string')
   return
end

s=findstr(parameter,var);
%   Check if string is either at the beginning of string parameter
%   or preceeded by comma or space
notfound=1;
falsealarm=0;
[ns,ms]=size(s);
if ms > 0
   s=s(ms:-1:1);
   for i=s
      if i > 1
         if ~strcmp(parameter(i-1:i-1),',')
            if ~strcmp(parameter(i-1:i-1),' ')
               falsealarm=1;
            end
         end
      end
      if falsealarm == 0     % find value of parameter
         ende=mp;
         s1=findstr(parameter(i+mv-1:mp),',');
         s2=findstr(parameter(i+mv-1:mp),' ');
         if size(s1) > 0 ; if s1(1)+i+mv-2 < ende ; ende = s1(1)+i+mv-2 ; end ; end
         if size(s2) > 0 ; if s2(1)+i+mv-2 < ende ; ende = s2(1)+i+mv-2 ; end ; end
         val=parameter(i+mv:ende);
         break
      else
         val=default;
      end
   end
else
  val=default;
end

   
