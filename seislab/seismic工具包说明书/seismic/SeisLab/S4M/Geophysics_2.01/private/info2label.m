function label=info2label(info)
% Create label for axis annotation from two-element or three-element 
% cell array such as those found in structures for seismic data, well logs, 
% p.d.f.s, etc.
% Written by: E. R.: June 23, 2003
% Last updated:
%
% INPUT
% info   2- or 3-element cell array
% OUTPUT
% label  string with label for plot annotation

text=info{end};
units=info{end-1};

label=text;

if ~isempty(units)
   if ~strcmpi(units,'n/a')
      label=[text,' (',units2tex(units),')'];
   end
end

