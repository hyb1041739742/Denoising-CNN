function [D_out] = cvnmo(D_in,offset,dt,v,conj);  


 [nt,nh]=size(D_in);
 D_out=zeros(nt,nh);

 t0 = 

 d=sqrt( ((n-1)*dt).^2+(offset(k)/v)^2);

 nn=floor(d/dt)+1; 
if conj == 1;   
  for kk=1:nt
   if nn(kk)<nt; D_out(n(kk),k) = D_in(nn(kk),k);end;
  end
  end
if conj ==-1;   
  for kk=1:nt
   if nn(kk)<nt; D_out(nn(kk),k) = D_in(n(kk),k);end;
  end
 end
 end

 
return
