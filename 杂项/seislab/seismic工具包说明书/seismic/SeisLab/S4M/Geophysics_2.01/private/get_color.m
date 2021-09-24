function col=get_color(index,colors)
% Function gets the color symbol associated with index "index"
% Colors are ['r';'g';'b';'k';'y';'c';'m']
% For index > 7 the colors are repeated, but with dashes, then with dots;
% thereafter the process repeats itself (ge_color(22) is 'r' again
% Written by: E. R.:
% Last updated: April 2, 2004: use dots in addition to dashes
%
%         col=get_color(index,colors)
% INPUT
% index   index for which color symbol is requested
% colors  optional sequence of colors; 
%         Default: colors={'r','g','b','k','y','c','m', ...
%                          'r--','g--','b--','k--','y--','c--','m--', ...
%                          'r:','g:','b:','k:','y:','c:','m:'}

% OUTPUT
% col     string with color symbol

if nargin == 1
   colors={'r','b','g','k','y','c','m', ...
   'r--','g--','b--','k--','y--','c--','m--', ...
   'r:','g:','b:','k:','y:','c:','m:'};
end

col=colors{mod(index-1,length(colors))+1};

