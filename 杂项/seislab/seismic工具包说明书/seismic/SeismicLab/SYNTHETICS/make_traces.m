function [s,ts,w,tw] = make_traces(Nr,Ntraces,dt,f1,f2,f3,f4,c,r_fun,arg);
%MAKE_TRACES: make an emsemble of traces by convolving
%             a Random reflectivity with a wavelet
%
%  [s,ts,w,tw] = make_traces(Nr,Ntraces,dt,f1,f2,f3,f4,c,r_fun,arg);
%
%  IN     Nr:      mumber of samples of the reflectivity
%         Ntraces: number of traces
%         dt:      sampling interval in secs
%         f1,f2,f3,f4: frqs. defining a wavelet with trapedoidal
%                  amplitude response
%         c:       constat phase rotation in degrees c=0 ==>zero phase wavelet
%                                                    c=90 ==> asymmetric wavelet
%         r_fun:   call to funtion to produce the reflectivity
%         arg  :   argument vector of r_fun 
%
%         r_fun can be 'bernoulli', 'laplace_mixture', 'gaussian_mixture', 
%         For instance, >>help bernoulli, will explain how to set the vector arg.
%         
%
%  OUT    s:       seismic traces
%         ts:      axis of s
%         w:       wavelet
%         tw:      axis for the wavelet
%
%  Example: Make 10 traces by convolving a reflectivity with a 90deg rotated wavelet
%
%   Nr = 100; Ntraces = 10; dt = 4./1000;
%   f1 = 10; f2 = 20; f3 = 50; f4 = 60;
%   c = 90; 
%   [s,ts,w,tw] = make_traces(Nr,Ntraces,dt,f1,f2,f3,f4,c,'bernoulli',[0.9,0.1]);
%   plot_area(ts,s,3,-40); 
%   title('10 realizations of a Bernoulli reflectivity convolved with a 90deg wavelet');
%   xlabel('time [s]');
%
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1988-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%

 [w,tw] = make_a_trapezoidal_wavelet(dt,f1,f2,f3,f4,c);

 nw = length(w);

 Ns = Nr+nw-1;
 s = zeros(Ns,Ntraces);
                                                                               
                                                                               
  for k=1:Ntraces
   r(:,k) = feval(r_fun,Nr,arg);
   s(:,k) = conv(w,r(:,k));
  end
                                                                               
  ts = (0:1:Ns-1)*dt;
