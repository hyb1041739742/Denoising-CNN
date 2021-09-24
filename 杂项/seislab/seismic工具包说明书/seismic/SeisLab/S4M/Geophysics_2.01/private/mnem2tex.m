function mnemo=mnem2tex(mnemi)
% Function substitutes TeX-style mnemonics for input mnemonics (used for
% axis annotationn plots); e.g. DT_S ==> DT\_S
% Written by E. R., May, 6, 2000
% Last updated: E. R., September 20, 2001: Handle case when the correction 
%                                               has already been made
% INPUT
% mnemi    string or cell with input mnemonic
% OUTPUT
% mnemo    string with output mnemonic
%             uo=mnem2tex(ui)

mnemo=strrep(mnemi,'\_','_');
mnemo=strrep(mnemo,'_','\_');


