function coef=zoeppritz(rho1,a1,b1,rho2,a2,b2,incwav,irfwav,ipol,anginc)		
%
% coef=zoeppritz(rho1,a1,b1,rho2,a2,b2,incwav,irfwav,ipol,anginc)
%
% This function computes the particle displacement reflection and
% transmission coefficients (the relative displacement amplitudes)
% for a solid-solid interface, a liquid-solid interface,
% a solid-liquid interface, and a liquid-liquid interface.
% The medium on each side of a given interface is perfectly elastic.
% The output is the value of a single reflection or transmission
% coefficient, specified by the user (see input parameters).
% This function was translated from FORTRAN originally written by
% Ed Krebes (Date: October 6, 1991).
% Translated by G.F. Margrave July 1995
%
% rho1   = Density in the incidence medium.
% a1     = P wave speed in the incidence medium.
% b1     = S wave speed in the incidence medium. 
% rho2   = Density in the transmission medium.
% a2     = P wave speed in the transmission medium.
% b2   = S wave speed in the transmission medium. 
% incwav = incwav = 1 for an incident P wave.
%          incwav = 2 for an incident S wave
% irfwav = irfwav = 1 for a reflected P wave.
%          irfwav = 2 for a reflected S wave.
%          irfwav = 3 for a transmitted P wave.
%          irfwav = 4 for a transmitted S wave.
% ipol   = If ipol = 1, the reflection or transmission
%          coefficient "coef" (see below) is returned as output
%          in polar form, i.e., the real part of "coef" is the
%          amplitude (i.e., magnitude) of the complex coefficient
%          and the imaginary part of "coef" is the phase angle
%          of the coefficient in radians. If ipol .ne. 1, then
%          the coefficient is returned in rectangular form, i.e.,
%          the real and imaginary parts of "coef" are the real
%          and imaginary parts of the coefficient.
% NOTE   : If ipol = 1, the phase is computed with the Fortran 
%	   built-in function "atan2", which ensures that the 
%	   correct branch of the arctangent function is used, i.e., 
%	   that the correct phase angle between -180 and +180 deg
%          is computed. The Fortran function "atan" can give erroneous 
%	   phase angles since it only computes values on the principal 
%	   branch of the arctangent function, i.e., only values
%          between -90 and +90 deg.
% anginc = Vector of angles of incidence, in degrees.
% coef   = Vector of values of the reflection or transmission
%          coefficients corresponding to the input values of
%          incwav and irfwav. coef has one entry per element of anginc.
%          coef is a complex number, i.e., it has a magnitude and phase angle 
%          (see comments below).
%
% == If a1,a2,b1 and b2 are non-zero, a Solid-Solid interface is treated
% == If a1=a2=0, then the SH wave case is treated 
% == If b1=b2=0, then the Liquid-Liquid interface is considered 
% == If b1=0 only, the Liquid-Solid interface is treated 
% == If b2=0 only, the Solid-Liquid interface is treated 

% Comments :
% The formulas for the coefficients in the solid-solid case have been
% taken from Aki and Richards (1980), vol. 1, eq (5.39), (5.32). The
% formulas for the other three cases involving liquid layers have been
% derived by solving the corresponding equations for the boundary
% conditions (which can be obtained by appropriately reducing the
% Zoeppritz equations (5.33) in Aki and Richards).
%
% If the angle of incidence is greater than the critical angle for a
% given reflected or transmitted wave, then the cosine of the angle of
% the wave becomes purely imaginary. The sign of the cosine (positive
% or negative imaginary) is chosen postive (for positive frequencies),
% in accordance with the physicist's Fourier sign convention (used by
% Aki and Richards --- see eq. 5.46). The Fortran built-in function
% "sqrt" automatically outputs the principal value of the complex
% square root, which happens to be the positive imaginary value.
% Imaginary cosines mean that the reflection and transmission
% coefficients can be complex numbers (see "coef" above).
%                        =========
%
%
%  See comments in subroutine "rte".
%
%  Input to ed should be a file of the form:
%       rho1, a1, b1, rho2, a2, b2
%       incwav, irfwav, ipol, anginc
%                  -----
%       incwav, irfwav, ipol, anginc
%         -1  , irfwav, ipol, anginc
%
%  If ipol = 1, and phase of coef is wanted in degrees, then
%  imag(coef) must be multiplied by 180/pi.
%
%
%

