function display_cursor_location_3d(hObject,evdata)
% GUI tool
% To invoke:
%    set(gcf,'WindowButtonMotion',@display_cursor_location_3d)

ah=gca;

userdata=get(ah,'UserData');
if isempty(userdata)
   return
end
if ~strcmp(userdata.tag,'display_cursor_location_3d')
   return
end
if isempty(get(gcf,'WindowButtonMotion'))
   bh=findobj(gcf,'Tag',['tracking_button',num2str(gcf)]);
   userdata=get(bh,'UserData');
   userdata.on_off='off';
   set(bh,'Label','Tracking is off','UserData',userdata);
   return
end

pos=get(ah,'CurrentPoint');
xlimits=get(ah,'XLim');
ylimits=get(ah,'YLim');

x=pos(1,1);
y=pos(1,2);
xx=userdata.x;
yy=userdata.y;

%	Cursor is inside the axes box
if x >= xlimits(1) & x <= xlimits(2) & ...
   y >= ylimits(1) & y <= ylimits(2)

   data=userdata.data;
   [n,m]=size(data);
   idx=find((xx(1:end-1)+xx(2:end))*0.5 > x);
   if isempty(idx)
      idx=m;
   else
      idx=idx(1);
   end
   
   idy=find((yy(1:end-1)+yy(2:end))*0.5 > y);
   if isempty(idy)
      idy=n;
   else
      idy=idy(1);
   end
   x=xx(idx);
   y=yy(idy);
   z=data(idy,idx);
   data2show=['  ',userdata.xname,': ',sprintf(userdata.xformat,x),' ',userdata.xunits,';  ',...
              userdata.yname,': ',sprintf(userdata.yformat,y),' ',userdata.yunits,';  ' ...
              userdata.zname,': ',sprintf(userdata.zformat,z),' ',userdata.zunits];
	 
   set(gcf,'Pointer',userdata.userpointer)
   userdata.hh=uicontrol('Units','pix','pos',[0 0 500 25],'Style','text',...
	'String',data2show,'Horiz','left','BackgroundColor',get(gcf,'Color'),...
	'ForegroundColor',[0 0 0],'Tag','cursor_tracking_data','Userdata',[]);
   set(ah,'UserData',userdata);

else	% Cursor is outside of the axes box
   if isfield(userdata,'pointer')
      set(gcf,'Pointer',userdata.pointer);	% Save presently used pointer type
   else
      userdata.pointer=get(gcf,'Pointer');      % Restore pointer
      set(ah,'UserData',userdata);
   end
   if isfield(userdata,'hh')
      if ishandle(userdata.hh)
         set(userdata.hh,'ForegroundColor',get(gcf,'Color'))
      end
   end 
end
