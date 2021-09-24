function fact=plotseis(smat,t,x,vaflag,fact,clplvl,flipy,kolor,hax)
% PLOTSEIS: plot a seismic trace gather using WTVA format
%
% fact=plotseis(smat,t,x,vaflag,fact,clplvl,flipy,kolor,hax)
%
% PLOTSEIS does a quick plot of a seismic matrix in a figure window (made
% by plotseis).  It plots the columns as wiggle traces centered at their
% x coordinates.  Type plotseis with no arguments for a demo.
%
% smat ... the seismic matrix to be plotted. Traces are assumed stored in
%           the columns smat.
% t ... time coordinates of traces.
% ****** default 1:nrows where nrows = number of rows in smat
% x ... x coordinates of the traces
% ****** default 1:ncols where ncols=number of columns *****
% vaflag ... if 0, then traces are plotted as wt (wiggle traces) 
%            if 1, then the traces are plotted wtva (shaded peaks)
%            if 2 then reverve polarity wtva (shaded troughs)
%            ****** default = 1 ******
% fact ... scaling factors. Make fact(1) bigger for bigger wiggle
%          traces. fact(2) controls the overall plot scale. If not
%          provided, it is computed as max(abs(smat)). To scale two
%          plots the same, capture the return value from the first and
%          provide is as fact(2) for the second. See "scaling" below. The
%          second value of fact may also be set to one of two special negative
%          values that act as flags for special behavior. fact(2)=-1 is similar
%          defaulting fact(2) except that max(abs(smat(:))) is declared as a
%          global variable that can be used to control other plots. Setting
%          fact(2)=-2 causes a search to be made for a global variable for
%          scaling. If one is found, it is used and the resulting plot will be
%          in true scale relative to the plot that published the global. If none
%          is found, the max(abs(smat(:))) is used.
%          ****** default [1.5 max(abs(smat(:)))]******
% clplvl ... clip level specified as a number of trace spacings. Trace excursions
%	   larger than this many trace spacings get clipped.
%         *********** default =1 **********
% flipy ... if 1, then the y axis is reversed so that it goes from top
%           of window to the bottom
%	    ****** default = 1 ******
% kolor ... color to plot the traces
%           ****** default = [1 0 0] (red) *****
% hax ... handle of the axis to plot the seismic matrix in. If -1, then a 
%         new figure is created.
%         ***** default = gca *****
%
% NOTE: To scale two plots with respect to the maximum absolute value
% on the first plot, capture the return value from the first
% and provide it as the fifth argument for the second plot:
%	fact=plotseis(smat1,t1,x1);
%	plotseis(smat2,t2,x2,1,fact);
%
% Scaling: First, the entire seismic matrix is divided by fact(2). Thus, if fact(2)
%    is defaulted, the matrix is normalized to have its maximum absolute value be
%    unity. Then, for n traces, the x axis range is divided into n bins and each trace
%    is plotted within its corresponding bin. Trace excursions outside cliplvl*binwidth 
%    boundaries are clipped. Let trc be the kth trace (i.e. the kth column of smat).
%    Prior to plotting trc in the kth bin it is scaled as trc=trc*binwidth*fact(1)
%    where m=mean(trc). Thus each trace is plotted such that if an amplitude of
%    unity is encountered it causes an excursion of fact(1) binwidths.
%    So, the default for fact of [1.5 max(abs(smat(:)))] will cause the
%    maximum absolute value of smat to deflect 1.5 binwidths and so be 
%    clipped at 2/3 of its peak.
%
% G.F. Margrave, Aug 1995
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
% project may be contacted via email at:  crewesinfo@crewes.org
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

if(nargin<1)
	% do a demo
		%Make a fake reflectivity
		t=0:.002:1.0;
		r=randn(size(t)).^5;
		%make a ricker wavelet
		tw=-.1:.002:.1;
		arg=(pi*15*tw).^2;
		w=(1-2.*arg).*exp(-arg);
		%convolve
		s=conv(r,w);
		s=s(51:length(t)+50)';
		s=s/max(s); %normalize
		
		smat=s*ones(1,20);
end
if(nargin < 9)
	hax=gca;
end
if(nargin<8)
	kolor=[1 0 0];
end
if(nargin<7)
	flipy=1;
end
if(nargin<6)
	clplvl=1;
end
if(nargin<5)
	fact=1.5;
end
if(nargin<4)
	vaflag=1;
end
if(nargin<3)
	ncols=size(smat,2);
	x=1:ncols;
end
if(nargin<2)
	nrows=size(smat,1);
	t=1:nrows;
end

if(length(x)>1)
	bnds=(max(x)-min(x))/(length(x)+1);
else
	error('invalid x coordinate specification');
end

if( length(fact)<2 )
	ilive=find(~isnan(smat));
	s=max(abs(smat(ilive)));
	fact=[fact s];
end

if( fact(2) == -1)
    ilive=find(~isnan(smat));
	fact(2)=max(abs(smat(ilive)));
    global PLOTSEISFACT2
    PLOTSEISFACT2=fact(2);
end
if( fact(2) == -2)
    global PLOTSEISFACT2
    if(isempty(PLOTSEISFACT2))
        ilive=find(~isnan(smat));
	    fact(2)=max(abs(smat(ilive)));
    else
        fact(2)=PLOTSEISFACT2;
    end
end

if( hax==-1 )
	figure;
else
	hfig=get(hax,'parent');
	figure(hfig);
	set(hfig,'currentaxes',hax);
end

if(flipy)
	set(gca,'ydir','reverse');
end

for k=1:length(x)
	trc=smat(:,k)/fact(2); %normalize
	ilive=find(~isnan(trc));
	%m=mean(trc(ilive));
	%trc=(trc-m)*bnds*fact(1); %scale into x units
    trc=trc*bnds*fact(1); %scale into x units
    trc=clip(trc,clplvl*bnds)+x(k);%clip and shift
	if(~vaflag)
		line(trc(ilive),t(ilive),'color',kolor);
	elseif( vaflag==1)
		%replace NaN's with mean values
		if(length(ilive)< length(trc))
			idead=find(isnan(trc));
			trc(idead)=x(k)*ones(size(idead));
		end
		wtva(trc,t,kolor,x(k),1,1,1);
	elseif(vaflag==2)
		wtva(trc(ilive),t(ilive),kolor,x(k),-1,1,1);
	end
end

%simplezoom
%set(gcf,'name','Simple zooming installed, use MB1')
dx=abs(x(2)-x(1));
axis([min(x)-dx max(x)+dx min(t) max(t)])
%put the x axis on top
set(gca,'xaxislocation','top')
global NAME_
global NOSIG
if(isempty(NOSIG))nosig=0;else nosig=NOSIG; end
if(~nosig)
	%signature(NAME_);
end