rpd = pi/180.0;
%
% ======================= Solid-Solid interface ========================
if (a1&a2&b1&b2)>0
      if incwav==1
         i1 = anginc * rpd;
         p = sin(i1)/a1;
         ci1 = cos(i1);
         cj1 = sqrt(1. - (p*b1).^2);
      elseif incwav==2
         j1 = anginc * rpd;
         p = sin(j1)/b1;
         cj1 = cos(j1);
         ci1 = sqrt(1. - (p*a1).^2);
      end
%
      ci2 = sqrt(1. - (p*a2).^2);
      cj2 = sqrt(1. - (p*b2).^2);
      ca1 = ci1/a1;
      ca2 = ci2/a2;
      cb1 = cj1/b1;
      cb2 = cj2/b2;
      rb1 = rho1 * (1. - 2.*(b1*p).^2);
      rb2 = rho2 * (1. - 2.*(b2*p).^2);
      a = rb2 - rb1;
      b = rb2 + 2.*rho1*(b1*p).^2;
      c = rb1 + 2.*rho2*(b2*p).^2;
      d = 2.*(rho2*b2^2 - rho1*b1.^2);
      e = b.*ca1 + c.*ca2;
      f = b.*cb1 + c.*cb2;
      g = a - d.*ca1.*cb2;
      h = a - d.*ca2.*cb1;
      dd = e.*f + g.*h.*p.*p;
%
      if incwav==1
         if irfwav==1
            coef = ((b.*ca1 - c.*ca2).*f - (a + d.*ca1.*cb2).*h.*p.*p)./dd;
         elseif irfwav==2
            coef = -(2*ca1.*(a.*b + c.*d.*ca2.*cb2).*p.*a1)./(b1.*dd);
         elseif irfwav==3
            coef = (2*rho1.*ca1.*f.*a1)./(a2.*dd);
         elseif irfwav==4
            coef = (2*rho1.*ca1.*h.*p.*a1)./(b2.*dd);
         end
      elseif incwav==2
         if irfwav==1
            coef = -(2*cb1.*(a.*b + c.*d.*ca2.*cb2).*p.*b1)./(a1.*dd);
         elseif irfwav==2
            coef = -((b.*cb1 - c.*cb2).*e - (a + d.*ca2.*cb1).*g.*p.*p)./dd;
         elseif irfwav==3
            coef = -(2*rho1.*cb1.*g.*p.*b1)./(a2.*dd);
         elseif irfwav==4
            coef =  (2*rho1.*cb1.*e.*b1)./(b2.*dd);
         end
      end
%
      if ipol==1
         ampl = sqrt(real(coef).^2 + imag(coef).^2);
         if (coef==0.)
            phas = 0.;
         else
            phas = atan2(imag(coef), real(coef));
         end
         coef = ampl + i*phas;
      end
%
      return
	end
%
%
% =============== The case of a liquid-solid interface ====================
%
if (a1>0)&(a2>0)&(b1==0)&(b2>0)
   if incwav==1
      i1 = anginc * rpd;
      p = sin(i1)/a1;
      ci1 = cos(i1);
      ci2 = sqrt(1. - (p*a2).^2);
      cj2 = sqrt(1. - (p*b2).^2);
      c2j2 = 1. - 2.*(b2*p).^2;
      t1 = rho1*a1*ci2;
      t2 = rho2*a2*ci1.*c2j2.^2;
      t3 = 4.*rho2*b2^3*p.*p.*ci1.*ci2.*cj2;
      dd = t1 + t2 + t3;
%
      if irfwav==1
         coef = (-t1 + t2 + t3)./dd;
      elseif irfwav==2
         error('irfwav cannot equal 2, execution stopped')
      elseif irfwav==3
         coef = (2*rho1*a1*ci1.*c2j2)./dd;
      elseif irfwav==4
         coef = -(4*rho1*a1*b2*p.*ci1.*ci2)./dd;
      end
%
      if ipol==1
         ampl = sqrt(real(coef).^2 + imag(coef).^2);
         if coef==0
            phas = 0.;
         else
            phas = atan2(imag(coef), real(coef));
         end
         coef = ampl+i*phas;
      end
