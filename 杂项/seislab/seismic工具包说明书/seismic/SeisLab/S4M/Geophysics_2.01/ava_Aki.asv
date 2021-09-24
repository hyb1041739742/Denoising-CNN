function [refl,coeff]=ava_Aki(vp,vs,rho,angles,type)
rvp=diff(vp)./(vp(1:end-1,:)+vp(2:end,:));
rvs=diff(vs)./(vs(1:end-1,:)+vs(2:end,:));
rrho=diff(rho)./(rho(1:end-1,:)+rho(2:end,:));
ang=pi*angles/180;

   r0=rvp + rrho;
   vsb=vs(1:end-1)+vs(2:end);
   vpb=vp(1:end-1)+vp(2:end);
   g=rvp - 4*(vsb./vpb).^2.*(rrho+2*rvs);
   g1=rvp;
   refl=r0(:,ones(size(angles))) + g*sin(ang).^2 + g1*(tan(ang).^2 - sin(ang).^2);
   clear rvp rvs rrho
 
   coeff=[r0,g,g1];