function MenuHandle=menu2pick_frequency_windows(figure_handle)
% Create menu button to pick rectangular windows; the spectrum of the data 
% is posted to a second window. The calllback function that does
% all this is also in this file ("g_ispectrum") and passed on to the
% "outside world" via a "function handle".

% Written by: E. R.: November 23, 2003
% Last updated: November 28, 2003: Use function handle to make function 
%                                  name globally usable.
%
%                MenuHandle=menu2pick_frequency_windows(figure_handle)
% INPUT
% figure_handle  handle of the figure to which the menu button is
%                to be attached; default: gcf
% OUTPUT
% MenuHandle     handle of the menu item

if nargin == 0
   figure_handle=gcf;
end

%	Create function handle for "g_ispectrum"
%g_ispectrum=@g_ispectrum;

%	Create menu button
MenuHandle=uimenu(figure_handle,'Label','Pick windows','ForeGroundColor',[1 0 0]);

set(MenuHandle,'CallBack',@g_ispectrum,'Tag','Pick_window_menu')
hmsgh=show_help4novice(1);

waitfor(MenuHandle)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g_ispectrum(hObject,eventdata)
% Interactively select windows on a seismic data set and compute the spectra of
% the data in these windows
% Written by: E. R.: November 23, 2003
% Last updated: November 27, 2003: Bug fix with window plot

% global S4M

SeisHandle=gcf;
userdata=get(SeisHandle,'Userdata');
param=userdata.param;
seismic=userdata.seismic;

%       Remove figure button functions
state = uisuspend(SeisHandle);

%	If button is pressed in Window check if it was over the Picking button
set(SeisHandle,'WindowButtonDownFcn','g_check_menu_button', ...
               'CloseRequestFcn','g_closerequest4ispectrum')

MenuHandle=findobj(SeisHandle,'Tag','Pick_window_menu');
arg='findobj(gcf,''Tag'',''Pick_window_menu'')';
set(MenuHandle,'Label','Done picking windows','CallBack',['delete(',arg,')'])

if isfield(seismic,'null')  
   null=1;       % Set logical value null to true if there are NaNs in the seismic
else
   null=0;       % Set logical value null to false if there are no NaNs in the seismic
end


nspectra=length(param.colors);
book=cell(nspectra,4);  % Book-keeping array
                        % color, handle of box, handle of spectrum, box coordinates
book(:,1)=param.colors';
index=1:nspectra;         
fnyquist=500/seismic.step;
if param.frequencies{2} > fnyquist
   param.frequencies{2}=fnyquist;
end

SpecHandle=lfigure;
%	Shift figure position to make it visible below seismic window
%msg=['This figure can be closed once the Button "',get(MenuHandle,'Label'), ...
%    '" in the corresponding seismic window has been pressed'];
set(SpecHandle,'Position',get(SpecHandle,'Position')+[-40,40,0,0], ...
        'CloseRequestFcn',[],'Tag',['Spectrum_4_',num2str(SeisHandle)])

figure_export_menu(SpecHandle); % Create menu button to export figure as emf/eps file

axis([param.frequencies{1},param.frequencies{2},0,1])
if strcmpi(param.normalize,'yes')
   axis manual
end
grid on
zoom
mytitle('Amplitude spectra of selected windows of seismic data set')
xlabel('Frequency (Hz)')
if strcmpi(param.scale,'linear')
   atext='Amplitude (linear)';
else
   atext='Amplitude (dB)';
end
ylabel(atext)
time_stamp

type='continue';


        while ~strcmpi(type,'quit') & ishandle(MenuHandle)

if isempty(index)
   warndlg(' Not enough colors to display additional spectrum')
end
figure(SeisHandle)
ia=index(1);

axis_handle=gca;
set(SeisHandle,'WindowButtonDownFcn',{@pick_or_delete_a_box,axis_handle})

waitfor(MenuHandle,'UserData')
if ishandle(MenuHandle)
   set(MenuHandle,'UserData','wait')
else
   break
end
userdata1=get(axis_handle,'UserData');
type=userdata1.type;
handle=userdata1.handle;
box=userdata1.box;

%%%[type,handle,box]=pick_box(seismic,{'color',book{ia,1}},{'header',param.annotation});
refresh

switch type
                case 'pick'          % A box has been picked



%	Round coordinates of box to the nearest samples
hvals=s_gh(seismic,param.annotation);
idxh=find(hvals >= box(1) & hvals <= box(2));
idxt1=round((min(box(3:4))-seismic.first)/seismic.step)+1;
idxt2=round((max(box(3:4))-seismic.first)/seismic.step)+1;

		if isempty(idxh) | idxt2-idxt1 < 4
type='continue';
%delete(handle)

		else
box(1:2)=sort([hvals(idxh(1)),hvals(idxh(end))]);
box(3:4)=([idxt1,idxt2]-1)*seismic.step+seismic.first;
handle=plot_box(box,'r',param.linewidth);
book{ia,2}=handle;
book{ia,4}=box;

index(1)=[];

ntr=length(idxh);
traces=seismic.traces(max([1,idxt1]):min([end,idxt2]),idxh);
if null
  idx_null=find(isnan(traces));
  if ~isempty(idx_null)
    traces(idx_null)=0;
  end
