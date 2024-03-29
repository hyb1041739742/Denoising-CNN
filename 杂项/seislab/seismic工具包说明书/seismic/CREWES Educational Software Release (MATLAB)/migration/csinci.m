function trout=csinci(trin,t,tout,sizetable)
% CSINCI: complex valued sinc function interpolation
%
%  trout=csinci(trin,t,tout,sizetable)
%
% CSINCI performs 8 point sinc function interpolation using a 
% design for the approximate sinc function due to Dave Hale. It
% is similar to sinci except the designed sinc function is complex,
% having phase terms that are appropriate for the interpolation
% of a complex spectrum which is the transform of a time domain
% function extending from 0 to tmax. Using sinci instead will create
% unacceptable spectral artifacts.
%
% trin= input trace
% t= time coordinate vector for trin. Trin must be regularly
%    sampled. CSINCI uses only the first two points in t.
% tout= vector of times for which interpolated amplitudes are
%       desired
% trout= output trace. Contains the length(tout) interpolated 
%        amplitudes.
% sizetable= size of the sinc function table: [npts,nfuncs]
%     where npts = number of points on the sinc function and
%     nfuncs = number of uniquely optimized sinc functions. If dt is
%	  the input sample interval, then there will be a unique, optimized
%	  sinc function designed for interpolation every nfuncs'th of 
%	  dt.
%   ************* default = [8 25] *********
%
% by G.F. Margrave, CREWES Project, U of Calgary, 1996
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

trflag=[];
%time=clock;
if nargin<4, sizetable=[8,25];end

global CSINC_TABLE

% see if table needs to be made
maketable=0;
[lsinc,ntable]=size(CSINC_TABLE);
if( lsinc*ntable==0)
	maketable=1;
elseif( lsinc~=sizetable(1) | ntable~=sizetable(2) )
	maketable=1;
end
	

%convert to row vector
[rr,cc]=size(trin);
if(rr>1)
		trin=trin';
		t=t';
		tout=tout';
		trflag=1;
end

% initialize trout
trout=zeros(size(tout));

if(maketable)
		% Make the sinc function table
		 lsinc=sizetable(1);
		 ntable=sizetable(2);
		% lsinc should be an even integer
			frac=[0:ntable-1]/ntable;
		 CSINC_TABLE=zeros(lsinc,ntable)+i*zeros(lsinc,ntable);
		 jmax=fix(ntable/2)+1;
		% the first half of the table is computed by least squares
		% while the second half is derived from the first by symmetry
			for j=1:jmax
					fmax=min([.066+.265*log(lsinc),1.0]);
					a=sinque(fmax*[0:lsinc-1]);
					b=fmax*([lsinc/2-1:-1:-lsinc/2]+frac(j)*ones(1,lsinc));
					c=sinque(b);
		  			 CSINC_TABLE(:,j)=toeplitz(a',a)\c';
		  			 CSINC_TABLE(:,j)=CSINC_TABLE(:,j).*...
		  			 	(exp(i*pi*([lsinc/2-1:-1:-lsinc/2]+frac(j))).');
		%
		% for an 8 pt sinc, let del=frac(j), then the phase term is
		% exp(-i*pi*([3 2 1 0 1 2 3 4]+del))
		%
		  	end
		  point=lsinc/2;
		  jtable=ntable;ktable=2;
		  while CSINC_TABLE(point,jtable)==0.0
						CSINC_TABLE(:,jtable)=flipud(conj(CSINC_TABLE(:,ktable)));
						jtable=jtable-1;ktable=ktable+1;
		  end
end

% now interpolate with the tabulated coefficients
% first extrapolate with constant end values
% for beginning:
  ii=find(tout<=t(1));
  if length(ii)>0
    trout(ii)=trin(1)*ones(1,length(ii));
		end
% for end:
  ii=find(tout>=t(length(t)));
  if length(ii)>0
    trout(ii)=trin(length(trin))*ones(1,length(ii));
  end
% intermediate samples
  dtin=t(2)-t(1);
  ii=find((tout>t(1))&(tout<t(length(t))));
% changed the following on 8 October 93
% pdata=(tout(ii)-tout(1))/dtin+1;
  pdata=(tout(ii)-t(1))/dtin+1;
  del=pdata-fix(pdata);
% del now contains the fractional sample increment
% for each interpolation site
% compute row number in interpolation table
  ptable=1+round(ntable*del); 
% compute pointer to input  data
  pdata=fix(pdata)+lsinc/2-1;
% pad input data with end values
  trin=[trin(1)*ones(1,lsinc/2-1) trin trin(length(trin))*ones(1,lsinc/2)];
  ij=find(ptable==ntable+1);
  ptable(ij)=1*ones(1,length(ij));
  pdata(ij)=pdata(ij)+1;
% finally interpolate by a vector dot product
%  trout(ii)=trin(pdata-lsinc/2+1:pdata+lsinc/2)*CSINC_TABLE(:,ptable); % why doesn't % this work just as well as the following loop????

  for k=1:length(ii)
				trout(ii(k))=trin(pdata(k)-lsinc/2+1:pdata(k)+lsinc/2)*CSINC_TABLE(:,ptable(k));
  end

 if(trflag)
		trout=trout';
 end
%etime(clock,time)