%  
      return
    elseif incwav==2
    error('You must have an incident P wave');
    end 
end
%
% =============== The case of a solid-liquid interface ===================
%  
if (a1>0)&(a2>0)&(b1>0)&(b2==0)
      if incwav==1
         i1 = anginc * rpd;
         p = sin(i1)/a1;
         ci1 = cos(i1);
         cj1 = sqrt(1. - (p*b1).^2);
      elseif incwav==2
         j1 = anginc * rpd;
         p = sin(j1)/b1;
         cj1 = cos(j1);
         ci1 = sqrt(1. - (p*a1).^2);
      end
%
      ci2 = sqrt(1. - (p*a2).^2);
      c1j1 = 1. - 2.*(b1*p).^2;
      t1 = rho2*a2*ci1;
      t2 = rho1*a1*ci2.*c1j1.^2;
      t3 = 4*rho1*b1^3*p.*p.*ci2.*ci1.*cj1;
      dd = t1 + t2 + t3;
%
      if incwav==1
         if irfwav==1
            coef = (t1 - t2 + t3)./dd;
         elseif irfwav==2
            coef = (4*rho1*a1*b1*p.*c1j1.*ci1.*ci2)./dd;
         elseif irfwav==3
            coef = (2*rho1*a1*c1j1.*ci1)./dd;
         elseif irfwav==4
            error('irfwav cannot equal 4, execution stopped')
         end
      elseif incwav==2
         if irfwav==1
            coef = (4*rho1*b1^2*p.*c1j1.*ci2.*cj1)./dd;
         elseif irfwav==2
            coef = (t1 + t2 - t3)./dd;
         elseif irfwav==3
            coef = -(4*rho1*b1^2*p.*ci1.*cj1)./dd;
         elseif irfwav==4
            error('irfwav cannot equal 4, execution stopped')
         end
      end
%
      if ipol==1
         ampl = sqrt(real(coef).^2 + imag(coef).^2);
         if coef==0.
            phas = 0.;
         else
            phas = atan2(imag(coef), real(coef));
         end
         coef = ampl+i*phas;
      end
%
      return
	end
%
% ================= The case of a liquid-liquid interface =================

if (a1>0)&(a2>0)&(b1==0)&(b2==0)
  if incwav==1
      i1 = anginc * rpd;
      p = sin(i1)/a1;
      ci1 = cos(i1);
      ci2 = sqrt(1. - (p*a2).^2);
      ra1 = rho1*a1*ci2;
      ra2 = rho2*a2*ci1;
      dd = ra1 + ra2;
      if irfwav==1
         coef = (ra2 - ra1)./dd;
      elseif irfwav==2
         error('irfwav cannot equal 2, execution stopped')
      elseif irfwav==3
         coef = (2*rho1*a1*ci1)./dd;
      elseif irfwav==4
         error('irfwav cannot equal 4, execution stopped')
      end
%
      if ipol==1 
         ampl = sqrt(real(coef).^2 + imag(coef).^2);
         if (coef==0.)
            phas = 0.;
         else
            phas = atan2(imag(coef), real(coef));
         end
         coef = ampl+i*phas;
      end
%
      return
   else
   error('You must have an incident P wave')
   end
end
      

%
% =============== The case of SH reflection and transmission ==============
%  
if (a1==00)&(a2==00)&(b1>0)&(b2>0)
   if incwav==2
      j1=anginc*rpd;
      p=sin(j1)/b1;
      cj1=cos(j1);
      cj2=sqrt(1-(p*b2).^2);
      rs1=rho1*b1*cj1;
      rs2=rho2*b2*cj2;
      dd=rs1+rs2;
      if irfwav==1 
         error('irfwav cannot equal 1, execution stopped')
      elseif irfwav==2
         coef=(rs1-rs2)./dd;
      elseif irfwav==3
         error('irfwav cannot equal 3, execution stopped')
      elseif irfwav==4
         coef=(2*rs1)./dd;
      end

      if ipol==1
         ampl=sqrt(real(coef).^2+imag(coef).^2);
         if coef==0
            phas=0;
         else
            phas=atan2(imag(coef),real(coef));
         end
         coef=ampl+i*phas;
      end
   elseif incwav==1
   error('You must have an incident S wave');
   end
end
