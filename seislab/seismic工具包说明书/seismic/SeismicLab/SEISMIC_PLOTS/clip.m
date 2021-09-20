function  Dc  = clip(D,perc_low, perc_upper);
%CLIP: A program to clip seismic data.
%
%  Dc  = clip(D,perc_low, perc_upper);
%
%  IN   D:          data to be clipped
%       perc_low:   lower percentile  
%       perc_upper: upper percentile
%
%  OUT  Dc:         data after being clipped
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002 
%  
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

	if (nargin < 1 | nargin > 3)
         error('Wrong number of input parameters in CLIP.')
	  end

        [nx,ny]=size(D);
        dtemp = reshape(D,nx*ny,1);

        [N,X] = hist(dtemp,100);

        C = cumsum(N);

        N_total = sum(C);
        C = C/N_total;


        low = find(C<perc_low/100.)  
        up =  find(C>perc_upper/100.)
        
	clip_low    = max(low);
	clip_upper  = min(up);

	[i,j]=find(D>=clip_upper);

	[k,m]=find(D<=clip_low);
        Dc = D;
	Dc(i,j) = clip_upper;
	Dc(k,m) = clip_low;
