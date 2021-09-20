function initiate_3d_tracking(matrix,x,y,xinfo,yinfo,zinfo,bool,axis_handle)
% Initiate picking on a 2-d plot with with z-component)
% Written by: E. R.: September 14, 2003
% Last updated: March 16, 2005: add axis handle as input argument
%
%        initiate_3d_tracking(matrix,x,y,xinfo,yinfo,zinfo,bool,axis_handle)
% INPUT
% matrix  matrix of data plotted
% x      coordinates associared with columns
% y      coordinates associated with rows
% xinfo  info about x-coordinates; horizontal (optional)
% yinfo  info about y-coordinates; vertical (optional)
% zinfo  info about z-coordinates; values of matrix (optional)
% bool   logicl variable; if "bool" is true then menu button will be created
%        Default: bool=logical(1);
% axis_handle   handle of axis that should be tracked

if nargin < 8
   axis_handle=gca;
end

if nargin < 7
   bool=logical(1);
end

if nargin < 6
   xinfo={'x','','x'};
   yinfo={'y','','y'};
   zinfo={'z','','z'};
end

if nargin <3
   [n,m]=size(matrix);
   x=1:m;
   y=1:n;
end

xlabel(info2label(xinfo));
ylabel(info2label(yinfo));
zlabel(info2label(zinfo));

	% Implement cursor tracking
userdata=get(axis_handle,'UserData');
userdata.tag='display_cursor_location_3d';
userdata.userpointer='cross';
userdata.data=matrix;
userdata.ah=axis_handle;

userdata.x=x;
userdata.xformat='%8.5g';
userdata.xname=xinfo{1};
userdata.xunits=units4plot(xinfo{2});

userdata.y=y;
userdata.yformat='%8.5g';
userdata.yname=yinfo{1};
userdata.yunits=units4plot(yinfo{2});

userdata.zformat='%8.5g';
userdata.zname=zinfo{1};
userdata.zunits=units4plot(zinfo{2});

set(gca,'UserData',userdata);

if bool
%   create_button4tracking('g_display_cursor_location_3d');
   create_button4tracking(@display_cursor_location_3d);
end

