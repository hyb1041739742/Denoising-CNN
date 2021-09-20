function structure=add_handle2delete(handle,structure)
% Add handle to a list of handles in that should be deleted on exit from a GUI
% This list of handles is in the field 'handles2delete' in global variable 
% PARAMS4TASK or, if there is a second input argument, in structure structure.
% In this latter case the  output argument is required as well.
% Written by: E. R.: November 8, 2003
% Last updated: November 16, 2004: an empty handle is discarded
%
%             add_handle2delete(handle)   or
%             structure=add_handle2delete(handle,structure)
% INPUT
% handle      handle to add to vector "structure.handles2delete"
% structure   structure, most likely with field "handles2delete" 
%             (if second argument is not given structure PARAMS4TASK will be used)
% OUTPUT
% structure   Only used if structure is also an input argument

global PARAMS4TASK

if isstruct(handle)
   disp('handle is structure')
   return
end

if isempty(handle)
   if nargin == 1
      structure=[];
   end
   return
end

         try

if nargin == 1
   if isfield(PARAMS4TASK,'handles2delete')
      PARAMS4TASK.handles2delete=[PARAMS4TASK.handles2delete;handle];
   else
      PARAMS4TASK.handles2delete=handle;
   end
   if nargout > 0
      structure=[];
   end

else
   if isfield(structure,'handles2delete')
      structure.handles2delete=[structure.handles2delete;handle];
   else
      structure.handles2delete=handle;
   end
end

        catch

% Apparently, PARAMS4TASK or "structure" have not yet been defined
% do nothing
       
        end

