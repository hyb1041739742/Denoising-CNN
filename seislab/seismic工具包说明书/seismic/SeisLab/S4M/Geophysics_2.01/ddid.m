function ddid
%	Display Distribution ID

global S4M

if isempty(S4M)
   presets
end

disp(['Distribution ID: ',num2str(S4M.dd)])
