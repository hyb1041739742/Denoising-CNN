function bool=istype(structure,typ)
% Check if structure has field "type" and that it is set to "typ"
% Written by: E. R.: September 1, 2003
% Last updated:
%
%            bool=istype(structure,typ)
% INPUT
% structure  Matlab structure
% typ        string, possible values are: 'seismic', 'well_log','table',
%                                         'pdf','model'
% OUTPUT
% bool       logical variable; set to logical(1) if "structure has field "type"
%            and if it is set to "typ"
%            otherwise it is set to logical(0)

bool=logical(0);
if isstruct(structure)
   if isfield(structure,'type')
      if strcmp(structure.type,typ)
         bool=logical(1);
      end
   end
end

