function bgGray
% Crate a gray axis backgrond; if S4M.invert_hardcopy is 'off' this 
% background is retained for printing

set(gca,'Color',[0.9,0.9,0.9])
set(gcf,'Color','w')
% set(gcf,'InvertHardcopy',S4M.invert_hardcopy)
