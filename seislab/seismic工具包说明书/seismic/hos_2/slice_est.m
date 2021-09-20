function [spec,s1,s2,n1,n2] = slice_est (y,nsamp,nfft,seg_len,order,M,fact,no_slices,Lh)

% =============================================================================
% function [spec,s1,s2,n1,n2] = slice_est (y,nsamp,nfft,seg_len,order,M,fact,no_slices,Lh)
%
%
% Author: H. Pozidis,   September 23, 1998
% =============================================================================

Ry = xcorr(y,Lh,'biased');  
Ry = Ry(:).';
Ry = [Ry(Lh+1:2*Lh+1) zeros(1,nfft-2*Lh-1) Ry(1:Lh)];
Sy = fft(Ry);  Sy = real(Sy);

[f1,f2] = sort(Sy); f = fliplr(f2); f = sort(f(1:no_slices));
[A1,A2] = meshgrid(f,f);
A1 = A1';  a1 = A1(:);
A2 = A2';  a2 = A2(:);
aa = [a1';a2']; bb = aa(:,find(a1>=a2));
if sum(abs(imag(y)))>0
  s1 = bb(1,:)';  s2 = bb(2,:)';
else
  cc = bb(:,find(bb(2,:)<(nfft/2+1))); 
  s1 = cc(1,:)';  s2 = cc(2,:)';
end
disp(size(s1));

[a1,a2,n1,n2] = index(s1,s2);

num_seg = nsamp/seg_len;
cum = zeros((2*M-1)*ones(1,order-1));
for k=0:num_seg-1
    seg = y(k*seg_len+1:(k+1)*seg_len);
%    seg = seg(:).*hamming(seg_len);      % HAMMING-windowing segment
    seg = seg-mean(seg);
    [cu,mo]=moments(seg,M,order);
    cum = cum + cu;
%    cum = cum + mo;                   % for QAM constellations only
end
cum=(1/num_seg)*cum;

spec = spec_est(cum,nfft,a1,a2,order);
