function Hr = renyi(x,alpha);
%RENYI: Computes Renyi's entropy using
%       a Gaussian density kernel of widht h.

 
  xmin = min(x)*0.9;
  xmax = max(x)*1.1;

  xa = linspace(xmin,xmax,40);

 [Nt,Nx] = size(x);
 if Nx>1; x = reshape(x,Nt*Nx,1);end;
  L = length(x);
  h = 1.06*(L^-0.2)*std(x);
  f = kernel(xa,x,h);
  sc = 1/(1-alpha);
  Hr =  sc*log( (1/L^alpha)* sum(f.^(alpha-1)));
