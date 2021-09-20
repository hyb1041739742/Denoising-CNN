function [bis, bis_true, bis_true1]=estCum1(NF,Le,x,h,H)
% This function only calculates the true and estimated 
% third order cumulant and bispectrum 

if mod(NF,2) KF=(NF+1)/2; else KF=NF/2; end
%m: # of sensors
%n: # of sources
[L,m,n]=size(h);

est_channel=1;     %%%%% estimate the channel response assuming know input

%% INITIALIZATION
N=size(x,2);                       %%% Length of Input(Output) signal 
seg_length = 2048;            %%% Segment length used in estimating the cross cumulants
seg_num=N/seg_length;            %%% Number of segments

Overlap=0;                      % overlap the segmented data with Overlap_length symbols
C_LENGTH=Le;                    %%% how much cumulants need estimate, maximum argument of cumulants
ADD_CUM_WINDOW=1;                %%% Add window when estimating cross polyspectra.
win_width=C_LENGTH;             %%% Window length for estimating cross cumulants.
Using_Bispectrum=1;             %%% Using third order cumulants if set to 1. 


d_win=zeros(1,1+win_width);     %%% Single side Window function prototype for estimating cross-cumulants.
%% Optimal Window, also called Sasaki Window
d_win=abs(sin((0:win_width)*pi/win_width))/pi + (1.0-(0:win_width)/win_width).*cos((0:win_width)*pi/win_width);
%% Parzen Window
%d_win(1:1+floor(win_width/2))=1-6*((0:floor(win_width/2))/win_width).^2+6*((0:floor(win_width/2))/win_width).^3;
%d_win(2+floor(win_width/2):win_width+1)=2*(1-(1+floor(win_width/2):win_width)/win_width).^3;

dd_win=zeros(1,2*win_width+1);  %%% Double side Window function prototype for estimating cross-cumulants.
dd_win(win_width+1:2*win_width+1)=d_win;
dd_win(1:win_width)=d_win(win_width+1:-1:2);

cum_win=zeros(win_width*2+1);   %%% Two dimensioanl Window function for estimating cross-cumulants.
for ii=-win_width:win_width
    for jj=-win_width:win_width
        if abs(ii-jj) <= win_width 
            cum_win(ii+win_width+1,jj+win_width+1)=d_win(abs(ii)+1)*d_win(abs(jj)+1)*d_win(abs(ii-jj)+1);
        end
    end
end

%%Calculating True Cross Cumulant and Bispectrum

cum_true=zeros(2*C_LENGTH+1,2*C_LENGTH+1,m,m,m);
for ll=1:m
    for ii=1:m
        for jj=1:m
            for pp=1:n
                if Using_Bispectrum
                    cum_true(:,:,ll,ii,jj) = cum_true(:,:,ll,ii,jj) + true_cum3(h(:,ll,pp),conj(h(:,ii,pp)),h(:,jj,pp),C_LENGTH);
                end
            end
        end
    end
end


bis_true=zeros(NF,NF,m,m,m);
for ll=1:m
    for ii=1:m
        for jj=1:m
            cx_dummy=zeros(NF);
            cx_dummy((KF+1-C_LENGTH) : (KF+1+C_LENGTH) , (KF+1-C_LENGTH) : (KF+1+C_LENGTH))=...
                cum_true(:,:,ll,ii,jj);
            cx_dummy=fftshift(cx_dummy);
            B_x_dummy=(fft2(cx_dummy,NF,NF));
            bis_true(:,:,ll,ii,jj)=B_x_dummy;
        end
    end
end
clear cx_dummy;
clear B_x_dummy;

bis_true1=zeros(NF,NF,m,m,m);

if 1
    for ii=0:NF-1
        for jj=0:NF-1
            for ll=1:m
                bis_true1(ii+1,jj+1,ll,:,:)=conj(squeeze(H(:,:,mod(-1*ii,NF)+1)))*diag(squeeze(H(ll,:,mod(-ii-jj,NF)+1)))* (squeeze(H(:,:,mod(jj,NF)+1))).';
            end
        end
    end
else     
    bis_true1=bis_true;
end

if Overlap
    Overlap_length=200;
    N=N+Overlap_length;
end



%%%Estimation Part
cum = zeros(2*C_LENGTH+1,2*C_LENGTH+1,m,m,m);

for (ll=1:m)
    for (ii=1:m)
        for (jj=1:m)
            for seg=0:seg_num-1
                if Using_Bispectrum
                    cum(:,:,ll,ii,jj)=cum(:,:,ll,ii,jj)+g_cc3_matrix(...
                        x(ll,seg_length*seg+1:seg_length*(seg+1)),...
                        conj(x(ii,seg_length*seg+1:seg_length*(seg+1))),...
                        x(jj,seg_length*seg+1:seg_length*(seg+1)),C_LENGTH)/seg_num;                    
                end
            end
        end
    end
end

if Overlap   
    for (ll=1:m)
        for (ii=1:m)
            for (jj=1:m)
                for seg=0:seg_num-1
                    if Using_Bispectrum
                        cum(:,:,ll,ii,jj)=cum(:,:,ll,ii,jj)+g_cc3_matrix(...
                            x(ll,seg_length*seg+1:seg_length*(seg+1)+Overlap_length),...
                            conj(x(ii,seg_length*seg+1:seg_length*(seg+1)+Overlap_length)),...
                            x(jj,seg_length*seg+1:seg_length*(seg+1)+Overlap_length),C_LENGTH)/seg_num;                    
                    end
                end
            end
        end
    end
end

if ADD_CUM_WINDOW
    cum_win=zeros(2*C_LENGTH+1);
    cum_win(find(cum_true(:,:,1,1,1)))=1;
    for ii=1:2*C_LENGTH+1
        for jj=1:2*C_LENGTH+1
            if cum_win(ii,jj)~=0
                cum_win(ii,jj:jj+sum(cum_win(ii,:))-1)=1.2+0.1*blackman(sum(cum_win(ii,:))).';
                break;
            end
        end
    end
end 

if ADD_CUM_WINDOW 
    for (ll=1:m)
        for (ii=1:m)
            for (jj=1:m)
                cum(:,:,ll,ii,jj) = cum(:,:,ll,ii,jj).*cum_win;
            end
        end
    end
end

bis=zeros(NF,NF,m,m,m);
for ll=1:m
    for ii=1:m
        for jj=1:m
            cx_dummy=zeros(NF);
            cx_dummy((KF+1-C_LENGTH) : (KF+1+C_LENGTH) , (KF+1-C_LENGTH) : (KF+1+C_LENGTH))=cum(:,:,ll,ii,jj);
            cx_dummy=fftshift(cx_dummy);
            B_x_dummy=(fft2(cx_dummy,NF,NF));
            bis(:,:,ll,ii,jj)=B_x_dummy;
        end
    end
end

clear B_x_dummy;
clear cx_dummy;


