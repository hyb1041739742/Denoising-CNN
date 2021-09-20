function [a1,a2,n1,n2] = index (s1,s2)

% =================================================
% function [a1,a2,n1,n2] = index (s1,s2)
%
% s1,s2  :  the slices selected by select_slice.m
% a1,a2  :  the slices needed in the polyspectrum
% n1,n2  :  the index in the new polyspectrum
%
% Author: H. Pozidis,   September 23, 1998
% =================================================

a1 = sort(s1');
a2 = sort(s2');
d1 = diff(a1);  f1 = find(d1 ~= 0);
d2 = diff(a2);  f2 = find(d2 ~= 0);
a1 = a1([1 f1+1]);
a2 = a2([1 f2+1]);

d2 = diff(a2);  f2 = find(d2 > 1);
q2 = [f2 length(a2)];
a2 = sort([a2 a2(q2)+1]);

for k=1:length(s1)
  n1(k) = find(a1 == s1(k));
  n2(k) = find(a2 == s2(k));
end
