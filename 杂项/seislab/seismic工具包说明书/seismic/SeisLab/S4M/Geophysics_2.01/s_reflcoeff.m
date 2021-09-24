function refl=s_reflcoeff(impedance)
% Function computes reflection coefficients from impedance
% Start time and sample interval of the output reflection coefficients are those
% of the impedance
% Written by: E. R.: April 9, 2000
% Last update: December 17, 2003: add fields "type","tag",and "name"
%
%             refl=s_reflcoeff(impedance)
% INPUT 
% impedance   Impedance in form of a seismic structure
% OUTPUT
% refl        Refledction coefficient sequence
%                     refl=s_reflcoeff(impedance)

refl=impedance;
refl.tag='reflectivity';
refl.name=['Reflectivity (',impedance.name,')'];
refl.last=impedance.last-impedance.step;
refl.traces=diff(impedance.traces)./(impedance.traces(1:end-1,:)+impedance.traces(2:end,:));

%	Check for NaNs
index=find(isnan(refl.traces));
if ~isempty(index)
   refl.null=NaN;
end

%    Append history field
if isfield(impedance,'history')
   htext='';
   refl=s_history(refl,'append',htext);
end


