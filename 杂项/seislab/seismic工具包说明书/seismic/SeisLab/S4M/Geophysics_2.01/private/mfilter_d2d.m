function [filter,cc_max,shift]=mfilter_d2d(s1,s2,wl,wnoise,increment)
% Function computes filter "filter" which converts each column of s1 into the 
% corresponding column of s2. If s1, s2 represent seismic data sets, then each column 
% is a seismic trace and the filters perform trace-to-trace (t2t) matching. 
% For internal use in s_match_filter. Hence no error checking
% INPUT
% s1, s2    matrices with the same number of columns and nsamp1 and nsamp2 rows,respectively.
% wl        filter length
% wnoise    white noise factor
% increment increment for shifts of s2 versus s1 for filter computation 
%           (max(round wl/10)+1 recommended)
% OUTPUT
% filter    filter (s2 = filter*s1)
% cc        highest value of crosscorrelation of s2 and w*s1
% shift     shift of s2 required to match s1 to s2. 
%           if shift-(nf-nf/2) is zero and the s1 and s2 have the same start time, then
%           s1 and s2 are aligned and time zero of the filter is at sample nf/2
%                [filter,cc_max,shift]=mfilter_d2d(s1,s2,wl,wnoise)

[nsamp1,ntr]=size(s1);
nsamp2=size(s2,1);
% wlh=round((wl+1)/2);
nshifts=nsamp2-nsamp1+wl;
nshifts_reduced=fix((nshifts-1)/increment)+1;
nmat=nsamp1-wl+1;
cc=zeros(nshifts_reduced,1);
cc_max=zeros(ntr,1);
%filter=zeros(wl,ntr);

matrix=myconvmtx(s1(:,1),wl);
matrix=matrix(wl:end-wl+1,:);
rhs=myconvmtx(s2(:,1),nshifts);
rhs=rhs(nshifts:nsamp2,end:-increment:1);

nmat=size(matrix,1);
nnmat=nmat*ntr;
nnmat0=nnmat;
if wnoise > 0
  nnmat=nnmat+wl;
end
MATRIX=zeros(nnmat,wl);
RHS=zeros(nnmat,nshifts_reduced);
start=1:nmat:nnmat;
ende=start+(nmat-1);

for ii=2:ntr
  matrix=myconvmtx(s1(:,ii),wl);
  MATRIX(start(ii):ende(ii),:)=matrix(wl:end-wl+1,:);
  rhs=myconvmtx(s2(:,ii),nshifts);
  RHS(start(ii):ende(ii),:)=rhs(nshifts:nsamp2,end:-increment:1);
end
if wnoise > 0
  MATRIX(start(end):nnmat,:)=wnoise*norm(s1(:))*eye(wl);
  RHS(start(end):nnmat,:)=zeros(wl,nshifts_reduced);
end

wav=MATRIX\RHS;     % Compute filter

%    Compute correlation coefficients
srhs=MATRIX(1:nnmat0,:)*wav;
cc=zeros(nshifts_reduced,1);
for jj=1:nshifts_reduced
%  cc(jj)=cornor(RHS(1:nnmat0,jj),srhs(:,jj),'max');
  cc(jj)=normcorr(RHS(1:nnmat0,jj),srhs(:,jj));
end

[cc_max,cidx]=max(cc);
% shift=(cidx-1)*increment-wlh+1;
shift=(cidx-1)*increment+1; 
filter=wav(:,cidx);

    

