function info=info4time(seismic)
% Create a standard cell vector with info about the time axis of the seismic
% Written by: E. R.: September 14, 2003
% Last updated: January 18, 2005: Add axis description for histograms
%
%          info=info4time(seismic)
% INPUT
% seismic  seismic data set
% OUTPUT
% info     hree-element cell array with mnemonic, units of measurement and description
%          for time axis

info=cell(1,3);
info{2}=seismic.units;

if sum(ismember({'ms','msec','s','sec'},lower(seismic.units)))
   info{1}='time';
   info{3}='Time';

elseif sum(ismember({'hz','khz'},lower(seismic.units)))
   info{1}='frequency';
   info{3}='Frequency';

elseif sum(ismember({'ft','m'},lower(seismic.units)))
   info{1}='depth';
   info{3}='Depth';

elseif strcmpi('samples',seismic.units)
   info{1}='samples';
   info{2}='';
   info{3}='Samples';

elseif strcmpi('histogram',seismic.tag)
   if strcmpi(seismic.binsize,'equal')
      info{1}='amplitude';
      info{2}='';
      info{3}='Binned amplitude';
   else
      info{1}='binindex';
      info{2}='unequal bins';
      info{3}='Bin index';
   end
 
end 

