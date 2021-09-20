function zoepplot(vp,vs,rho,z,x,iref,irefwave,xflag,zave)
%
% zoepplot(vp,vs,rho,z,x,iref,irefwave,xflag,zave)
%
% ZOEPPLOT makes plots of P-P or P-S reflection amplitude versus
% offset. Raytracing is done to relate offsets to incidence angles
%
% vp = vector of p wave velocities
% vs = vector of s wave velocities
% rho = vector of densities
% z = vector of depths
% x = vector of offsets
% iref = vector of indicies of the depths for which plots will be made
% irefwave = 1 for pp
%            2 for ps
%            3 for both
% xflag = 1 plot versus offset
%         2 plot versus angle
%         3 plot versus offset/depth
% zave = at the reflection depth, the material parameters are determined
%     by averaging the values of vp, vs, and rho above and below the interface.
%     The average is taken over this distance.
% *********** default = 0 (i.e. no averaging) **************
%
% G.F. Margrave, CREWES, 2000
%

if(nargin<9)
    zave=0;
end

xcap=.5*min(diff(x));
if(isempty(xcap) | xcap==0)
	error(' bogus x values')
end

%PP section

if(irefwave~=2)
	figure;
	kols=get(gca,'colororder');
	nkols=size(kols,1);
	p=-1;
	for k=1:length(iref)
		it=iref(k);
		[t,p]=traceray_pp(vp,z,z(1),z(1),z(it),x,xcap,p);
		
		%determine incidence angles
		anginc= asin(p*vp(it-1))*180/pi;

		%depth averaging
		iup=near(z,z(it-1)-zave,z(it-1));
		vp1=mean(vp(iup));vs1=mean(vs(iup));rho1=mean(rho(iup));
		idn=near(z,z(it),z(it)+zave);
		vp2=mean(vp(idn));vs2=mean(vs(idn));rho2=mean(rho(idn));
		
		%zoeppritz
		rc=zoeppritz(rho1,vp1,vs1,rho2,vp2,vs2,1,1,0,anginc);
			
		%plot
		if(xflag==1) xx=x; elseif(xflag==2) xx=anginc; else xx=x/z(it); end
		%ikol= k - nkols*floor((k-1)/nkols);
		%line(xx,real(rc),'color',kols(ikol,:));
        h1=line(xx,real(rc),'color','b','marker','o');
		ind=find(imag(rc)~=0);
		if(~isempty(ind))
			%line(xx(ind),real(rc(ind)),'color',kols(ikol,:),...
			 %'marker','*');
             h2=line(xx(ind),imag(rc(ind)),'color','b','marker','*');
		end
	end
	%grid
	if(xflag==1)
		xlabel('offset');
    elseif(xflag==2)
		xlabel('angle');
    else
        xlabel('offset/depth')
	end
end
if(irefwave~=1)
    if(irefwave~=3)
	    figure;
    end
	kols=get(gca,'colororder');
	nkols=size(kols,1);
	p=-1;
	for k=1:length(iref)
		it=iref(k);
		[t,p]=traceray_ps(vp,z,vs,z,z(1),z(1),z(it),x,xcap,p);
		
		%determine incidence angles
		anginc= asin(p*vp(it-1))*180/pi;

		%depth averaging
		iup=near(z,z(it-1)-zave,z(it-1));
		vp1=mean(vp(iup));vs1=mean(vs(iup));rho1=mean(rho(iup));
		idn=near(z,z(it),z(it)+zave);
		vp2=mean(vp(idn));vs2=mean(vs(idn));rho2=mean(rho(idn));
		
		%zoeppritz
		rc=zoeppritz(rho1,vp1,vs1,rho2,vp2,vs2,1,2,0,anginc);
			
		%plot
		if(xflag==1) xx=x; elseif(xflag==2) xx=anginc; else xx=x/z(it); end
		%ikol= k - nkols*floor((k-1)/nkols);
		%line(xx,real(rc),'color',kols(ikol,:));
        h3=line(xx,real(rc),'color','r','marker','^');
		ind=find(imag(rc)~=0);
		if(~isempty(ind))
			%line(xx(ind),real(rc(ind)),'color',kols(ikol,:),...
			 %'marker','*');
            h4=line(xx(ind),imag(rc(ind)),'color','r','linestyle',':','marker','+'); 
		end
	end
	%grid
	if(xflag==1)
		xlabel('offset');
    elseif(xflag==2)
		xlabel('angle');
    else
        xlabel('offset/depth')
	end
end
if(irefwave==1)
    ylabel('P-P reflection coef.');
    if(exist('h2'))
        legend([h1 h2],'Real part','Imaginary part');
    end
elseif(irefwave==2)
    ylabel('P-S reflection coef.');
    if(exist('h4'))
        legend([h3 h4],'Real part','Imaginary part');
    end
elseif(irefwave==3)
    ylabel('Reflection coefficient')
    if(~exist('h2') & ~exist('h4'))
        legend([h1 h3],'P-P reflection','P-S reflection')
    elseif(exist('h2') & ~exist('h4'))
        legend([h1 h2 h3],'P-P real part','P-P imaginary part','P-S')
    elseif(exist('h4') & ~exist('h2'))
        legend([h1 h3 h4],'P-P','P-S real part','P-S imaginary part')
    else
        legend([h1 h2 h3 h4],'P-P real part','P-P imaginary part','P-S real part','P-S imaginary part')
    end
end
		
