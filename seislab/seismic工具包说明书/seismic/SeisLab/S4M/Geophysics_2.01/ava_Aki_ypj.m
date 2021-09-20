function [refl]=ava_Aki_ypj(rvp,rvs,rrho,angles,type)
ang=pi*angles/180;
strcmpi(type,'Aki')
   r0=rvp + rrho;
   g=rvp - 4*(1/2).^2.*(rrho+2*rvs);
   g1=rvp;
   refl=r0(:,ones(size(angles))) + g*sin(ang).^2 + g1*(tan(ang).^2 - sin(ang).^2);
   
 
