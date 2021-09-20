function lash=makelasheader(arg1,wellname,units,kb,topnames,...    ztops,zstart,zend,zstep,logtypes)% lash=makelasheader(uwid,wellname,units,kb,topnames,...%				ztops,zstart,zend,zstep,logtypes,nulval)%% MAKELASHEADER generates a simple LAS (Log ASCII Standard) header% and returns it in a string matrix. It is intended to be used% in conjuction with READGMA to allow a program to read in a % wellog in GMA format and write it out as LAS. Hopefully, this% will encourage the abandonment of the GMA format. NULL value is defaulted% to -999.25.%%	uwid = unique well id. Returned by READGMA as "logname"%		should be a string%	wellname = string giving the informal well name. %	units = flag indicating the units of the log 'F', 'M',%			'FT', 'S' are recognized%	kb = elevation of the kelly bushing in meters%	topnames = string matrix of topnames%	ztops = vector of tops elevations. Length should be the same%		as the number of rows in topnames%	zstart= start depth of logs%	zend= end depth of logs%	zstep= depth step of logs%	logtypes = string matrix of las log mnemonics indicating the%		logtypes. For example 'DT' or 'AU' for sonic, 'CALI' for%		caliper. Each Mnemonic must be exactly 4 chars and there must%		be one per row of logtypes. Do not include a mnemonic for the depth%		(or time) column. This is added automatically%%   alternativly, you can also create a single structure file that contains%   all the info you would like to place into your desired header%% There are no defaults for anything. Do it right or DIE!!%% G.F. Margrave%% NOTE: It is illegal for you to use this software for a purpose other% than non-profit education or research UNLESS you are employed by a CREWES% Project sponsor. By using this software, you are agreeing to the terms% detailed in this software's Matlab source file.% BEGIN TERMS OF USE LICENSE%% This SOFTWARE is maintained by the CREWES Project at the Department% of Geology and Geophysics of the University of Calgary, Calgary,% Alberta, Canada.  The copyright and ownership is jointly held by % its author (identified above) and the CREWES Project.  The CREWES % project may be contacted via email at:  crewesinfo@crewes.org% % The term 'SOFTWARE' refers to the Matlab source code, translations to% any other computer language, or object code%% Terms of use of this SOFTWARE%% 1) Use of this SOFTWARE by any for-profit commercial organization is%    expressly forbidden unless said organization is a CREWES Project%    Sponsor.%% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the %    CREWES Project Sponsorship agreement.%% 3) A student or employee of a non-profit educational institution may %    use this SOFTWARE subject to the following terms and conditions:%    - this SOFTWARE is for teaching or research purposes only.%    - this SOFTWARE may be distributed to other students or researchers %      provided that these license terms are included.%    - reselling the SOFTWARE, or including it or any portion of it, in any%      software that will be resold is expressly forbidden.%    - transfering the SOFTWARE in any form to a commercial firm or any %      other for-profit organization is expressly forbidden.%% END TERMS OF USE LICENSEnullval=-999.25;cm='Unspecified Company';fld='Unspecified Field';lc='Unspecified Location';srv='Unspecified Company';ctr='Unspecified Country';uwid=arg1;srvdate=date;if(nargin==1)    if(isstruct(uwid))    else        errorinfo={'Not enough input arguments to create LAS header',...                'See makelasheader help for more details'};        errordlg(errorinfo);        lash=[];        return    end    try        % pulling out info from the structure, it will assumed that the        % user has set it up correctly, if not.. CATCH!!        nms=fieldnames(arg1);        for ii=1:size(nms,1)            chnm=nms{ii};            chfld=getfield(arg1,chnm);            if(isnumeric(chfld))                chfld=num2str(chfld);            end            arg1=setfield(arg1,chnm,chfld);        end        % the following has to be done to eliminate the EVAL statements        % that can not be compiled        cm=getfield(arg1,'cm');        fld=getfield(arg1,'fld');        srv=getfield(arg1,'srv');        ctr=getfield(arg1,'ctr');        zstep=getfield(arg1,'zstep');        kb=getfield(arg1,'kb');        uwid=getfield(arg1,'uwid');        zstart=getfield(arg1,'zstart');        zend=getfield(arg1,'zend');        nullval=getfield(arg1,'nullval');        units=getfield(arg1,'units');        topnames=getfield(arg1,'topnames');        ztops=getfield(arg1,'ztops');        wellname=getfield(arg1,'wellname');        lc=getfield(arg1,'lc');        srvdate=getfield(arg1,'srvdate');        logtypes=getfield(arg1,'logtypes');    catch        errorinfo={'LAS Structure not in proper format.',...                'See makelasheader help for more details'};        errordlg(errorinfo);        lash=[];        return    endelseif(nargin<=11)    errorinfo={'Not enough input arguments to create LAS header',...            'See makelasheader help for more details'};    errordlg(errorinfo);    lash=[];    returnendntops=size(ztops,1);nrecs=ntops+40;ncols=80;lash=32*ones(nrecs,ncols);iline=1;rec=sprintf('~Version');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf(' VERS.                2.0 :   CWLS Log ASCII Standard -VERSION 2.0');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf(' WRAP.                 NO :   One line per depth step');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('');    % Spacing between last line and a '~' which starts a new sectionlash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('~Well Information Block');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('#MNEM.UNIT       Data                        Description of Mnemonic');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('#----.----      -------------------------- : ------------------------------');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;metric='M';if(iscell(units))    units=units{1};    units=units(1,1);endif(strcmp(units,'F')|strcmp(units,'FT'))    metric='F'endif(strcmp(units,'S'))    metric='S';endicolon=find(rec==':');rec=sprintf(['STRT.' metric '           %f'],str2num(zstart));%% eval(['rec=sprintf(''STRT.' metric '           %f'','  zstart ');']);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': First Index Value'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf(['STOP.' metric '           %f'],str2num(zend));%% eval(['rec=sprintf(''STOP.' metric '           %f'','  zend ');']);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': Last Index Value'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf(['STEP.' metric '           %f'],str2num(zstep));%% eval(['rec=sprintf(''STEP.' metric '           %f'','  zstep ');']);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': STEP'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf(['NULL.' metric '           %f'],str2num(nullval));%% eval(['rec=sprintf(''NULL.             %f'',' nullval ');']);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': NULL VALUE'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('');    lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('COMP.      %s',cm);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': COMPANY'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('WELL.      %s',wellname);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': WELL'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('FLD .      %s',fld);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': FIELD'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('LOC .      %s',lc);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': LOCATION'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('SRVC.      %s',srv);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': SERVICE COMPANY'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('DATE.      %s',srvdate);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': Service DATE'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('');    lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('UWI .      %s',uwid');rec=[rec ' '*ones(1,icolon-length(rec)-1) ': Unique Well ID'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('');    % Spacing between last line and a '~' which starts a new sectionlash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;%% parameter block%rec=sprintf('~Parameter Information Block');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('#----.----      -------------------------- : -----------------------------');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('DREF.                  KB                  : Depth Reference');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf(['EREF' metric '           %f'],str2num(kb));%% eval(['rec=sprintf(''EREF.' metric '           %f'','  kb ');']);rec=[rec ' '*ones(1,icolon-length(rec)-1) ': Elevation of Depth Reference'];lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('');    % Spacing between last line and a '~' which starts a new sectionlash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;%% tops%rec=sprintf('~Tops');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec=sprintf('#TOPS NAME   .        DEPTH:');lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;for k=1:ntops    if(iscell(topnames))        rec=[topnames{k} '   .   '];    else        rec=[strunpad(topnames(k,:)) '   .   '];    end    checktop=ztops(k,:);    if(ischar(checktop))        rec1=deblank(checktop);    else        rec1=sprintf('%f',ztops(k,:));    end    rec=[rec rec1 ' :'];    lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];    iline=iline+1;endrec=sprintf('');    % Spacing between last line and a '~' which starts a new sectionlash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;%% curve info%rec='~Curve Information Block';lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec='#MNEM.UNIT        API CODE                   Curve Description';lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;rec='#----.----      LG--CV-CL--M               : -----------------';lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;if(iscell(logtypes))    [c,nlogs]=size(logtypes);else    [nlogs,c]=size(logtypes);end%write out the depthswitch metric    case 'M'        rec=' DEPT.M          0   1  0  0               : 1 DEPTH';    case 'F'        rec=' DEPT.FT         0   1  0  0               : 1 DEPTH';    case 'S'        rec=' ETIM.S          0   1  0  0               : 1 TIME';endlash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];iline=iline+1;for k=1:nlogs    if(iscell(logtypes))        mnem=logtypes{k};    else        mnem=logtypes(k,:);    end    flag=las2logtype(mnem);    if(flag==0)        switch metric            case 'M'                rec=sprintf(...                    ' AU  .US/M      60 520 32  1               : %d SONIC',k+1);            case 'F'                rec=sprintf(...                    ' AU  .US/F      60 520 32  1               : %d SONIC',k+1);            case 'S'                rec=sprintf(...                    ' AU  .US/S      60 520 32  1               : %d SONIC',k+1);        end    elseif( flag==1 )        if( metric )            rec=sprintf(...                ' RHOB.K/M3                                 : %d bulk density'...                ,k+1);        else            rec=sprintf(...                ' RHOB.L/F3                                 : %d bulk density'...                ,k+1);        end    elseif( flag==2)        if( metric )            rec=sprintf(...                ' RHGF.K/M3                                 : %d form density'...                ,k+1);        else            rec=sprintf(...                ' RHGF.L/F3                                 : %d form density'...                ,k+1);        end    elseif( flag==3)        if( metric )            rec=sprintf(...                ' RHGA.K/M3                                 : %d app. density'...                ,k+1);        else            rec=sprintf(...                ' RHGA.L/F3                                 : %d app. density'...                ,k+1);        end    elseif( flag==4)        rec=sprintf(...            ' GR  .GAPI                                 : %d gamm ray'...            ,k+1);    elseif( flag==5)        rec=sprintf(...            ' SP  .MV                                   : %d spon. pot.'...            ,k+1);    elseif( flag==7)        if( metric )            rec=sprintf(...                ' CALI.MM                                   : %d caliper'...                ,k+1);        else            rec=sprintf(...                ' CALI.IN                                   : %d caliper'...                ,k+1);        end        switch metric            case 'M'                rec=sprintf(...                    ' SSON.US/M                                 : %d S Wave SONIC',k+1);            case 'F'                rec=sprintf(...                    ' SSON.US/F                                 : %d S Wave SONIC',k+1);            case 'S'                rec=sprintf(...                    ' SSON.US/S                                 : %d S Wave SONIC',k+1);        end    elseif(flag==27)        % this one may not be standard at this point        switch metric            case 'M'                rec=sprintf(...                    ' VS  .M/S                                  : %d VS',k+1);            case 'F'                rec=sprintf(...                    ' AU  .F/S                                  : %d VS',k+1);        end    elseif(flag==28)        % this one may not be standard at this point        switch metric            case 'M'                rec=sprintf(...                    ' VS  .M/S                                  : %d VP',k+1);            case 'F'                rec=sprintf(...                    ' AU  .F/S                                  : %d VP',k+1);        end    else        rec=sprintf(...            [' ' mnem '.????                                 : %d unknown']...            ,k+1);    end    lash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];    iline=iline+1;    end%% the last line%if( metric >= 0)    rec='~Asc Depth';else    rec='~Asc Time';endfor k=1:nlogs    if(iscell(logtypes))        mnem=logtypes{k};    else        mnem=logtypes(k,:);    end    rec=sprintf([rec '  %s  '],mnem);endlash(iline,:)=[rec lash(iline,length(rec)+1:ncols)];lash=lash(1:iline,:);lash=char(lash);
