function initiate_2d_tracking(xinfo,yinfo,bool)
% Initiate picking on a 2-d plot (no z-component)
% Written by: E. R.: September 14, 2003
% Last updated: January 8, 2004: streamlined call-backs
%
%        initiate_2d_tracking(xinfo,yinfo,bool)
% INPUT
% xinfo  info about x-coordinates (optional)
% yinfo  info about y-coordinates (optional)
% bool   logicl variable; if "bool" is true then menu button will be created
%        Default: bool=logical(1);


if nargin < 3
   bool=logical(1);
end

if nargin < 2
   xinfo={'x','','x'};
   yinfo={'y','','y'};
end
        
        % Implement cursor tracking
userdata.tag='display_cursor_location_2d';
userdata.userpointer='cross';
userdata.ah=gca;
userdata.bgcolor=get(gcf,'Color');
userdata.position=[0,0,300,20];

userdata.xformat='%8.5g';
userdata.xname=xinfo{1};
userdata.xunits=units4plot(xinfo{2});

userdata.yformat='%8.5g';
userdata.yname=yinfo{1};
userdata.yunits=units4plot(yinfo{2});

set(gca,'UserData',userdata);

if bool
   %create_button4tracking('g_display_cursor_location_2d');
   create_button4tracking({@display_cursor_location_2d,gca});
end

