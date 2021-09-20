function [Tris,Tris_true]=estTris4(NF,Le,k2,k3,x,n,h,H)

if mod(NF,2) KF=(NF+1)/2; else KF=NF/2; end

[m,N]=size(x);

%% INITIALIZATION
seg_num=16;            %%% Number of segments
seg_length = N/seg_num;            %%% Segment length used in estimating the cross cumulants

Overlap=0;                      % overlap the segmented data with Overlap_length symbols
C_LENGTH=Le;                    %%% how much cumulants need estimate, maximum argument of cumulants
ADD_CUM_WINDOW=1;                %%% Add window when estimating cross polyspectra.
win_width=C_LENGTH;             %%% Window length for estimating cross cumulants.

d_win=zeros(1,1+win_width);     %%% Single side Window function prototype for estimating cross-cumulants.
%% Optimal Window, also called Sasaki Window
d_win=abs(sin((0:win_width)*pi/win_width))/pi + (1.0-(0:win_width)/win_width).*cos((0:win_width)*pi/win_width);
%% Parzen Window
%d_win(1:1+floor(win_width/2))=1-6*((0:floor(win_width/2))/win_width).^2+6*((0:floor(win_width/2))/win_width).^3;
%d_win(2+floor(win_width/2):win_width+1)=2*(1-(1+floor(win_width/2):win_width)/win_width).^3;

dd_win=zeros(1,2*win_width+1);  %%% Double side Window function prototype for estimating cross-cumulants.
dd_win(win_width+1:2*win_width+1)=d_win;
dd_win(1:win_width)=d_win(win_width+1:-1:2);

dd_win=1.2+0.1*blackman(2*win_width+1).';

for kk=1:2*C_LENGTH+1
    cum_4_window_4(:,:,kk)=ones(2*C_LENGTH+1,2*C_LENGTH+1)*dd_win(kk);
end

cum_win=zeros(win_width*2+1);   %%% Two dimensioanl Window function for estimating cross-cumulants.
for ii=-win_width:win_width
    for jj=-win_width:win_width
        if abs(ii-jj) <= win_width
            cum_win(ii+win_width+1,jj+win_width+1)=d_win(abs(ii)+1)*d_win(abs(jj)+1)*d_win(abs(ii-jj)+1);
        end
    end
end

%%%%% True Cumulant

cum_true=zeros(2*C_LENGTH+1,2*C_LENGTH+1,2*C_LENGTH+1,m,m,m,m);
cum_true1=zeros(2*C_LENGTH+1,2*C_LENGTH+1,m,m,m,m);
cum_true2=zeros(2*C_LENGTH+1,m,m,m,m);
for ii=1:m
    for jj=1:m
        for kk=1:m
            for ll=1:m
                for pp=1:n
                    cum_true(:,:,:,ii,jj,kk,ll) = cum_true(:,:,:,ii,jj,kk,ll) + true_cum4_3D(h(:,ii,pp),conj(h(:,jj,pp)),h(:,kk,pp),h(:,ll,pp),C_LENGTH);
                end
                for rr=-C_LENGTH:1:C_LENGTH
                    for mm=-C_LENGTH:1:C_LENGTH
                        cum_true1(rr+C_LENGTH+1,mm+C_LENGTH+1,ii,jj,kk,ll)=exp(-sqrt(-1)*2*pi*(-C_LENGTH:1:C_LENGTH)*k2/NF)*reshape(cum_true(rr+C_LENGTH+1,:,mm+C_LENGTH+1,ii,jj,kk,ll),2*C_LENGTH+1,1 );
                    end
                    cum_true2(rr+C_LENGTH+1,ii,jj,kk,ll)=exp(-sqrt(-1)*2*pi*(-C_LENGTH:1:C_LENGTH)*k3/NF)*reshape(cum_true1(rr+C_LENGTH+1,:,ii,jj,kk,ll), 2*C_LENGTH+1,1 );
                end
            end
        end
    end
end


Tris_true=zeros(NF,m,m,m,m);

for ii=1:m
    for jj=1:m
        for kk=1:m
            for ll=1:m
                cx_dummy=zeros(NF,1);
                cx_dummy((KF+1-C_LENGTH) : (KF+1+C_LENGTH))=cum_true2(:,ii,jj,kk,ll);
                cx_dummy=fftshift(cx_dummy);
                Tris_true(:,ii,jj,kk,ll)=fft(cx_dummy,NF);
            end
        end
    end
end

clear cum_true1;
clear cum_true2;

if 0
    %%Calculating True Trispectrum use direct method, which is slow
    
    Tris_true1=zeros(NF,m,m,m,m);
    
    for k3=0:NF-1
        for ll=1:m
            for mm=1:m
                D_m=conj(diag(H(mm,:,mod(-k3,NF)+1)));
                D_l=diag(H(ll,:,mod(k2,NF)+1)*D_m);
                Tris_true1(k3+1,:,:,ll,mm)=squeeze(H(:,:,mod(-1*(k1+k2+k3),NF)+1))*D_l*H(:,:,mod(-k1,NF)+1)';
            end
        end
    end
    
end




%%% Esimate the Cumulant

cum = zeros(2*C_LENGTH+1,2*C_LENGTH+1,2*C_LENGTH+1,m,m,m,m);
cum1= zeros(2*C_LENGTH+1,2*C_LENGTH+1,m,m,m,m);
cum2= zeros(2*C_LENGTH+1,m,m,m,m);

for ii=1:m
    for jj=1:m
        for kk=1:m
            for ll=1:m
                cum(:,:,:,ii,jj,kk,ll)=g_cc4_3D((x(ii,:)),conj(x(jj,:)),x(kk,:),conj(x(ll,:)),C_LENGTH);
            end
        end
    end
end

for ii=1:m
    for jj=1:m
        for kk=1:m
            for ll=1:m
                cum_win1=zeros(2*C_LENGTH+1,2*C_LENGTH+1,2*C_LENGTH+1);
                cum_win1(find(cum_true(:,:,:,ii,jj,kk,ll)))=1;
                cum(:,:,:,ii,jj,kk,ll)=cum(:,:,:,ii,jj,kk,ll).*cum_win1;
                for rr=-C_LENGTH:1:C_LENGTH
                    for mm=-C_LENGTH:1:C_LENGTH
                        cum1(rr+C_LENGTH+1,mm+C_LENGTH+1,ii,jj,kk,ll)=exp(-sqrt(-1)*2*pi*(-C_LENGTH:1:C_LENGTH)*k2/NF)*( reshape(cum(rr+C_LENGTH+1,:,mm+C_LENGTH+1,ii,jj,kk,ll),2*C_LENGTH+1,1).*dd_win.' );
                    end
                    cum2(rr+C_LENGTH+1,ii,jj,kk,ll)=exp(-sqrt(-1)*2*pi*(-C_LENGTH:1:C_LENGTH)*k3/NF)*( reshape(cum1(rr+C_LENGTH+1,:,ii,jj,kk,ll),2*C_LENGTH+1,1).*dd_win.');
                end
            end
        end
    end
end

clear cum;
clear cum1;

Tris=zeros(NF,m,m,m,m);

for ii=1:m
    for jj=1:m
        for kk=1:m
            for ll=1:m
                cx_dummy=zeros(NF,1);
                cx_dummy((KF+1-C_LENGTH) : (KF+1+C_LENGTH))=cum2(:,ii,jj,kk,ll);
                cx_dummy=fftshift(cx_dummy);
                B_x_dummy=(fft(cx_dummy,NF));
                Tris(:,ii,jj,kk,ll)=B_x_dummy;
            end
        end
    end
end