function wlog=l_elastic_impedance(wlog,varargin)
% Function computes elastic impedance log for given angles
% The program performes the following steps
% 1. Compute angle-dependent reflection coefficients for the requested angles
% 2. Compute angle-dependent impedance
% Function assumes that P-sonic (P-velocity), S-sonic (or S-velocity) and density are 
% represented by the appropriate mnemonics.
% Rewritten by: E. R., July 16, 2003
% Last updated: April 5, 2004: Remove time-conversion/interpolation step
%
%          wlog=l_elastic_impedance(wlog,varargin)
% INPUT
% wlog     log structure with at least sonic, shear, and density curves
%          if the method is 'Rueger' it also needs curves for epsilon and delta
% varagin  one or more cell arrays; the first element of each cell array is a 
%          keyword string, the following arguments contains a parameter(s). 
%          Accepted keywords are:
%      'angles'  vector of angles (in degrees). 
%                Default: {'angles',[0:10:50]}
%      'method'  Method used; possible values are 'Aki', 'Bortfeld', 
%                'Shuey','Hilterman','two-term','Rueger'
%                The case does not matter ('Aki' is equivalent to 'aki')
%                Default: {'method','Bortfeld'}
% OUTPUT
% wlog     input log structure with the elastic impedance curves appended
%          the curve mnemonics are Eimp with the angle appended (e.g. eImp30 for the 
%          elastic impedance for 30 degrees)

%       Set defaults for input parameters
param.angles=(0:10:50);
param.method='Bortfeld';

%       Decode and assign input arguments
[param,cm]=l_assign_input(param,varargin,'l_elastic_impedance');

wlog=l_seismic_acoustic(wlog,{'cm',cm});

tlog=l_seismic_elastic(wlog,{'cm',cm});

tlog=l_rm_nulls(tlog,'any');
tlog=l_interpolate(tlog);

if strcmpi(param.method,'Rueger')
   tlog=l_curve(tlog,'keep',{cm.vp,cm.vs,cm.rho,cm.aimp,cm.epsilon,cm.delta});
   refl=ava_approximation_rueger(l_gc(tlog,cm.vp),l_gc(tlog,cm.vs), ...
           l_gc(tlog,cm.rho),l_gc(tlog,cm.epsilon),l_gc(tlog,cm.delta), ...
           param.angles);
else
   tlog=l_curve(tlog,'keep',{cm.vp,cm.vs,cm.rho,cm.aimp});
   refl=ava_approximation(l_gc(tlog,cm.vp),l_gc(tlog,cm.vs), ...
           l_gc(tlog,cm.rho),param.angles,param.method);
end
%       Compute angle-dependent impedance
imp0=l_gc(tlog,cm.aimp);
imp0=imp0(1);

imp=imp0*exp(2*[zeros(1,length(param.angles));cumsum(refl)]);

%       Add curves to existing log
tlog.curves=[tlog.curves,imp];
info=cell(length(param.angles),3);
for ii=1:length(param.angles)
   mnem=['eImp',num2str(param.angles(ii))];
   wlog=l_curve(wlog,'delete_ne',mnem);
   info(ii,:)={mnem,[l_gu(tlog,cm.vp),' x ',l_gu(tlog,cm.rho)], ...
      ['Elastic impedance for ',num2str(param.angles(ii)),' deg.(',param.method,')']};
   wlog=add_curve_type(wlog,{mnem,'Imp','impedance'});
end
tlog.curve_info=[tlog.curve_info;info];

wlog=l_append(wlog,l_select(tlog,[{'curves'},info(:,1)']));

