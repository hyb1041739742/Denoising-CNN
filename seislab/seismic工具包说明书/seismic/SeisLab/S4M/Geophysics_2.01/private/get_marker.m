function mark=get_marker(index)
% Function gets the marker symbol associated with index "index"
% Markers are ['^';'v';'<';'>';'s';'d';'+';'x';'o';'p';'h';'.']
% For index > 12 the markers are repeated
% Written by: E. R.
%
%         mark=get_marker(index)
% INPUT
% index   index for which color symbol is requested
% OUTPUT
% mark     string with marker symbol

marker=['^';'v';'<';'>';'s';'d';'+';'x';'o';'p';'h';'.'];
mark=marker(mod(index-1,12)+1);


