function [cum3_true] = True_cum3(h1,h2,h3,cum_length)

%--------------------------------------------------------------------------------
%	True_cum3.M
%	Calculate the True third order cumulant of three system driven by the same 
%  white input.
%
%  Usage:
%     [cum3_true] = True_cum3(h1,h2,h3,cum_length);
%  Where
%  cum3_true : the True Cumulant C3(m,n) of a system driven by white noise.
%	h1        : Impulse Response of system 1
%	h2        : Impulse Response of system 2
%	h3        : Impulse Response of system 3
%              h1, h2 and h3 must have the same length
%	cum_length: the range of cumulant, should be larger than the ORDER of h1,h2,h3
%
%--------------------------------------------------------------------------------

ORDER=length(h1)-1;

cum3_true=zeros(2*cum_length+1,2*cum_length+1);

for ii=cum_length+1-ORDER:cum_length+1+ORDER
   for jj=cum_length+1-ORDER:cum_length+1+ORDER
      for kk=max(1,max(-(ii-cum_length-1)+1,-(jj-cum_length-1)+1)):min(ORDER+1,min(ORDER-(ii-cum_length-1)+1,ORDER-(jj-cum_length-1)+1))
%         cum3_true(ii,jj)=cum3_true(ii,jj)+conj(h1(kk))*h2(kk+ii-cum_length-1)*h3(kk+jj-cum_length-1);
         cum3_true(ii,jj)=cum3_true(ii,jj)+(h1(kk))*h2(kk+ii-cum_length-1)*h3(kk+jj-cum_length-1);
      end
   end
end

