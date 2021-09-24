function s = strim(ss)
% Function removes trailing and leading blanks of a string.
%        s=strim(ss)
% INPUT
% ss     strings whose leading and trailing blanks need to be removed
% OUTPUT
% s      string without leading and trailing blanks

s=fliplr(deblank(fliplr(deblank(ss))));

