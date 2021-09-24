function sgray(alpha)
%SGRAY: Non-linear transformation of a color gray colormap.
%  Same effect as clipping.
%
%  sgray(alpha)
%
%  IN:   alpha: degree of clustering of B&W (try 5)
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%


i0=32;
i = 1:64;
t = (atan((i-i0)/alpha))';
s = t(64);
t = (t - min(t))*1./(max(t) -min(t));


m(1:64,2) = 1-t;
m(:,1) = 1-t;
m(:,3) =1-t;
colormap(m);
