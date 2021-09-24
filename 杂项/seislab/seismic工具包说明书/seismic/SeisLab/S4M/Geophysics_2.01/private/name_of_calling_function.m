function functionName=name_of_calling_function(ik)
% Function determines the name of the function in the calling sequence that
% lead to this call
% INPUT
% ik      index specifying the level up 
%         1 function that called "name_of_calling_function",
%         2 function that called the function that called "name_of_calling_function",
%           ....
% OUTPUT
% functionName  name of the requested function

global S4M

try
   temp=dbstack;
   functionName=temp(ik).name;
   if S4M.matlab_version < 7 
      [dummy,functionName]=fileparts(functionName);
   end

catch
   functionName='???';
end