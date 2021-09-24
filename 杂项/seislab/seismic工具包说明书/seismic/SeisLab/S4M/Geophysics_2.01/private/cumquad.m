function ci = cumquad(y,x)
% Function computes the numerical approximation to the indefinite 
% integral y dx (corresponding to cumsum)
% y   ordinates 
% x   abscissas
% If only one input argument is given x=1:1:length(y);
% if given, x must have the same number of rows as y
% and either the same number of columns or 1 column
%     (see also quad2)
%    ci = cumquad(y,x)

[ny,my]=size(y);
itransp=0;
if ny == 1 & my > 1
  itransp=1;
  y=y(:);
  [ny,my]=deal(my,ny);
  if nargin == 2
     x=x(:);
  end
end

dy=(y(1:ny-1,:)+y(2:ny,:))*0.5;

if (nargin == 2)
  [nx,mx]=size(x);

  if nx ~= ny
    fprintf('ERROR in CUMQUAD: Input arrays have incompatible dimensions\n')
    size(x), size(y)
    return
  end

  dx=diff(x);
  if mx == 1 & my ~= 1
    dx=dx(:,ones(my,1));
  elseif mx ~= my,
    fprintf('ERROR in CUMQUAD: Input arrays have incompatible dimensions\n')
    size(x), size(y)
    return
  end
else
  dx=ones(ny-1,my);
end

ci=[zeros(1,my);cumsum(dx.*dy)];

if itransp
   ci=ci(:);
end
    
