function [d,dis]=rn(n,nn)
% ���λ�÷ֲ�����
d=zeros(1,n);
dis=fix((rand(nn)+0.1)*n*0.8);
s=rand(nn);
for k=1:nn
    d(dis(k))=s(k);
end
