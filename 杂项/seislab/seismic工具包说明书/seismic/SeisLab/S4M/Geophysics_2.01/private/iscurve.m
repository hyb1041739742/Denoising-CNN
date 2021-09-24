function bool=iscurve(wlog,mnem)
% Returns logical(1) if mnem is a curve mnemonic in log structure "wlog"
% and logical(0) otherwise
% Written by: E. R.: December 17, 2003
% Last updated:
%
%         bool=iscurve(wlog,mnem)
% INPUT
% wlog    log structure
% mnem    curve mnemonic
% OUTPUT
% bool    boolean variable; set to logical(1) if mnem is a curve mnemonic in 
%         log structure "wlog" and logical(0) otherwise

[dummy,ierr]=curve_index1(wlog,mnem);

bool=~ierr;


