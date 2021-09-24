function [refl,coeff]=ava_approximation(vp,vs,rho,angles,type)
% Compute approximate amplitude vs angle of incidence from Vp, Vs, and density;
% if these elastic parameters are vectors they must have the same length.
% Written by: E. R.: February 20, 2003
% Last updated: October 4, 2004: remove "pack" command, unnecessary code
%
%       [refl,coeff]=ava_approximation(vp,vs,rho,angles,type)
% INPUT
% vp    column vector of P-velocities
% vs    column vector of S-velocities
% rho   column vector of densities
% angles   row vector of angles of incidence (in degrees)
% type  type of approximation
%       possible values are 'Aki', 'Bortfeld', 'Shuey','Hilterman','two-term'
% OUTPUT
% refl  matrix of reflectivities; one column per angle
%       size(refl,1) = size(vp,1)-1
% coeff  coefficients of the approximation a*f1(theta)+b*f2(theta)+c*f3(theta)
%       "Hilterman" and "two-term" have only two coefficients

%rsimp=diff(simp)./(simp(1:end-1,:)+simp(2:end,:));

rvp=diff(vp)./(vp(1:end-1,:)+vp(2:end,:));
rvs=diff(vs)./(vs(1:end-1,:)+vs(2:end,:));
rrho=diff(rho)./(rho(1:end-1,:)+rho(2:end,:));

ang=pi*angles/180;

if strcmpi(type,'Bortfeld')
   aimp=rho.*vp;
   raimp=diff(aimp)./(aimp(1:end-1,:)+aimp(2:end,:));
   simp=rho.*vs;
%   r0=raimp;
   g=-2*diff(simp.*vs)./rsum(aimp.*vp);
   g1=rvp;
   refl=raimp(:,ones(size(angles))) + g*sin(ang).^2 + g1*tan(ang).^2;
   clear aimp simp rvp rvs rrho
%   pack
   coeff=[raimp,g,g1];

elseif strcmpi(type,'Shuey')
   pr=0.5*(vp.^2 - 2*vs.^2)./(vp.^2 - vs.^2);
   prb=rsum(pr);
   r0=rvp + rrho;
   erp0=rvp-2*(r0+rvp).*(1-2*prb)./(1-prb); 
   g=erp0 + diff(pr)./(1-prb).^2;
   g1=rvp;
   refl=r0(:,ones(size(angles))) + g*sin(ang).^2 + g1*(tan(ang).^2 - sin(ang).^2);
   clear rvp rvs rrho
%   pack
   coeff=[r0,g,g1];
% 
elseif strcmpi(type,'Zoeppritz')
   vp1=vp(1:end-1);
   vp2=vp(2:end);
   vs1=vs(1:end-1);
   vs2=vs(2:end);
   rho1=rho(1:end-1);
   rho2=rho(2:end);
   p_incident_ang =asin((vp1./vp1)*sin(ang));
   p_transmit_ang =asin((vp2./vp1)*sin(ang));
   s_reflect_ang =asin((vs1./vp1)*sin(ang));
   s_transmit_ang =asin((vs2./vp1)*sin(ang));
    c1=(vp1./vs1); 
    c2=(rho2./rho1).*(vs2./vs1).*(vs2./vs1).*(vp1./vp2); 
    c3=-(rho2./rho1).*(vs2./vs1).*(vp1./vs1);
    c4=-(vs1./vp1); 
    c5=-(rho2./rho1).*(vp2./vp1); 
    c6=-(rho2./rho1).*(vs2./vp1);
    %s=[p_incident_ang',p_transmit_ang',s_reflect_ang',s_transmit_ang']
    for i=1:length(vp)-1
        for j=1:length(angles)
  matrix_A=[sin(p_incident_ang(i,j)), cos(s_reflect_ang(i,j)),        (-1)*sin(p_transmit_ang(i,j)),     cos(s_transmit_ang(i,j))
           cos(p_incident_ang(i,j)), ( -1)*sin(s_reflect_ang(i,j)),    cos(p_transmit_ang(i,j)),         sin(s_transmit_ang(i,j))
           sin(2*p_incident_ang(i,j)),c1(i)*cos(2*s_reflect_ang(i,j)), c2(i)*sin(2*p_transmit_ang(i,j)),  c3(i)*cos(2*s_transmit_ang(i,j))
           cos(2*s_reflect_ang(i,j)), c4(i)*sin(2*s_reflect_ang(i,j)), c5(i)*cos(2*s_transmit_ang(i,j)),  c6(i)*sin(2*s_transmit_ang(i,j))];
    
         matrix_C=[(-1)*sin(p_incident_ang(i,j)),cos(p_incident_ang(i,j)),sin(2*p_incident_ang(i,j)),(-1)*cos(2*s_reflect_ang(i,j))];
         matrix_B=matrix_A\matrix_C';
         temp_refl(j)=real(matrix_B(1));
         
        end
        refl(i,:)=temp_refl;
        %refl
    end
    
%     %R1(i)=B(1);
    clear rvp rvs rrho
% %   pack
    coeff=[0,0,0];
   
elseif strcmpi(type,'Aki')
   r0=rvp + rrho;
   vsb=vs(1:end-1)+vs(2:end);
   vpb=vp(1:end-1)+vp(2:end);
   g=rvp - 4*(vsb./vpb).^2.*(rrho+2*rvs);
   g1=rvp;
   refl=r0(:,ones(size(angles))) + g*sin(ang).^2 + g1*(tan(ang).^2 - sin(ang).^2);
   clear rvp rvs rrho
%   pack
   coeff=[r0,g,g1];

elseif strcmpi(type,'Hilterman')
   r0=rvp + rrho;
   pr=0.5*(vp.^2 - 2*vs.^2)./(vp.^2 - vs.^2);
   prb=0.5*(pr(1:end-1)+pr(2:end));
   g=diff(pr)./(1-prb).^2;
   refl=r0*cos(ang).^2 + g*sin(ang).^2;
   clear rvp rvs rrho
%   pack
   coeff=[r0,g];

elseif strcmpi(type,'two-term')
   r0=rvp + rrho;
   pr=0.5*(vp.^2 - 2*vs.^2)./(vp.^2 - vs.^2);
   prb=0.5*(pr(1:end-1)+pr(2:end));
   g=diff(pr)./(1-prb).^2-r0;
   refl=r0 + g*sin(ang).^2;
   clear rvs rrho
%   pack
   coeff=[r0,g];

else
   error([' Unknown type of approximation: ',type])
end

