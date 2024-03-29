function [trout,tout]=resamp(trin,t,dtout,timesout,flag,fparms)
% RESAMP: resample a signal using sinc function interpolation
%
% [trout,tout]=resamp(trin,t,dtout,timesout,flag,fparms)
% [trout,tout]=resamp(trin,t,dtout,timesout,flag)
% [trout,tout]=resamp(trin,t,dtout,timesout)
% [trout,tout]=resamp(trin,t,dtout)
%
% RESAMP resamples an input time series using sinc function interpolation.
% If the output sample size is larger than the input, then an antialias filter
% will be applied which can be either zero or minimum phase.
%
%
% trin= input trace to be resampled
% t= time coordinate vector for trin
% dtout= desired output sample size (in seconds). May be any floating point 
%         number. 
% timesout = start and end time desired for the output trace: [tmin tmax]
%	If dtout does not divide evenly into this interval then the first
%	These times need not fall on the input time grid represented by t
%	sample will be at tmin while the last will be just less than tmax
%       ********* default [t(1) t(length(t))] **************
% flag= antialias filter option needed if dtout> t(2)-t(1) 
%       0 -> a zero phase antialias filter is used
%       1 -> a minimum phase antialias filter is used
%       ***************** default = 1 *****************
% fparms= 2 element vector of antialias filter parameters
%       fparms(1)= 3db down point of high frequency rolloff
%       expressed as a fraction of the new nyquist
%       fparms(2)= attenuation desired at the new Nyquist in db
% *************** default = [.6,120] *******************
%
% trout= output resampled trace
% tout= time coordinate vector for trout
%
% **** Automated Testing Routine ****
% You can now try an automated testing routine to ensure that this function
% is working properly. Invoke this test by calling resamp as follows:
%
% [failures, total] = resamp('selftest')
%
% Where 'failures' is the number of failed tests out of the 'total' number.
%
% It is currently incomplete. If it fails, it is likely to have some
% sort of problem. If it succeeds, it probably doesn't have egregious
% problems, but it may have some subtle flaws still.
% ***********************************
%
% by G.F. Margrave, November 1991, modifications Chad Hogan, April 2004
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

% $Id: resamp.m,v 1.3 2004/07/30 21:23:38 kwhall Exp $

% This triggers the testing suite.
% We'll hijack the output vars to return those results. TEST_resamp lives
% in the private directory.
if((nargin == 1) && (strcmp(trin, 'selftest')))
     [trout, tout] = TEST_resamp;
     return;
 end

 if nargin<6, fparms=[.6,120]; end
 if nargin<5, flag=1; end
 if nargin<4 timesout=[t(1) t(length(t))]; end
 
 % convert everything to a row vector
 [rr,cc]=size(trin);
 trflag=0;
 if( rr > 1)
	 trin=trin';
	 t=t';
	 trflag=1;
	end
% design and apply antialias filter
% Must be careful to apply this only to live samples
 dtin=t(2)-t(1);
% build output time vector 
 tout=timesout(1):dtout:timesout(2);

 % find live samples
ilive=find(~isnan(trin));

%check for completely dead trace
	if(isempty(ilive))
		trout=nan*ones(size(tout));
		return;
	end
		
 if dtout>dtin
	% divide up into zones based on nan's
	  ind=find(diff(ilive)>1);
	  zone_beg=[ilive(1) ilive(ind+1)];
	  zone_end=[ilive(ind) ilive(length(ilive))];
	  nzones=length(zone_beg);
	  trinf=nan*ones(size(trin));
		fnyqnew= .5/dtout;
		fmax=[fparms(1)*fnyqnew,fnyqnew*(1-fparms(1))*.3];
	  for k=1:nzones 
		% get whats in this zone
		n1=round((t(zone_beg(k))-t(1))/dtin)+1;
		n2=round((t(zone_end(k))-t(1))/dtin)+1;
		trinzone=trin(n1:n2);
        
        % This was commented out. I'm not sure why, but I'm afraid it may
        % be some kind of subtle bug that somebody already discovered and
        % fixed. My testing suggests it works quite nicely though.
		tzone=t(n1:n2);
        % Then use this "tzone" in the call to filtf instead of just t. If
        % you don't do it this way, if you have multiple zones in the trace
        % that are not the full length of the original trace, then you end
        % up feeding filtf a trace that is not the same length as the time
        % vector t. It gets really confused and ends up dying. 
        % So I'll put it here for now, but if resamp starts failing for
        % some weird reason, it's probably because of this.
        %
        % Chad Hogan 2004. 
        
		tm=mean(trinzone);
        %		trinzone=filtf(trinzone-tm,t,[0,0],fmax,flag,fparms(2));
        trinzone=filtf(trinzone-tm,tzone,[0,0],fmax,flag,fparms(2));
		trin(n1:n2)=trinzone+tm;
	  end
 end
% resample with sinc interpolation
 trout=sincinan(trin,t,tout);

 if(rr>1)
		[rr,cc]=size(trout);
		if( rr== 1)
			trout=trout.';
			tout=tout.';
		end
	end
