function mu=mulplot(a,b,c)
% 重叠图，最多画三个
% mulplot(a,b,c)
% a,b,c：数据长度相同的行向量
% 颜色分别为：黑、红、绿，线条为实线、点画线、双节线

% --------程序--------
n=length(a);
x=1:n;
if(exist('b')~=1 & exist('c')~=1)
    plot(a,'k-');
elseif(exist('c')~=1)
    if(length(b)~=n)
        error('数据长度必须相同');
    end
    plot(x,a,'k-',x,b,'r-.');
else      
    if(length(b)~=n | length(c)~=n)
        error('数据长度必须相同');
    end
    plot(x,a,'k-',x,b,'r-.',x,c,'g--');
end