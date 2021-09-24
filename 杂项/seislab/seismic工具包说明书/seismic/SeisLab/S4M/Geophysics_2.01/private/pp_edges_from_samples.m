function edges=pp_edges_from_samples(samples,nedges)
% Create edge vector from sample vector for histogram computation
% Written by: E. R.: June 26, 2003
% Last updated: July, 30, 2003: Change order of input arguments
%
%          edges=pp_edges_from_samples(samples,nedges)
% INPUT
% samples  samples from which to compute the edges
% nedges   number of edges (number of bins for histogram +1)
% OUTPUT
% edges    column vector of edges of histogram bins

sampleMin=min(samples(:));
sampleMax=max(samples(:));
if sampleMax >= 0
   sampleMax=sampleMax*(1+2*eps);
else
   sampleMax=sampleMax*(1-2*eps);
end
if sampleMin*sampleMax < 0;
   sampleMax=max(-sampleMin,sampleMax);
   sampleMin=-sampleMax;
end
edges=linspace(sampleMin,sampleMax,nedges)';