end
nsamp=size(traces,1);
wind=mywindow(nsamp,param.taper);
traces=spdiags(wind,0,nsamp,nsamp)*traces;
ft=fft(traces,max([param.padding,nsamp]));

nfft=size(ft,1);
f=(0:2:nfft)*fnyquist/nfft;

amp=abs(ft(1:length(f),:));
if ntr > 0 & strcmpi(param.average,'yes')  
  amp=mean(amp,2);
end

if strcmpi(param.scale,'linear')
   atext='Amplitude (linear)';
   amin=0;
else
   atext='Amplitude (dB)';
   amp=amp/max(amp);
%   idx=find(amp < 1.0e-5);     
   amp(amp < 1.0e-5)=1.0e-5;   % Constrain the possible values of the amplitude spectrum
   amp=20*log10(amp/max(amp));
   amin=-inf;
end

if strcmpi(param.scale,'linear') & strcmpi(param.normalize,'yes')
   amp=amp/max(amp);
end
color=book{ia,1};
if length(color) > 1
   linestyle=color(2:end);
else
   linestyle='-';
end
set(handle,'Color',color(1),'LineStyle',linestyle, ...
        'LineWidth',param.linewidth,'EraseMode','none');

figure(SpecHandle)
hl=line(f,amp,'Color',color(1),'LineStyle',linestyle, ...
        'LineWidth',param.linewidth,'EraseMode','none');
book{ia,3}=hl;
% keyboard
		end


                case 'delete'
idx=find(cat(1,book{:,2}) == handle);
if isempty(idx)
   disp(' Handle not found')
else
   figure(SeisHandle)
   delete(handle)         % Delete box
   refresh

   figure(SpecHandle)
   temp=book(idx,:);
   delete(temp{3})        % Delete spectrum curve
   refresh

   book(idx,:)=[];
   idx1=index(1)-1;
   book=[book(1:idx1-1,:);temp;book(idx1:end,:)];
%   book=[temp;book];
   index=[idx1,index];       % First value of "index" is next available row in bookkeeping array
end


                case 'break'
% keyboard
          
                otherwise
  % Continue
                end

             end      % End while

figure(SpecHandle)
set(SpecHandle,'CloseRequestFcn','closereq')
set(SeisHandle,'WindowButtonDownFcn',[])
hold off
ncurves=index(1)-1;
ltext1=cell(ncurves,1);
ltext2=cell(ncurves,1);

for ii=1:ncurves
  ltext1(ii)={[strrep(param.annotation,'_','\_'),': ',num2str(min(book{ii,4}(1:2))),'-', ...
                                       num2str(max(book{ii,4}(1:2))),';']};
  ltext2(ii)={[' time: ',num2str(min(book{ii,4}(3:4))),'-', ...
                        num2str(max(book{ii,4}(3:4))),' ',seismic.units]};
end

ltext=[char(ltext1),char(ltext2)];

%       Avoid error message if no spectrum curves have been created
try
   legend(ltext,param.lloc)
catch
end
refresh

%	Return data to calling program
userdata=get(SeisHandle,'UserData');
SpecWindows=reshape([book{1:ncurves,4}],4,ncurves)';
userdata=struct('SpecWindows',SpecWindows,'exit',userdata.exit);
figure(SeisHandle)
uirestore(state);
set(SeisHandle,'Userdata',userdata,'CloserequestFcn','closereq')
refresh

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g_closerequest4ispectrum(hObject,eventdata)

SeisHandle=gcf;
SpecHandle=findobj('Tag',['Spectrum_4_',num2str(SeisHandle)]);
set(SpecHandle,'CloseRequestFcn','closereq')

MenuHandle=findobj(SeisHandle,'Tag','Pick_window_menu');
delete(MenuHandle)

userdata=get(SeisHandle,'UserData');
userdata.exit=1;
set(SeisHandle,'CloserequestFcn','closereq','UserData',userdata)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pick_or_delete_a_box(hObject,evdata,axis_handle)
% Select a rectangular area/box in a figure or find the handle of an existing
% box (for deletion)
% Written by: E. R.: November 23, 2003
% Last updated: August 27, 2004: add input arguments for use via a call-back function handle
%
%              pick_or_delete_a_box(hObject,evdata,axis_handle)
% INPUT
% hObject          used by Matlab
% evdata           used by Matlab
% axis_handle      axis handle
% OUTPUT
% userdata.type    type of action ('pick' or 'delete', or 'continue')
% userdata.box     corners of box selected (if "type" is "pick", [] otherwise)
% userdata.handle  handle of box selected (if "type" is "delete",[] otherwise)

FigureHandle=gcf;
userdata=get(axis_handle,'UserData');
type=get(FigureHandle,'SelectionType');
set(FigureHandle,'WindowButtonDownFcn','')
if strcmp(type,'normal')
   box=gg_pickbox;
   userdata.handle=[];
   userdata.type='pick';
   userdata.box=box;

elseif strcmp(type,'alt')
   userdata.type='delete';
   userdata.box=[];
   userdata.handle=gco;
   if isempty(userdata.handle)
      userdata.type='continue';
   end

else
   userdata.type='continue';
   userdata.box=[];
   userdata.handle=[];
end
set(axis_handle,'UserData',userdata)

MenuHandle=findobj(FigureHandle,'Tag','Pick_window_menu');
set(MenuHandle,'UserData','proceed')



