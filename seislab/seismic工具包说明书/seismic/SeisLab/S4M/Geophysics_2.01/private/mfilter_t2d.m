function [filters,cc_max,shift,scale]=mfilter_t2d(s1,s2,wl,wnoise,increment,lambda,scm)
% Function computes filters "filters" which convert a single trace s1 into the 
% columns of s2. If s1, s2 represent seismic data sets, then each column 
% is a seismic trace and the filters perform trace-to-dataset (t2d) matching. 
% For internal use in s_match_filter. Hence no error checking.
% Written by E. R., April 30, 2000
% Updated August 29, 2000: New correletion coefficient calculation
% INPUT
% s1        vector with "nsamp1" elements.
% s2        matrix with "nsamp2" rows and "ntr" columns
% wl        filter length
% wnoise    white noise factor (non-negative)
% increment increment for shifts of "s2" versus "s1"; for filter computation 
%           (max(round wl/10)+1 recommended)
% lambda    non-negative factor controlling the influence of the spectral constraint
%           if lambda == 0, then spectral constraint not used
% scm       spectral-constraint matrix with "wl" columns; it is assumed that this matrix, if not empty,
%           has Frobenius norm 1.
% OUTPUT
% filters   filters (s2 = filters*s1); matrix with "wl" rows and "ntr" columns
% cc        highest value of crosscorrelation of "s2" and filters*s1
% shift     shift of "s2" required for best match of "s1" to "s2".
%           The zero-time of the filter is at nf-shift.
%           if shift-(nf-nf2) is zero and "s1" and "s2" have the same start time, then
%           s1 and s2 are aligned and time zero of the filter is at sample "nf2"
%           ("nf" is the length of the filter and 
%                [filters,cc_max,shift]=mfilter_t2d(s1,s2,wl,wnoise,increment,lambda,scm)

nsamp1=size(s1,1);
[nsamp2,ntr]=size(s2);
nshifts=nsamp2-nsamp1+wl;
nshifts_reduced=fix((nshifts-1)/increment)+1;

nmat=nsamp1-wl+1;
if wnoise > 0
  nnmat=nmat+wl;
else
  nnmat=nmat;
end
if lambda > 0
  [nscm,mscm]=size(scm);
  if mscm ~= wl
    error(' Spectral constraint matrix must have as many columns as there are filter coefficients')
  end
  nnmat=nnmat+nscm;
end


cc_max=zeros(ntr,1);
filters=zeros(wl,ntr);
shift=zeros(ntr,1);
matrix=zeros(nnmat,wl);
rhs=zeros(nnmat,nshifts_reduced*ntr);
cc=zeros(nshifts_reduced,1);

%      Set up matrix
temp1=myconvmtx(s1,wl);
matrix(1:nmat,:)=temp1(wl:end-wl+1,:);
% norm_s=norm(s1)*wl;
norm_s=max(s1);

if wnoise > 0
  matrix(nmat+1:nmat+wl,:)=wnoise*norm_s*eye(wl);
end
if lambda > 0
  matrix(nnmat-nscm+1:end,:)=lambda*norm_s*scm;
end

for ii=1:ntr
  temp2=myconvmtx(s2(:,ii),nshifts);
  rhs(1:nmat,(ii-1)*nshifts_reduced+1:ii*nshifts_reduced) = ...
            temp2(nshifts:nsamp2,end:-increment:1);
end

wav=matrix\rhs;

srhs=matrix(1:nmat,:)*wav;
ca=1;
cc=zeros(nshifts_reduced,1);
cc_max=zeros(ntr,1);
filters=zeros(wl,ntr);
shift=zeros(ntr,1);
scale=zeros(ntr,1);
for ii=1:ntr
  for jj=1:nshifts_reduced
%    cc(jj)=cornor(rhs(1:nmat,(ii-1)*nshifts_reduced+jj), ...
%                  srhs(:,(ii-1)*nshifts_reduced+jj),'max');
    cc(jj)=normcorr(rhs(1:nmat,ca),srhs(:,ca));
    ca=ca+1;
  end

  [ccmax,cidx]=max(cc);
  cc_max(ii)=ccmax;
  shift(ii)=(cidx-1)*increment+1; 
  filters(:,ii)=wav(:,(ii-1)*nshifts_reduced+cidx);
  scale(ii)=median(abs(rhs(1:nmat,(ii-1)*nshifts_reduced+cidx)))/ ...
            median(abs(srhs(:,(ii-1)*nshifts_reduced+cidx)));
end



