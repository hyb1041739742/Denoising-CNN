function [x,t]=shootray(v,z,p)
% SHOOTRAY: similar to RAYFAN but with less error checking (faster)
%
% [x,t]=shootray(v,z,p)
%
% SHOOTRAY shoots a single ray or fan of rays through a stratified 
% velocity model.
% It is assumed that v is a vector of interval velocities and that
% the ray goes from z(1) to z(length(z)). This routine does no error
% checking for efficiency. Be sure that v and z are both the same
% length and that p is a row vector. It returns inf if a critical 
% refration occurs. This routine will get the same results as rayfan
% but is 25% faster
%
% v... COLUMN vector of interval velocities
% z... COLUMN vector of depths to the tops of the intervals
% NOTE: v and z must be at least length 2 or an abort will occur
% p... scalar or ROW vector ray parameters (Must be a row vector.)
% x ... scalar or vector of horizontal distances
% t ... scalar or vector of traveltimes
%
% G.F. Margrave, CREWES Project, July 1995
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

%check for critical angle
iprop=1:length(z)-1;
sn = v(iprop)*p;
 %
 % sn is an n by m matrix where n is the length of iprop (the number of
 %    layers propagated through) and m is the length of p (the number of
 %    unique ray parameters to use). Each column of sn corresponds to a
 %    single ray parameter and contains the sin of the vertical angle;
 %
 
 [ichk,pchk]=find(sn>1);

 %compute x and t
 cs=sqrt(1-sn.*sn)+eps;
 vprop=v(iprop)*ones(1,length(p));
 thk=abs(diff(z))*ones(1,length(p));
 if(size(sn,1)>1)
 	x=sum( (thk.*sn)./cs);
 	t=sum(thk./(vprop.*cs));
 else
 	x=(thk.*sn)./cs;
 	t=thk./(vprop.*cs);
 end
 %assign infs
 if(~isempty(ichk))
 	x(pchk)=inf*ones(size(pchk));
	t(pchk)=inf*ones(size(pchk));
 end
