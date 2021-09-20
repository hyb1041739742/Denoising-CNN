function ier=par_check(structure)
% Check if parameter-related fields of a structure are compatible
% Written by: E. R.: September 12, 2003
% Last updated:
%
%       ier=par_check(structure)
% INPUT
% structure   structure whose parameter fields need to be tested
% OUTPUT
% ier    logical variable; error if ier == logical(1)

global S4M

ier=logical(0);

%       Check parameters (if there are any)
if isfield(structure,'parameter_info')
   fields=fieldnames(structure);
   if ~iscell(structure.parameter_info)
      disp(' Field parameter_info" must be a cell array; other errors may exist')
      ier=logical(1);
      return
   else
      [lparfields,m]=size(structure.parameter_info);
      if m ~= 3
         disp(' Field "parameter_info" is not a cell array with 3 columns; other errors may exist')
         ier=logical(1);
         return
      end
        %       Check for uniqueness of parameter mnmonics
      parfields=structure.parameter_info(:,1);
      if S4M.case_sensitive
         if length(unique(parfields)) ~= length(parfields)
            disp(' Case sensitive parameter mnemonics are not unique:');
            disp(cell2str(parfields,', '))
            ier=logical(1);
            return
         end
      else
         if length(unique(lower(parfields))) ~= length(parfields)
            disp(' Case insenisive parameter mnemonics are not unique:');
            disp(cell2str(parfields,', '))
            ier=logical(1);
            return
         end
      end

      index=ismember(parfields,fields);
      if ~all(index)
         disp(' Field "parameter_info" provides information about the following parameter(s)')
         disp('      that is/are not present in the structure:')
         disp(['      "',cell2str(parfields(~index),'", "'),'"'])
         ier=logical(1);
      end

      for ii=1:lparfields*3
         if ~ischar(structure.parameter_info{ii})
            disp(' Elements of field "parameter_info" are not strings')
            ier=logical(1);
            break
         end
      end
   end  
end

