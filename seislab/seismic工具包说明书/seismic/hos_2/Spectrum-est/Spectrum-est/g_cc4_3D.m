function [cum] = g_cc4_3D(signal_1,signal_2,signal_3,signal_4,C_LENGTH)
%------------------------------------------------------------------------------
%	g_cc4_3D.m
%	This function generate the fourth order cross cumulant of 4 signals
%
% Usage:
%	 [cum] = g_cc4_3D(signal_1,signal_2,signal_3,signal_4,C_LENGTH);
% Where
%	cum       : the cross cumulant matrix (C1234(m,n,k)) of the 4 signals
%              -C_LENGTH <= m,n <= C_LENGTH
%	signal_1  : the signal 1 to be processed
%	signal_2  : the signal 2 to be processed
%	signal_3  : the signal 3 to be processed
%	signal_4  : the signal 4 to be processed
%	C_LENGTH  : the maximum argument of the cross cumulant
%
%  Designed and verified to be correct for real signal on Dec 14, 1999.
%  Binning Chen
%  Communications and Signal Processing Laboratory
%  ECE Department, Drexel University
%  Philadelphia, PA 19104, USA
%  http://www.ece.drexel.edu/CSPL
%-------------------------------------------------------------------------------

seg_length=4096*4;

signal_1=signal_1(:);                                   %% Change to column vector
signal_2=signal_2(:);                                   %% Change to column vector
signal_3=signal_3(:);                                   %% Change to column vector
signal_4=signal_4(:);                                   %% Change to column vector

N = length(signal_1);                                   %% Length of the signal

L = 2*C_LENGTH+1;

if N > seg_length

    seg_num=N/seg_length;
    cum=zeros(L,L,L);
    for seg=0:seg_num-1
        cum = cum + g_cc4_3D(signal_1(seg_length*seg+1:seg_length*(seg+1)),...
            signal_2(seg_length*seg+1:seg_length*(seg+1)),...
            signal_3(seg_length*seg+1:seg_length*(seg+1)),...
            signal_4(seg_length*seg+1:seg_length*(seg+1)),C_LENGTH);
    end
    cum = cum / seg_num;

