function [filter,cc_max,shift]=mfilter_t2t(s1,s2,wl,wnoise,increment)
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
%                [filter,cc_max,shift]=mfilter_t2t(s1,s2,wl,wnoise)
% shift     shift of s2 required to match s1 to s2. 
%           if shift-(nf-nf2) is zero and the s1 and s2 have the same start time, then
%           s1 and s2 are aligned and time zero of the filter is at sample nf2

[nsamp1,ntr]=size(s1);
nsamp2=size(s2,1);
% wlh=round((wl+1)/2);
% nshifts=posshift+negshift+1;
nshifts=nsamp2-nsamp1+wl;
nshifts_reduced=fix((nshifts-1)/increment)+1;
nmat=nsamp1-wl+1;
cc=zeros(nshifts_reduced,1);
cc_max=zeros(ntr,1);
filter=zeros(wl,ntr);

shift=zeros(1,ntr);
for ii=1:ntr
  matrix=myconvmtx(s1(:,ii),wl);
  matrix=matrix(wl:end-wl+1,:);
  rhs=myconvmtx(s2(:,ii),nshifts);
  rhs=rhs(nshifts:nsamp2,end:-increment:1);
  if wnoise > 0
    matrix=[matrix;wnoise*norm(s1(:,ii))*eye(wl)];
    rhs=[rhs;zeros(wl,nshifts_reduced)];
  end

  wav=matrix\rhs;
%keyboard
  srhs=matrix(1:nmat,:)*wav;
  for jj=1:nshifts_reduced
%    cc(jj)=cornor(rhs(1:nmat,jj),srhs(:,jj),'max');
    cc(jj)=normcorr(rhs(1:nmat,jj),srhs(:,jj));
  end
  [ccmax,cidx]=max(cc);
  cc_max(ii)=ccmax;
%  shift(ii)=(cidx-1)*increment-wlh+1; 
  shift(ii)=(cidx-1)*increment+1; 
  filter(:,ii)=wav(:,cidx);
end
