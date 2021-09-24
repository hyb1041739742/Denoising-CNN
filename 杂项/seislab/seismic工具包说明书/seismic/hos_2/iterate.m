function [HREC,ha,MMSE,SER]=iterate(snr,nsamp,nfft,seg_len,order,fact,h,MA,AR,M,nosl)

% ============================================================================
% function [HREC,ha,MMSE,SER]=iterate(snr,nsamp,nfft,seg_len,order,fact,h,MA,AR,M,nosl)
%
% Author: H. Pozidis,   September 23, 1998
% ----------------------------------------------------------------------------

NI=20;  Q=10;  dist=1;  dim=16;  % (dim: dimension for QAM)
A=hos_matrix(nfft,dist);
Ainv=inv(A);

for i=1:NI
  rand;  seeds(i,1)=rand('seed');
  randn; gaus(i,1)=randn('seed');
  randn; gaus(i,2)=randn('seed');
end

Lh=length(h); [oh,ph]=max(abs(h));
pos=ceil(Lh/2);
hr=zeros(1,nfft); HREC=zeros(NI,2*Q+1);
lead=Q-(pos-1);
trail=Q-Lh+pos;
ha=[zeros(1,lead) h(:).' zeros(1,trail)];

for ni=1:NI
  us=seeds(ni,:);  ns1=gaus(ni,1);  ns2=gaus(ni,2);
  HR=[];  disp(ni);   
  [y,x,w,u]=arma_gen('q',dim,nsamp,MA,AR,snr,1,1,us,ns1,ns2);
  [spec,s1,s2,n1,n2]=slice_est(y,nsamp,nfft,seg_len,order,M,fact,nosl,Lh);

  for sl=1:length(n1)
    slic1=n1(sl);   slic2=n2(sl);
    [hr,HH]=hos_id(Ainv,spec,order,nfft,slic1,slic2,s1(sl),s2(sl),dist,h);

    [mx,lc]=max(abs(hr));
    lea=ceil((2*Q+1-Lh)/2); trai=(2*Q+1)-Lh-lead;
    plus=ph-1; minus=Lh-ph;
    ind=modulo(lc-plus-lea:lc+minus+trai,nfft); ind(ind==0)=nfft;
    rec=hr(ind);
    HR(sl,:)=rec;
  end
  if length(n1)==1
    HREC(ni,:)=HR;
  else
    HREC(ni,:)=mean(HR);
  end
[uest,mmse,sym,err,ser]=calculate_SER('q',dim,h,HREC(ni,lead+1:lead+Lh),snr,32,ni); 
  MMSE(ni)=mmse;  SER(ni)=ser;
end
