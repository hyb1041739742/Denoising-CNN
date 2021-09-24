function plotimage(smat,t,x)
% PLOTIMAGE ... Image display utility for seismic matrices
%
% plotimage
% plotimage(smat)
% plotimage(smat,t)
% plotimage(smat,t,x)
%
% PLOTIMAGE can be open in several ways.  Simply typing 'plotimage' will
% initiate the PLOTIMAGE figure.  Initializing PLOTIMAGE using the other 
% mothods does a quick plot of a seismic matrix in a figure window
% (made by plotimage). By default, it plots the seismic matrix in gray levels
% using the seisclrs colormap.  
%
%	smat ... the seismic matrix to be plotted. Traces are assumed stored in
%       the columns smat.
%	t ... time coordinates of traces.
%       ****** default 1:nrows where nrows = number of rows in smat ****
%	x ... x coordinates of the traces
%       ****** default 1:ncols where ncols=number of columns *****
%
% As of 2003, PLOTIMAGE has a new look interface and more features.
% Descriptions of new features follow.
% 
% Image Controls
%----------------
% There are three modes for which PLOTIMAGE can be set.  Zoom mode allows
% for the user to zoom in on the image using a box and zoom out with a
% single click.  There are two picking modes, Pick(0) and Pick(N).  The '0'
% and 'N' stand for old and new.  This signifies that invoking Picks(0)
% allows user to begin creating an orginal pickset while
% invoking Picks(N) begins a new pickset by clearing the existing PICKS
% matrix and deleteing any picsk drawn on top of the plot.
%
% Each PLOTIMAGE window can also be set to the status of "independent",
% "master", or "slave".  This refers to the method by which the maximum
% absolute value and standard deviations of the data are obtained.  For
% both "independent" and "master" these numbers are measured from the input
% data while for the "slave" case the numbers are the same as for the most
% recent PLOTIMAGE window this is declared as "master".  This allows
% multiple PLOTIMAGE windows to be displayed in true relative amplitude with
% respect to one another by setting one to be "master" and the other(s) to be
% "slave".  
% 
% The two basic plot modes, mean and maximum scaling, are described below. Mean scaling is
% best for real data (with a large dynamic range) while maximum scaling is preferred for
% synthetic when you want an accurate display of amplitudes.
%
% Mean scaling (SCALE_OPT=1)... The mean and standard deviation of all samples are computed.
%		samples>= mean+CLIP*stddev are clipped (set equal to mean+CLIP*stddev).
%		(The same is done for negative samples which are set to mean -CLIP*stddev).
%		These two extremes are mapped to the ends of the color map and all intermed
%		values are displayed linearly.
% Maximum scaling (SCALE_OPT=2) ... The maximum absolute value of the data is computed (say mxs).
%		The extremes of the colormap are then assigned to +/- mxs and all intermed
%		values are displayed linearly. There is no clipping but the display may
%		be dominated by any large values.
%
% MAIN AXIS 
% ---------
% Contains the image that the user has loaded.  Various uicontext menu
% controls (accessed using MB2 on the axis) help control the axis labels,
% sample rate, Zoom Options, and Picks options (only when other PLOTIMAGE
% figures are open).  
%
% Limit Box
%-----------
% Can be activated on the main axis uicontext menu, or Options menu.
% Activiating this function creates a box which finds the mean value inside
% the box and limits the rest of the image.  This can be used in both Mean
% amd Maximum scaling modes.  
%
% Zoom options
%--------------
% When zooming mode is initiated in the Image Controls, MB2 clicks and drags
% in the main axis will initiate zooming limited to the image.  When
% multiple PLOTIMAGES are open, each figure can be zoom locked to any
% other.  Publishing and Matching zoom limits are also available options
% when multiples PLOTIMAGES have been opened.
%
% Picks Options
%---------------
% Picks can be imported from one PLOTIMAGE figure to another.
%
% Position Axis
% -------------
% This axis is a smaller version of the main axis.  When a zoom occures on
% the main axes, a red patch appears on the position axis that corresponds
% to the location of the zoom that just occured.  Moving the patch with MB1
% will also move the zoom parameters on the main axis.
%
% NOTE: PLOTIMAGE has several values that are utilized as global
% variables.  SCALE_OPT, NUMBER_OF_COLORS, GRAY_PCT, CLIP, COLOR_MAP,
% NOBRIGHTEN, PICKCOLOR, XAXISSTOP, CLOSEREQUEST, IMCONTROLS are all 
% variables that the aU ser is allowed to set in the command window while 
% plotimage is running.  These variables are best changed using the 
% figure context menu, but can also be changed by other programs while 
% plotimage is running.  The globals can also be changed before POIMTAGE 
% image has been started, see plotimage_setglobal for more details
%
% G.F. Margrave, CREWES Project, U of Calgary, 1996, 1999, 2000, and 2003
%
% NOTE: It is illegal for you to use this software for a purpose other
% than non-profit education or research UNLESS you are employed by a CREWES
% Project sponsor. By using this software, you are agreeing to the terms
% detailed in this software's Matlab source file.

% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by
% its author (identified above) and the CREWES Project.  The CREWES
% project may be contacted via email at:  crewes@geo.ucalgary.ca
%
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) Use of this SOFTWARE by any for-profit commercial organization is
%    expressly forbidden unless said organization is a CREWES Project
%    Sponsor.
%
% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the
%    CREWES Project Sponsorship agreement.
%
% 3) A student or employee of a non-profit educational institution may
%    use this SOFTWARE subject to the following terms and conditions:
%    - this SOFTWARE is for teaching or research purposes only.
%    - this SOFTWARE may be distributed to other students or researchers
%      provided that these license terms are included.
%    - reselling the SOFTWARE, or including it or any portion of it, in any
%      software that will be resold is expressly forbidden.
%    - transfering the SOFTWARE in any form to a commercial firm or any
%      other for-profit organization is expressly forbidden.
%
% END TERMS OF USE LICENSE

if(nargin==0)
    action='PI_init';
    smat=[];
    t=[];
elseif(nargin==1)
    % testing smat to see if it is numericall
    if(isnumeric(smat))
        action='PI_init';
        smat=smat;
    else
        action=smat;
        smat=[];
    end
    t=[];
    x=[];
elseif(nargin==2);
    action='PI_init';
    smat=smat;
    t=t;
    x=[];
elseif(nargin==3)
    action='PI_init';
    smat=smat;
    t=t;
    x=x;
end
if(strcmp(action,'PI_init'));
    PI_init_image;
    if(~isempty(smat))
        PI_OpenFile(smat,t,x);
    end
    return;
end
if(strcmp(action,'SpawnPlotImage'))
    PI_SpawnPlotImage;
    return
end
if(strcmp(action,'OpenFile'))
    PI_OpenFile;
    return
end
if(strcmp(action,'SaveFile'))
    PI_SaveFile;
    return
end
% the following is going to turn off position axes if it is supposed to be
% off... I just can't quickly find a better place for it
hbak=findobj(gcf,'tag','BACKING');
if(~isempty(hbak))
    checkon=get(hbak,'visible');
    if(strcmp(checkon,'off'))
        set(findobj(gcf,'type','axes','tag','POSITIONAXES'),'visible','off');
        set(get(findobj(gcf,'type','axes','tag','POSITIONAXES'),'children'),'visible','off','hittest','off');
    end
end
% Alternate Button Head-off-at-the-Pass- Function
%----------------------------------------
%
% This function will head off callbacks at the pass (so to speak)
if(strcmp(action,'zoom')|strcmp(action,'pick')|strcmp(action,'PickMoveClose'))
    StopOrGo=PI_HeadOff(action);
    if(strcmp(StopOrGo,'STOP'))
        return
    end
end
if(strcmp(action,'zoom'))
    PI_zoom;
    return;
end
% Zoom Options (zoomoptions)
%--------------
%
% Allows user to set locks for zoom controls
if(strcmp(action,'zoomoptions'))
    PI_zoomoptions;
    return
end

% Zoom Srolling (zoomscroll)
%---------------
%
% This function allows user to move around a zoomed plot
if(strcmp(action,'zoomscroll'))
    PI_zoomscroll;
    return
end
if(strcmp(action,'zoominout'))
    zoominout;
end
if(strcmp(action,'zoomscrollmotion')|strcmp(action,'zoominoutmotion'))
    PI_zoomscrollmotion(action);
    return
end
if(strcmp(action,'zoomfcnend'))
    PI_zoomfcnend;
    return
end

if(strcmp(action,'flip'))
    PI_flip;
    return;
