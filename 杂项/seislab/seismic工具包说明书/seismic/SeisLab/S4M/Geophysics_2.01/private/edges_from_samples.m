function [edges,newsamples]=edges_from_samples(samples,no_of_bins,fraction)
% Compute "no_of_bins" bin edges in such a way that "percentile" samples are 
% in these bins and that each bin contains about the same number of samples
% Written by: E. R.: February 10, 2004
% Last updated:
% 
%            [edges,newsamples]=edges_from_samples(samples,no_of_bins,fraction)
% INPUT
% samples    samples for which to compute bins
% no_of_bins  number of bins to compute
% fraction   fraction of the samples to use; this allows exclusion of outliers
% OUTPUT
% edges      edges of the bins; the number of edges is no_of_bins + 1
% newsamples  samples retained

[samples,ndims]=shiftdim(samples(~isnan(samples)));   % Make sure that first 
                                                      % dimension is not singleton
nsamp=length(samples);
newsamples=sort(samples);

if fraction < 1
   newnsamp=round(fraction*nsamp);
   if newnsamp < nsamp  % find the range of samples to keep
      test=newsamples(newnsamp+1:end)-newnsamp(1:nsamp-newnsamp);
      [dummy,idx]=min(test);
      newsamples=newsamples(idx:newnsamp+idx-1);
   end
   edges=[newsamples(1);newsamples(round((1:no_of_bins)*newnsamp/no_of_bins))];

else
   edges=[newsamples(1);newsamples(round((1:no_of_bins)*nsamp/no_of_bins))];
end

edges(end)=edges(end)*(1+eps);

newsamples=shiftdim(newsamples,-ndims); % Undo dimension change, if there was one

