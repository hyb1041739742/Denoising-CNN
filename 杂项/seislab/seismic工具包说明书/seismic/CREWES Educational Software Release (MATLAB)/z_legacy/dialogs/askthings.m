function askthings(action)

% ASKTHINGS is a dialog that allows a program to ask any number of questions
% that can be answered with strings. (If numeric answers are desired, then
% the user must read the numbers from the returned strings.) For a more complete
% description, see ASKTHINGSINIT. The dialog
% is begun by calling askthingsinit and terminated by calling askthingsfini.
% ASKTHINGSINIT takes 2 arguments, the first being a string containing a
% valid MATLAB command to be executed when the dialog is completed and the
% second being a matrix of strings containing the questions to be asked.
% There should be one and only one question per row of the question matrix.
% If questions are of unequal length they can be padded with blanks or 1's.
% (At least one question is mandatory.) When the dialog is completed,
% askthingsfini is called to obtain the answer strings. These are a matrix
% of strings in the same sense as the question matrix containing the answers
% to the questions. As an example, here is a program which asks the users
% name and age and prints them out:
%
%function ask(action)
%
%if(nargin<1)
%        action='init';
%end
%
%if(strcmp(action,'init'))
%		q=ones(2,50);
%		q1='Whats your name';
%		q2='How old are you (in seconds!)';
%		q(1,1:length(q1))=q1;
%		q(2,1:length(q2))=q2;
%        askthingsinit('ask(''done'')',q);
%        return;
%end
%
%if(strcmp(action,'done'))
%        a=askthingsfini;
%        age=sscanf(a(2,:),'%f');
%		 ind=find(a(1,:)==1);
%		 if( ~isempty(ind) )
%		 	name=a(1,1:ind(1)-1);
%		 end
%
%        disp(['Hello ' name]);
%        disp(['The square root of your age is ' num2str(sqrt(age))]);
%        
%        return;
%end
% 
% To execute this program just copy it into a file called ask.m and type ask.
%
% For more info see help for ASKTHINGSINIT and ASKTHINGSFINI
%
% by G.F. Margrave, January 1994
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

