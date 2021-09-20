function [D_out] = cvnmo(D_in,offset,dt,v,conj);  
%CVNMO: Apply constant velocity NMO and NMO^{-1} correction. 
%
%  [D_out] = cvnmo(D_in,offset,dt,v,conj)
%
%  IN   D_in:   data to NMO or un-NMO
%       offset: source-receicer distance in meters
%       dt:     sampling in secs
%       v:      velocity in m/sec 
%       conj:   flag to    NMO conj=1
%       conj:   flag to un-NMO conj=-1
%
%  OUT  D_out: output data after NMO or un-NMO
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%


 [nt,nh]=size(D_in);
 D_out=zeros(nt,nh);

 R = 8;

 T0 = ([1:1:nt*R]-1)*dt/R;

 for k=1:nh

  temp = interp(D_in(:,k),R);

  d=sqrt( T0.^2+(offset(k)/v)^2);

  nn=floor(d/(dt*R))+1; 

 if conj == 1;   
  for kk=1:nt*R
   if nn(kk)<R*nt; D_out(nn(kk)/R,k) = temp(nn(kk),1);end;
  end
  end
if conj ==-1;   
  for kk=1:nt*R
   if nn(kk)<R*nt; D_out(nn(kk)/R,k) = temp(n(kk),1);end;
  end
 end
 end

 
return
