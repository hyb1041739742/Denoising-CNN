function s_plot(seismic)
% "Quick-look" plot of seismic data. Color plot if there are more than 
% S4M.ntr_wiggle2color (usually 101) traces; otherwise wiggle trace plot
%.For more sophisticated plots use functions "s_wplot" or "s_cplot".
% Written by: E. R., August 3, 2001
% Last updated: 
%
% 	s_plot(seismic)
% INPUT
% seismic seismic structure or an array

global S4M

if isstruct(seismic)
   ntr=size(seismic.traces,2);
else
   ntr=size(seismic,2);
end

if ntr > S4M.ntr_wiggle2color
   s_cplot(seismic,{'scale','yes'})
else
   s_wplot(seismic,{'scale','yes'})
end


