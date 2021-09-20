%
% example_radon.m
%
% Example that shows how to use the Radon transform
% 

% Read 1 gather 

 [d,headers] = readsegy('gom_cdp_nmo.su');

% Get headers that are needed by Radon

 h = [headers.offset];
 [nt,nh] = size(d);
 dtsec = headers(1).dt/1000/1000.
 
 qmin = -0.2;                  % min residual moveout at far offset
 qmax = 0.8;                   % max  "         "     "  "   "
 nq = 90                       % 
 dq = (qmax-qmin)/nq; 
 q = [qmin:dq:qmax];
 flow = 1;                     % min freq.
 fhigh = 60.   ;               % max freq.
 mu = 1.;                      % trade-off
 N = 2;                        % parabolas 
 qcut = 0.1 

 [m] = inverse_radon(d,dtsec,h,q,N,flow,fhigh,mu);

 time_axis = 0:dtsec:(nt-1)*dtsec;

% Filter primaries and come back with the forward
% Radon transform

 icut = floor((qcut-qmin)/dq)+1;
 m_mult = m;
 m_mult(:,1:icut) = 0;


% Recover the multiples 

 [d_mult] = forward_radon(m_mult,dtsec,h,q,N,flow,fhigh);


 figure(1); clf;
 subplot(131); imagesc(h,time_axis,d);
 subplot(132); imagesc(q,time_axis,m);
 subplot(133); imagesc(h,time_axis,d_mult);
 colormap(seismic);
