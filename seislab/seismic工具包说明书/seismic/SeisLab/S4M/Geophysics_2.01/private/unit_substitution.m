function uo=unit_substitution(ui)
% Function substitutes standardized set of units for input units
% e.g. K/M3 ==> kg/m3
% INPUT
% ui    string or cell with input unit
% OUTPUT
% uo    string with output unit
%             uo=unit_substitution(ui)

io={'API UNITS','API units'
    'BARNS',  'barns'
    'DEG C',  'degree C'
    'DEG F',  'degree F'
    'DEGF' ,  'degree F'
    'F'    ,  'ft'
    'FT'   ,  'ft'
    'FT/SEC', 'ft/s'
    'FT/S' ,  'ft/s'
    'F/S'  ,  'ft/s'
    'F/SEC',  'ft/s'
    'FRAC',   'fraction'
    'FRACT',  'fraction'
    'V/V'  ,  'fraction'
    'V/V_decimal', 'fraction'
    'DEC'  ,  'fraction'
    'GAPI' ,  'API units'
    'G/C3' ,  'g/cm3'
    'G/CC' ,  'g/cm3'  
    'G/CM3',  'g/cm3'
    'GM/C3' , 'g/cm3'
    'GM/CC',  'g/cm3'
    'GM/CM3', 'g/cm3'
    'IN'   ,  'inches'
    'K/M3' ,  'kg/m3'
    'KG/M3',  'kg/m3'
    'KG/M^3', 'kg/m3'
    'kg/m^3*m/s','kg/m3 x m/s'
    'M'    ,  'm'
    'MT'   ,  'm'
    'M/S'  ,  'm/s'
    'M/SEC',  'm/s'
    'MSEC' ,  'ms'
    'MV'   ,  'mV'
    'NA'   ,  'n/a'
    'OHMM' ,  'Ohm-m'
    'PERC',   '%'
    'PERCENT','%'
    'PPG'  ,  'ppg'
    'PSI'  ,  'psi'
    'S'    ,  's'
    'S/M' ,   's/m'
    'SEC' ,   's'
    'SEC/M',  's/m'
    'USEC/F',  'us/ft'
    'USEC/FT',  'us/ft'
    'US/FT',  'us/ft'
    'US/F' ,  'us/ft'
    'US/M',   'us/m'
};

idx=find(ismember(lower(io(:,  1)),  lower(ui)));
if isempty(idx)
   uo=ui;
else
   if length(idx) > 1
      io(idx,  1)'
      error(['More than one match for ',  ui])
   else
      uo=io(idx,  2);
   end
end
          