if(strcmp(action,'init') )
		hax=gca;
		hmasterfig=gcf;
        dat=get(hax,'userdata');
        % decode dat and build the various matricies
			 iend=find(isnan(dat));
			 if( isempty(iend) )
				iend=length(dat);
			 else
				iend=iend-1;
			 end
        nq=dat(1);
        c=dat(2);
        ca=dat(3);
        ct=dat(4);
        qs=dat(5:4+nq*c);
        qs=setstr(reshape(qs',nq,c));
        a=dat(5+nq*c:4+nq*c+nq*ca);
        a=setstr(reshape(a',nq,ca));
        ttstr=dat(5+nq*c+nq*ca:4+nq*c+nq*ca+nq*ct);
        ttstr=setstr(reshape(ttstr',nq,ct));
        flags=dat(5+nq*c+nq*ca+nq*ct:4+nq*c+nq*ca+nq*ct+nq);
        transfer=dat(5+nq*c+nq*ca+nq*ct+nq:iend);
			 if( iend < length(dat) )
				titlestr=setstr(dat(iend+2:length(dat)));
			 else
				titlestr='Please supply this information:';
			 end
        blanks=setstr(32*ones(1,ca));

			 bgkol=[0 1 1];
        
        [nq,c]=size(qs);
        % find the maximum question or answer length
        qlen=0;
        for k=1:nq
        	ind=find(qs(k,:)==1);
        	if( isempty(ind) )
        		len=c;
        	else
        		len=ind(1)-1;
        	end
        	if(len>qlen)
        		qlen=len;
        	end
				aa=strunpad(a(k,:));
				if( ~isempty(aa) )
					ind=find(aa=='|');
				else
					ind=[];
				end
				if( isempty(ind) )
					aa=deblank(aa);
					len=length(aa);
				else
					aa=vec2strmat(aa);
					[r,len]=size(aa);
					len=len+1;
				end
				alen=len;
% 				if(len>qlen)
% 					qlen=len;
% 				end

        end
        		
        %build the dialog box and the questions
        hdial=figure('visible','off','menubar','none','numbertitle','off',...
            'name','Question(s)');
        pos=get(hdial,'position');
        sep=1;
        %
        % assume 10 chars in 50 pixels
        %
        qwidth=50*ceil(qlen/10);
        awidth=max([50*ceil(alen/10) 100]);
        width=mean([qwidth awidth]);
        % compute height of title string (allow long strings to wrap)
        titlen=50*ceil(length(titlestr)/9);
        factor=ceil(titlen/(2*(width+sep)));
        height=20;
        titheight=factor*height;
        figheight=(height+sep)*(nq+1+factor);
        figwidth=2*(width+sep);
        ynow=figheight-titheight;
        xnow=sep;
        hmsg=uicontrol('style','text','string',titlestr,...
        	'position',[xnow ynow figwidth titheight],...
				'foregroundcolor','r');
        hq=zeros(1,nq);ha=zeros(1,nq);
				ynow=ynow-sep-height;

        for k=1:nq
        	q=strunpad(qs(k,:));
        	tt=strunpad(ttstr(k,:));
        	if(isempty(tt))
            	hq(k)=uicontrol('style','text','string',q,'position',...
            		[xnow,ynow,qwidth,height]);
            else
                hq(k)=uicontrol('style','text','string',q,'position',...
            		[xnow,ynow,qwidth,height],'tooltipstring',tt);
            end
        	xnow=xnow+qwidth+sep;
				ind=findstr(a(k,:),'|');
        	%if(strcmp(blanks,a(k,:)))
        	
        	if( isempty(ind) )
					if(flags(k))
						ha(k)=uicontrol('style','edit','string',...
							strunpad(a(k,:)),...
							'position',[xnow,ynow,awidth,height],...
							'backgroundcolor',bgkol);
					else
						ha(k)=uicontrol('style','edit','string',...
							strunpad(a(k,:)),...
							'position',[xnow,ynow,awidth,height]);
					end
        	else
        		ind=find(abs(a(k,:))==1);
        		if( isempty(ind) ) ind=length(a(k,:))+1; end
					if(flags(k)<1) flags(k)=1; end
        		ha(k)=uicontrol('style','popupmenu','string',...
						strunpad(a(k,:)),'horizontalalignment','center',...
        			'position',[xnow,ynow,awidth,height],'value',flags(k));
        	end
        	xnow=sep;
        	ynow=ynow-sep-height;
        end
        
        hdone=uicontrol('style','pushbutton','string','Done','position',...
        	[xnow ynow width height],'callback','askthings(''done'')',...
				'foregroundcolor','r');
        
			 xnow=xnow+width+sep;
        hcancel=uicontrol('style','pushbutton','string','Cancel','position',...
        	[xnow ynow width height],'callback','askthings(''done'')');

	% get the position of the calling figure
	hparent=get(hax,'parent');
	pospar=get(hparent,'position');
    %unitspar=get(hparent,'units');

	px=pospar(1)+pospar(3)/2-figwidth/2;
	py=pospar(2)+pospar(4)/2-figheight/2;
    posdial=[px py figwidth figheight];

        set(hdial,'position',posdial);
        set(hdial,'visible','on');
        
        ind=find(transfer==1);
        if( ~isempty(ind) )
        	transfer=transfer(1:ind(1)-1);
        end
        
        hstore=uicontrol('style','text','visible','off','userdata',...
        	[hax abs(transfer)]);
        hans=uicontrol('style','text','visible','off','userdata',a);
        	
         
        set(hdial,'userdata',[ha flags hstore hmsg hans hmasterfig]);
        
        return;
        
end
if(strcmp(action,'done'))
			% see if cancel was pushed
			hbutton=gco;
			buttonlabel=get(hbutton,'string');
		  	dat=get(gcf,'userdata');
			nq=(length(dat)-4)/2;
			hmasterfig=dat(length(dat));

			if(strcmp(buttonlabel,'Cancel'))
				as=-1;

			else

			  % get the answers and put them in gca userdata
				ha=dat(1:nq);
				hans=dat(2*nq+3);
				answers=get(hans,'userdata');
				flags=dat(nq+1:2*nq);
			  as=[];
			  for k=1:nq
			  		style=get(ha(k),'style');
			  		if(strcmp(style,'edit'))
						a=get(ha(k),'string');
						%remove all trailing and leading blanks
						if(~isempty(a))
							iii=find(abs(a)~=32);
							if( isempty(iii) )
								a=[];
							else
								ib=find(abs(a)==32);
								ib2=find(ib<iii(1));
								if( ~isempty(a) )
									a(ib(ib2))=[];
									iii=find(abs(a)~=32);
									ib=find(abs(a)==32);
									ib2=find(ib>iii(length(iii)));
									if( ~isempty(a) )
										a(ib(ib2))=[];
									end
								end
							end
						end
					else
						v=get(ha(k),'value');
						% determine the actual string for a
						bdy=abs('|');
						ind=find(answers(k,:)==bdy);
						if( isempty(ind) )
							ind=length(answers(k,:))+1;
						end
						if(v==1)
							i1=1; i2=ind(1)-1;
						elseif(v==length(ind)+1)
							i1=ind(v-1)+1; i2=length(answers(k,:));
						else
							i1=ind(v-1)+1; i2=ind(v)-1;
						end
						a=answers(k,i1:i2);
					end
					if( isempty(a) & flags(k)==1 )
						hmsg=dat(2*nq+2);
						set(hmsg,'string','Please answer blue questions or cancel');
						set(hmsg,'backgroundcolor','r','foreground','y');
						return;
					elseif( isempty(a) & flags(k)==0 )
						a=' ';
					end
					as=[as a char(255)];
			  end
			end
        
			  hstore=dat(2*nq+1);
			  dat=get(hstore,'userdata');
			  set(dat(1),'userdata',as); %break
			  % set(dat(1),'userdata',[as gcf]); %fix
			  
        
        close(gcf); %break
        % set(gcf,'visible','off'); %fix
        
        % call the transfer expression
        transfer=setstr(dat(2:length(dat)));

		
		figure(hmasterfig);
        
        eval(transfer);
        
        return;
        	
end
