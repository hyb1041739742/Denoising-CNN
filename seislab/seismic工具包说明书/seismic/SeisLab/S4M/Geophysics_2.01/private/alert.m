function alert(message)
% Function displays an alert message unless S4M.alert is set to logical(0)
% Written by: E. R.: August 3, 2001
% Last updated: October 28, 2005: Better handling of the difference of 
% function "dbstack" between R13 and R14
%
%          alert(message)
% INPUT
% message  message to dispay (the message is preceeded by the string
%          'Alert from "calling_program": ' 
%          where "calling_program" is the name of the program that called "alert".
%          The message can be string of a cell array

global S4M

if S4M.alert
   disp(' ')
% 	Find name of the calling program 
   temp=dbstack; 
   if length(temp) > 1       % Alert is called from another program
      program=name_of_calling_function(3);
      if iscell(message)
         disp([' Alert from "',program,'": ',message{1}])
         for ii=2:length(message)
            disp(['     ',message{ii}])
         end
      else
         disp([' Alert from "',program,'": ',message])
      end
   else
      if iscell(message)
         disp([' Alert: ',message{1}])
         for ii=2:length(message)
            disp(['        ',message{ii}])
         end
      else
         disp([' Alert: ',message])
      end 
   end
disp(' ')
end
  

