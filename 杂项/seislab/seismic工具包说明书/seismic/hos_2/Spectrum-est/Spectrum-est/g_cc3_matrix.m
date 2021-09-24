function [cx] = g_cc3_matrix(signal_1,signal_2,signal_3,C_LENGTH)
%------------------------------------------------------------------------
%	g_cc3_matrix.m
%	This function generate the third order cross cumulant of 3 signals
%
% Usage:
%	 [cx] = g_cc3_matrix(signal_1,signal_2,signal_3,C_LENGTH);
% Where
%	cx        : the cross cumulant matrix C(m,n) of the 3 signals
%              -C_LENGTH <= m,n <= C_LENGTH
%	signal_1  : the signal 1 to be processed
%	signal_2  : the signal 2 to be processed
%	signal_3  : the signal 3 to be processed
%	C_LENGTH  : the maximum argument of the cross cumulant
% 
%  This function was verified to be correct by Binning Chen on
%  August 12, 1999.
%------------------------------------------------------------------------

signal_1=signal_1(:);   %% Made the signal column vector
signal_2=signal_2(:);   %% Made the signal column vector
signal_3=signal_3(:);   %% Made the signal column vector

N = length(signal_1);   %% Length of the signal

X1 = repmat(signal_1,1,2*C_LENGTH+1);   %% N x 2*C_LENGTH+1 matrix

C2=[zeros(C_LENGTH,1);signal_2(1:C_LENGTH+1)];   %% First column of X2
R2=[signal_2(C_LENGTH+1:N).' zeros(1,C_LENGTH)]; %% Last row of X2
X2=hankel(C2,R2);                       %% 2*C_LENGTH+1 x N matrix

C3=[zeros(C_LENGTH,1);signal_3(1:C_LENGTH+1)];   %% First column of X3.'
R3=[signal_3(C_LENGTH+1:N).' zeros(1,C_LENGTH)]; %% Last row of X3.'
X3=hankel(C3,R3).';                     %% N x 2*C_LENGTH+1 matrix

cx=X2*(X1.*X3)/N;                       %% 2*C_LENGTH+1 x 2*C_LENGTH+1 matrix


if 0 %%% The old version, which is easy to understand
   
   N_long=N+2*C_LENGTH;
   
   sig_2=zeros(1,N_long);
   sig_3=zeros(N_long,1);
   
   sig_2(C_LENGTH+1:C_LENGTH+N)=conj(signal_2)';
   sig_3(C_LENGTH+1:C_LENGTH+N)=signal_3;
   
   for m=-C_LENGTH:C_LENGTH
      X2(m+C_LENGTH+1,:)=sig_2(m+C_LENGTH+1:m+C_LENGTH+N);
      X3(:,m+C_LENGTH+1)=sig_3(m+C_LENGTH+1:m+C_LENGTH+N).*signal_1;
   end
   
   cx=X2*X3/N;
end
