function [cum4_3_true] = true_cum4_3D(h1,h2,h3,h4,cum_length)
%----------------------------------------------------------------------------------
%	True_cum4_3D.M
%	Calculate the True fourth order cumulant of three system driven by the same 
%  white input.
%
%  Usage:
%     [cum4_3_true] = true_cum4D(h1,h2,h3,h4,cum_length);
%  Where
%  cum4_3_true : the True Cumulant {C1234(m,n,l)} of a system driven by 
%                white noise.
%	h1          : Impulse Response of system 1
%	h2          : Impulse Response of system 2
%	h3          : Impulse Response of system 3
%	h4          : Impulse Response of system 4
%                h1, h2 and h3 must have the same length
%	cum_length  : the range of cumulant, should be larger than the ORDER of h1,h2,h3
%
%----------------------------------------------------------------------------------

ORDER=length(h1)-1;

cum4_3_true=zeros(2*cum_length+1,2*cum_length+1,2*cum_length+1);

for ii=cum_length+1-ORDER:cum_length+1+ORDER
   for jj=cum_length+1-ORDER:cum_length+1+ORDER
      for kk=cum_length+1-ORDER:cum_length+1+ORDER
         for ll=max([1,-(kk-cum_length-1)+1,-(ii-cum_length-1)+1,-(jj-cum_length-1)+1]):...
               min([ORDER+1,ORDER-(kk-cum_length-1)+1,ORDER-(ii-cum_length-1)+1,ORDER-(jj-cum_length-1)+1])
            cum4_3_true(ii,jj,kk)=cum4_3_true(ii,jj,kk)+h1(ll)*h2(ll+ii-cum_length-1)*h3(ll+jj-cum_length-1)*h4(ll+kk-cum_length-1);
         end
      end
   end
end
