function el_link
% the plan for linking curves is as follows:
% Switch to linkmode and select a line by clicking on it.
% move (with button 1) a point to lie on the second curve (to be linked with)
% and release. This code is then invoked to form the link. The first task is that
% the second curve must be identified. This requires examining all curves for those
% which come close to the release point. The second curve is the one with the closest
% point (as defined by the algorithm in closestpt.m) to the release pt. 
% A new point is added to the second curve with the same coordinates
%	as the moved point on the first curve. 
% Both points become anchors. 
% 

	% turn off the window button functions
	set(gcf,'windowbuttonupfcn','');
	set(gcf,'windowbuttonmotionfcn','');
	
	% Get the storage buckets
	h=get(gcf,'children');
	found=0;
	for k=1:length(h)
		if( strcmp(get(h(k),'type'),'uicontrol') )
			if( strcmp(get(h(k),'style'),'text') )
				if( strcmp(get(h(k),'string'),'yrag') )
					hstor=h(k);
					found=found+1;
				elseif( strcmp(get(h(k),'string'),'yrag_params') )
					hparams=h(k);
					found=found+1;
				elseif( strcmp(get(h(k),'string'),'yrag_anchors') )
					hanchors=h(k);
					found=found+1;
				elseif( strcmp(get(h(k),'string'),'yrag_undo') )
                	hundo=h(k);
                	found=found+1;
                elseif( strcmp(get(h(k),'string'),'yrag_hors') )
                	hhors=h(k);
                	found=found+1;
				end
				if( found== 5)
					break;
				end
			end
		end
	end

	dat=get(hstor,'userdata');
	% the user data of hstor is:
	% dat(1) = handle of the selected line
	% dat(2) = original linestyle
	% dat(3) = original linewidth
	% dat(4:6) = original color
	% dat(7) = handle of duplicate line
	% dat(8) = handle of the anchor line
	% dat(9:length(dat)) = (x,y)'s of the anchors of the selected line
	
	% get the axes userdata which has the information on the last point
	% moved
	stuff=get(gca,'userdata');
	
	% find the last moved point
	stuff=get(gca,'userdata');
	lit=stuff(1,1);
	it=stuff(1,2:lit+1);
	hline3=stuff(1,lit+7);
	if( hline3 )
		line_anchors=stuff(1,lit+8:length(stuff(1,:)));
		nanchors=length(line_anchors)/2;
	else
		nanchors=0;
		line_anchors=[];
	end

	%get the data from the current curve
	hline1=dat(1);
	x1=get(hline1,'xdata');
	y1=get(hline1,'ydata');
	npts1=length(x1);
	ispoly=0;
	if(x1(1)==x1(npts1) & y1(1)==y1(npts1) )
		ispoly=1;
	end
	
	% get the last moved point
	% test it for validity
	if( it>length(x1) )
		error(' please move something on primary curve, then link');
	end
	xit=x1(it);
	yit=y1(it);
	
	% search all lines for the closest one to the last moved point
	hors=get(hhors,'userdata');
	d=inf;
	for k=1:length(hors)
		if(hline1~=hors(k))
			x2=get(hors(k),'xdata');
			y2=get(hors(k),'ydata');
		
			%compute closest point
			[xpt,ypt,inode,dtest]=closestpt(x2,y2,xit(1),yit(1));
			if(dtest<d)
				d=dtest;
				kclose=k;
			end
		end
	end
	
	%recompute for the closest curve
	hline2=hors(kclose);
	if(~isempty(hline2))
		x2=get(hline2,'xdata');
		y2=get(hline2,'ydata');
		npts2=length(x2);
		[xpt,ypt,inode,d]=closestpt(x2,y2,xit(1),yit(1));
	end
	
	%test other segments of hline1 as well
	isegs=find(isnan(x1));
	
	nsegs=length(isegs)+1;
	
	if(nsegs>1)
		i1=1;
		i2=isegs(1)-1;
		dseg=inf;
		for k=1:nsegs
			%test for oncurve
			if(~between(i1,i2,it(1),2) )
				[xptsg,yptsg,inodesg,dtst]=closestpt(x1(i1:i2),y1(i1:i2),xit(1),yit(1));
				if(dtst<dseg)
					dseg=dtst;
					kclose=k;
					i1close=i1;
					i2close=i2;
					inodeseg=inodesg;
					xptseg=xptsg;
					yptseg=yptsg;
				end
			end
			if(k< nsegs)
				i1=isegs(k)+1;
				if(k<nsegs-1)
					i2=isegs(k+1)-1;
				else
					i2=length(x1);
				end
			end
		end
		%compare to the best result from the other horizons
		if( dseg< d)
			hline2=hline1;
			xpt=xptseg;
			ypt=yptseg;
			d=dseg;
			inode=inodeseg+i1close-1;
			x2=x1;
			y2=y1;
			npts2=npts1;
		end
	end
		
	% now, if d is not less than 2 times the kill radius, then we just return
	killrd=stuff(2,3);
	if(d>4*killrd)
		return;
	end
	
	% Now we make the link
	% We know the insertion point to be (xpt,ypt)
	
	% see if the point already exists in the newline (or nearly so)
	alreadythere=0;
	testdist=sqrt((x2(inode)-xpt)^2 + (y2(inode)-ypt)^2);
	if( testdist < .001*killrd )
		xpt=x2(inode);
		ypt=y2(inode);
		alreadythere=1;
	end
	
	% a special test for the case of linking two segments. If inode points to 
	% the end of a segment, then we definitly do not insert a new point
	if( hline1==hline2 )
		if( inode-1 >= 1)
			if( isnan(x1(inode-1)) )
				xpt=x1(inode);
				ypt=y1(inode);
				alreadythere=1;
			end
		end
		if( inode+1 <= npts2 )
			if( isnan(x1(inode+1)) )
				xpt=x1(inode);
				ypt=y1(inode);
				alreadythere=1;
			end
		end
	end
		
	% insert the point. We do this by honoring the coordinates of the link on
	% line 2 over those of (xit,yit)
	xit=xpt*ones(size(xit));
	yit=ypt*ones(size(xit));
	if(~alreadythere)
		x2=[x2(1:inode) xpt x2(inode+1:npts2)];
		y2=[y2(1:inode) ypt y2(inode+1:npts2)];
		npts2=length(x2);
	end


	% make the inserted point an anchor in the new line
	anchors=get(hanchors,'userdata');
	ind=find(anchors==hline2);
	nanch=anchors(ind+1);% number of current anchors
	front=anchors(1:ind);
	back=anchors(ind+2+2*nanch:length(anchors));
	anch2=anchors(ind+2:ind+1+2*nanch); %the current anchors
		
	done=0;
	if(alreadythere) % see if it already is an anchor
		ia=find(anch2(1:2:2*nanch)==xpt);
		if( length(ia)>0 )
			ia2=find(anch2(2*ia)==ypt);
			if( length(ia2)>0 )
				done=1;
			end
		end
	end

	if(~done)
		nanch=nanch+1;
		anch2=[anch2 xpt ypt];
		anchors=[front nanch anch2 back];
		set(hanchors,'userdata',anchors);
	end
			

	if(hline1==hline2)
		x1=x2;
		y1=y2;
	end

	% set xit,yit in the current line and make sure it is an anchor
	x1(it)=xit;
	y1(it)=yit;
		
	% see if it is an anchor already. It definitly is if hline1==hline2
	%if(hline1==hline2)
	%	done=1;
	%else
		done=0;
	%end
	
	if(nanchors & ~done)
		ind=find(xpt==line_anchors(1:2:2*nanchors));
		if(length(ind)>0)
			ia2=find(ypt==line_anchors(2*ind));
			if(length(ia2)>0)
					done=1;
			end
		end
	end
	
	if(~done)
			nanchors=nanchors+1;
			line_anchors=[line_anchors xpt ypt];
			% line_anchors get updated
			dat=[dat(1:8) line_anchors];
			set(hstor,'userdata',dat);
	end

	% redisplay the lines
	if(~alreadythere)
			set(hline2,'xdata',x2,'ydata',y2);% the new line
	end

	set(hline1,'xdata',x1,'ydata',y1);% the current line

	if( ispoly )
			set(dat(7),'xdata',x1(2:npts1),'ydata',y1(2:npts1));
	else
			set(dat(7),'xdata',x1,'ydata',y1);
	end
	
	
	%fart with the anchors display
	if( nanchors )
		if( dat(8) ) set(dat(8),'xdata',line_anchors(1:2:...
				2*nanchors),'ydata',line_anchors(2:2:2*nanchors));
		else
			dat(8) = line(line_anchors(1:2:2*nanchors),...
					line_anchors(2:2:2*nanchors),'color',...
					[1 0 0],'marker','o','markersize',12,...
					'linestyle','none','erasemode','xor');
			set(hstor,'userdata',dat);
		end
	end
