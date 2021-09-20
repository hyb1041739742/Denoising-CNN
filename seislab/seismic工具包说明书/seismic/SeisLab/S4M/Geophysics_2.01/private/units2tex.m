function uo=units2tex(ui)
% Function substitutes TeX-style units for input units for axis annotation plots
% e.g. kg/m3 ==> kg/m^3
% Written by E. R., May, 6, 2000
% Last updated:
%
%        uo=units2tex(ui)
% INPUT
% ui     string or cell with input unit
% OUTPUT
% uo     string with output unit

if strcmp(ui,'n/a')
   uo='';

else
   uo=strrep(ui,'g/cm3','g/cm^3');
   uo=strrep(uo,'kg/m3','kg/m^3');
   uo=strrep(uo,'us/ft','\mus/ft');
   uo=strrep(uo,'us/m' ,'\mus/m');
   uo=strrep(uo,'n/a' ,'');
end

