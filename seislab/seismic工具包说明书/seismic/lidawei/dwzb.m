function [dw,wind]=dwzb(N,f0,samp,location)
% ����David�Ӳ�
% [dw,wind]=dwzb(N,f0,samp,location)
% N����������
% f0����Ƶ(Hz)
% samp���������(ms)
% location����ֵλ�ã���ֵ��Χ0����1��0Ϊ��С��λ��1Ϊ
%           �����λ������Ϊ�����λ����default=0.35��;
% dw��David�Ӳ�
% wind�����Ŵ����������ݶ�ʱֻ��һ���֣�
% /////////////////////////////////////////////////////////
% ���㹫ʽ
% temp=f0*2*pi*samp/1000 (����������ʵ�������)
% Tn=N*temp (����������ʵ������)
% f(x)=cos(x*temp)*s1*w1   x=-location,-location+1,......,-2
% f(x)=1                   x=0
% f(x)=cos(x*temp)*s2*w2   x=2,3,......,N-location-1
% ����s1��s2Ϊ˥��ϵ����w1��w2Ϊ���Ŵ����������Ҳ���

% ----------����----------
if(exist('f0')~=1)
    f0=30;
end
if(exist('samp')~=1)
    samp=1;
end
if(exist('location')~=1)
    location=0.35;
end
if(location>1 | location<0)
    error('location ���������ݳ��ȵ�0����1֮�����')
end
if(N*samp*f0<3000)
    error('ʱ��̫�̣�����ʧ�棬�������������������������Ƶ')
end
tt=samp*f0/30;%��״ά�ֲ���
leftattenuation=0.95^tt;%�����˥��ϵ��
rightattenuation=0.97^tt;%���Ҳ�˥��ϵ��
l=location;
temp=f0*2*pi*samp/1000;%��ʵ�������
fc=4*f0;%����Ϊ���Ƶ��
fs=1000/samp;%����Ƶ��
if(fs<2*fc)
    error('����Ƶ����С���ο�˹��Ƶ�ʣ����С�����������Ƶ')
end
ll=fix(l*N)-1;
if(ll<=0)
    ll=5;
end
if(ll>=N-2)
    ll=N-6;
end
a=-ll*temp:temp:(N-ll-1)*temp;
nleft=ll:-1:1;
sleft=leftattenuation.^nleft;%�����˥��
aa(1:ll)=cos(a(1:ll)).*sleft;
aa(ll+1)=cos(temp);%��ֵ
nright=1:N-ll-1;
sright=rightattenuation.^nright;%���Ҳ�˥��
aa(ll+2:N)=cos(a(ll+2:N)).*sright;
aa=smooth(aa,6)';
aa=aa/max(abs(aa));
%�����Ŵ�
if(ll>=80)
    Lleft=ll;
else    
    Lleft=80;
end
if(N-ll-1>=80)
    Lright=N-ll-1;
else    
    Lright=80;
end
mleft=-Lleft:-1;
d(1:Lleft)=abs(sin(pi.*mleft/Lleft))/pi+(1+mleft/Lleft).*cos(pi.*mleft/Lleft);
d(Lleft+1)=1;
mright=1:Lright;
d(Lleft+2:Lleft+1+Lright)=abs(sin(pi.*mright/Lright))/pi+(1-mright/Lright).*cos(pi.*mright/Lright);
%���������Ҿ���
if(1-location>=location)
    big=1-location;
    small=location;
    if(big<=2*small)
        xishu=big/small;
    else
        xishu=2;
    end
    d(Lleft+2:Lleft+1+Lright)=d(Lleft+2:Lleft+1+Lright).^(xishu^2);
    d(Lleft+2:Lleft+1+Lright)=abs(d(Lleft+2:Lleft+1+Lright));
else
    big=location;
    small=1-location;    
    if(big<=2*small)
        xishu=big/small;
    else
        xishu=2;
    end    
    d(1:Lleft)=d(1:Lleft).^(xishu^2);
    d(1:Lleft)=abs(d(1:Lleft));
end
wind=d(Lleft-ll+1:Lleft+N-ll);%���մ�����
aa=aa.*wind; %�Ӵ�
dw=aa;    %���