end
if(strcmp(action,'zoompick'))
    PI_zoompick;
    return;
end
if(strcmp(action,'pick'))
    PI_pick;
    return
end
% Pick Line Menu and options (picklinemenu)
%----------------------------
%
% This will allow bring up a uicontext menu where user can move or delete lines
if(strcmp(action,'picklinemenu'))
    PI_picklinemenu;
    return
end
if(strcmp(action,'LmLnActivation'))
    PI_LmLnActivation;
    return
end
if(strcmp(action,'ImportPicks'))
    PI_ImportPicks;
    return
end
if(strcmp(action,'MovePickLineStop'))
    PI_MovePickLineStop;
    return
end
if(strcmp(action,'DeletePickLine'))
    PI_DeletePickLine;
    return
end
if(strcmp(action,'MovePickLine'))
    PI_MovePickLine;
    return
end
if(strcmp(action,'MovePickLineStart'));
    PI_MovePickLineStart;
    return
end
if(strcmp(action,'MovePickLineMotion'))
    PI_MovePickLineMotion;
end
if(strcmp(action,'MovePickLineEnd'))
    PI_MovePickLineEnd;
    return
end
if(strcmp(action,'colormap'))
    PI_PlotImageColorMap;
    return
end

if(strcmp(action,'brighten'))
    PI_PlotImageBrighten;
    return;
end

if(strcmp(action,'rescale')|strcmp(action,'limboxrescale'))
    PI_rescale(action);
    return;
end

% MOVEMENT OF POINTS and LINES (limptmove) & (limlnmv)
%------------------------------
%
% This will begin the movement of the four points and corresponding on the axes
% this will also open a menu for both lines and markers that will
% allow user to change properties of the lines and markers.
if(strcmp(action,'limptmove')|strcmp(action,'limlnmove')|strcmp(action,'limcentmove'))
    PI_limptmove(action);
    return
end
if(strcmp(action,'limptmove2'))
    PI_limptmove2;
    return
end
if(strcmp(action,'limlnmove2'))
    PI_limlnmove2;
    return
end

if(strcmp(action,'limmoveend'))
    PI_limmoveend;
    return
end

% User settings for limit lines and points (limlnoptions)
%------------------------------------------
%
% This callback is where the user can specify what the look of the lines
% and markers is going to be
if(strcmp(action,'limlnoptions'))
    PI_limlnoptions;
    return
end

% Limit Box Master Control (limboxmaster)
%--------------------------
%
% This call back occures when limit box hasbeen moved allowing for new
% properties to be applied to the present figure as well as slaved figures
if(strcmp(action,'limboxmaster'))
    PI_limboxmaster;
    return
end

%---------------------------------------------
%---------------------------------------------
%  Call backs for MVLINESMEASUREMENTS figure
%---------------------------------------------
%---------------------------------------------
%
% These call backs control the small data figure that shows the positions
% of the reference lines.  Measuremen figure can only be removed my deleteing
% it due to its closefcn being set to the following call back

% Measurement figure Visiblility (limlnfigurevis)
%--------------------------------
%
% This call back is called when user tries to closes the measurement figure
% hides the measurement figure, or reopens the measurement figure
if(strcmp(action,'limlnfigurevis')|strcmp(action,'limlnfigurevis2'))
    PI_limlnfigurevis(action);
    return
end

% Reset line measurements (limptreset)
%-------------------------
%
%  Resets measurements to zero
if(strcmp(action,'lmptreset')|strcmp(action,'lmptresetmenu'))
    PI_lmptreset(action);
    return
end

% Manual Enter Measurements (lmptenter)
%---------------------------
%
% Allows user to input own numbers for measurments
if(strcmp(action,'lmptenter'))
    PI_lmptenter;
    return
end
if(strcmp(action,'ChangePropertiesEnd'))
    % untill askthings init changes, this is the only way to make this work
    PI_ChangeProperties(2);
    return
end
if(strcmp(action,'ChangePropertiesMenu'))
    PI_ChangeProperties(3);
    return
end
if(strcmp(action,'PicksOpen'))
    PI_PicksOpen;
    return
end
if(strcmp(action,'PicksSave'))
    PI_PicksSave;
    return
end
if(strcmp(action,'figuresizechange'))
    PI_FigureSizeChange;
    return
end
