function  plot_wb(t,w,a);
%PLOT_WB: Horizontal plotting with Bias
%
%  IN:   t: time axis
%        w: traces or wavelets in columns.
%        a: overlab in percentage
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%
%  Example:
%            
%            [w1,tw] = rotated_wavelet(4./1000,4.,50.,0);
%            [w2,tw] = rotated_wavelet(4./1000,4.,50.,45);
%            [w3,tw] = rotated_wavelet(4./1000,4.,50.,90);
%            W =[w1,w2,w3];
%            subplot(221); plot_wb(tw,W,  0);
%            subplot(222); plot_wb(tw,W,50);
%




 w = w/max(max(abs(w)));
 [nt,nx] = size(w);
  x = 1:1:nx;
 plot(t,((a/100+1)*w)+ones(size(w))*diag(x),'k','LineWidth',2);axis tight;