else

    X1 = repmat(signal_1,1,L).';                         %% L x N matrix

    C2=[zeros(C_LENGTH,1);signal_2(1:C_LENGTH+1)];       %% First column of X2
    R2=[signal_2(C_LENGTH+1:N).' zeros(1,C_LENGTH)];     %% Last row of X2
    X2=hankel(C2,R2);                                    %% L x N matrix

    C3=[zeros(C_LENGTH,1);signal_3(1:C_LENGTH+1)];       %% First column of X3.'
    R3=[signal_3(C_LENGTH+1:N).' zeros(1,C_LENGTH)];     %% Last row of X3.'
    X3=hankel(C3,R3).';                                  %% N x L matrix
    X3=repmat(X3,1,L);                                   %% N x L^2 matrix

    C4=[zeros(C_LENGTH,1);signal_4(1:C_LENGTH+1)];       %% First column of X4.'
    R4=[signal_4(C_LENGTH+1:N).' zeros(1,C_LENGTH)];     %% Last row of X4.'
    X4=hankel(C4,R4).';                                  %% N x L matrix
    X4=reshape(repmat(X4,L,1),N,L*L);                    %% N x L^2 matrix
    %% Repeat every column of X4 L consecutive times.

    cum=reshape((X1.*X2)*(X3.*X4),L,L,L)/N;              %% L x L x L moment matrix
    clear X1 X2 X3 X4 C2 R2 C3 R3 C4 R4                  %% Save memory

%     R_12 = fliplr(xcorr(conj(signal_1),signal_2,C_LENGTH,'biased'));   %% L x 1
%     R_13 = fliplr(xcorr(conj(signal_1),signal_3,C_LENGTH,'biased'));   %% L x 1
%     R_14 = fliplr(xcorr(conj(signal_1),signal_4,C_LENGTH,'biased'));   %% L x 1
%     R_23 = fliplr(xcorr(conj(signal_2),signal_3,2*C_LENGTH,'biased')); %% (4*C_LENGTH+1) x 1
%     R_23(1:C_LENGTH)=0;
%     R_23(end-C_LENGTH+1:end)=0;
%     R_24 = fliplr(xcorr(conj(signal_2),signal_4,2*C_LENGTH,'biased')); %% (4*C_LENGTH+1) x 1
%     R_24(1:C_LENGTH)=0;
%     R_24(end-C_LENGTH+1:end)=0;
%     R_34 = fliplr(xcorr(conj(signal_3),signal_4,2*C_LENGTH,'biased')); %% (4*C_LENGTH+1) x 1
%     R_34(1:C_LENGTH)=0;
%     R_34(end-C_LENGTH+1:end)=0;


    R_12 = cum2x(signal_1,signal_2,C_LENGTH,seg_length,0,'biased');    %% L x 1
    R_13 = cum2x(signal_1,signal_3,C_LENGTH,seg_length,0,'biased');   %% L x 1
    R_14 = cum2x(signal_1,signal_4,C_LENGTH,seg_length,0,'biased');   %% L x 1
    R_23 = cum2x(signal_2,signal_3,2*C_LENGTH,seg_length,0,'biased'); %% (4*C_LENGTH+1) x 1
    R_23(1:C_LENGTH)=0;
    R_23(end-C_LENGTH+1:end)=0;
    R_24 = cum2x(signal_2,signal_4,2*C_LENGTH,seg_length,0,'biased'); %% (4*C_LENGTH+1) x 1
    R_24(1:C_LENGTH)=0;
    R_24(end-C_LENGTH+1:end)=0;
    R_34 = cum2x(signal_3,signal_4,2*C_LENGTH,seg_length,0,'biased'); %% (4*C_LENGTH+1) x 1
    R_34(1:C_LENGTH)=0;
    R_34(end-C_LENGTH+1:end)=0;

    clear signal_1 signal_2 signal_3 signal_4            %% Save memory

    R_34_matrix = toeplitz(R_34(L:-1:1),R_34(L:1:4*C_LENGTH+1).');     %% L x L
    %%%%%%%%%%%%%%%%%%%%   First Column       First Row  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Signal 3's suffix is the column index, Signal 4's suffix is the row index.  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    R_12_34=reshape(repmat(R_12,L*L,1).*reshape(repmat(reshape(R_34_matrix,L*L,1),1,L).',L*L*L,1),L,L,L);

    R_24_matrix = toeplitz(R_24(L:-1:1),R_24(L:1:4*C_LENGTH+1).'); %% L x L
    %%%%%%%%%%%%%%%%%%%%   First Column       First Row  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Signal 2's suffix is the column index, Signal 4's suffix is the row index.  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    R_13_24 = reshape(reshape(repmat(R_13,L,L).',L*L,L).*repmat(R_24_matrix,L,1),L,L,L);

    R_23_matrix = toeplitz(R_23(L:-1:1),R_23(L:1:4*C_LENGTH+1).'); %% L x L
    %%%%%%%%%%%%%%%%%%%%   First Column       First Row  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Signal 2's suffix is the column index, Signal 3's suffix is the row index.  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    R_14_23 = reshape(repmat(R_23_matrix,1,L).*repmat(reshape(repmat(R_14,1,L).',1,L*L),L,1),L,L,L);

    cum = cum - R_12_34 - R_13_24 - R_14_23;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% To construct R_12_34, R_13_24 and R_14_23 for C_1234(m,n,k), the three
%% correlation matrix shoul be 3-D matrix, where m, n and k are the three
%% corresponding axies. If we reshape the 3-D matrix to a row vector, it
%% should look like
%%
%% [m(-C_L:C_L)n(-C_L)k(-C_L) m(-C_L:C_L)n(1-C_L)k(-C_L) ... m(-C_L:C_L)n(C_L)k(-C_L)
%%  m(-C_L:C_L)n(-C_L)k(1-C_L) m(-C_L:C_L)n(1-C_L)k(1-C_L)...m(-C_L:C_L)n(C_L)k(1-C_L)
%%  .
%%  .
%%  .
%%  m(-C_L:C_L)n(-C_L)k(C_L) m(-C_L:C_L)n(1-C_L)k(C_L) ... m(-C_L:C_L)n(C_L)k(C_L)     ]
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

