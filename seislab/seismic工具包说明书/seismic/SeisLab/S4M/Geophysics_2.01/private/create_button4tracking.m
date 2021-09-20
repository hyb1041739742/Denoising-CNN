function bh=create_button4tracking(type_of_action)
% Create a menu item to track cursor movements
% Written by: E. R.: August 31, 2003
% Last updated: January 8, 2004
%
%                bh=create_button4tracking(type_of_action)
% INPUT
% type_of_action  cell array or string with the call-back function to use for cursor tracking
%                presently options are:
%                {@display_cursor_location_2d,gca}
%                @display_cursor_location_3d
%                'g_display_cursor_location_patch'


userdata.on_off='off';
userdata.button_action=type_of_action;
figure_handle=gcf;

set(figure_handle,'MenuBar','figure')

bh=uimenu('Label','Tracking is off','Tag','tracking_button', ...
   'ForeGroundColor',[0 0 1],'UserData',userdata);

set(bh,'Callback',{@tracking,figure_handle})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tracking(hObject,evdata,figure_handle)
% GUI tool
% Written by: E. R.: August 31, 2003
% Last updated: January 8, 2004: use function handle
%
%            tracking(hObject,evdata,figure_handle)
% INPUT
% hObject    handle of button
% evdata     reserved by Matlab
% figure_handle  handle of figure window

% set(gcf,'MenuBar','none')
% state = uisuspend(gcf);

%disp(['hObject ',num2str(hObject)])%test
%figure_handle
%bh=findobj(figure_handle,'Tag','tracking_button')%test
zoom off
bh=hObject;

if isempty (bh)		% Window has no "tracking" button
   disp('No "tracking" button')
   return
end

userdata=get(bh,'UserData');


if strcmp(userdata.on_off,'off')
   userdata.on_off='on';
   set(bh,'UserData',userdata,'Label','Tracking is on');
   set(figure_handle,'WindowButtonMotionFcn',userdata.button_action);
   zoom off

else
   userdata.on_off='off';
   set(bh,'UserData',userdata,'Label','Tracking is off');
   set(figure_handle,'WindowButtonMotionFcn',[]);
   
   hh=findobj(figure_handle,'Tag','cursor_tracking_data');    % Find and remove the display
   delete(hh)                                                 % of the cursor tracking data
%   set(gcf,'menuBar','figure')
%   uirestore(state);
end   

