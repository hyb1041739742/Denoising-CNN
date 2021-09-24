function zoom_handles=disable_zoom(figure_handle)
% Disable the zoom/unzoom button in the menu bar of a figure window
% Written by: E. R.: August 25, 2004
% Last updated: November 19, 2004: Handle tag-change in Matlab version 7.0
%
%                 zoom_handles=disable_zoom(figure_handle)
% INPUT
% figure_handle   handle of the figure whose zoom should be disabled
% OUTPUT
% zoom_handles    handles of the two zoom buttons (to allow them to be enabled later)

global S4M

handles=findall(figure_handle,'type','uitoggletool');

if S4M.matlab_version < 7 
   index=logical(strcmp(get(handles,'Tag'),'figToolZoomOut') + ...
         strcmp(get(handles,'Tag'),'figToolZoomIn'));
else
   index=logical(strcmp(get(handles,'Tag'),'Exploration.ZoomOut') + ...
         strcmp(get(handles,'Tag'),'Exploration.ZoomIn')); 
end

zoom_handles=handles(index); 
set(zoom_handles,'enable','off')

if nargout == 0
   clear zoom_handles
end

