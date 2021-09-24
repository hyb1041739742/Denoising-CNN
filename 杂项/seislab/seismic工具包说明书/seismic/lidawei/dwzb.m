function [dw,wind]=dwzb(N,f0,samp,location)
% 生成David子波
% [dw,wind]=dwzb(N,f0,samp,location)
% N：采样点数
% f0：主频(Hz)
% samp：采样间隔(ms)
% location：峰值位置，数值范围0——1，0为最小相位，1为
%           最大相位，其他为混合相位，（default=0.35）;
% dw：David子波
% wind：最优窗函数（数据短时只是一部分）
% /////////////////////////////////////////////////////////
% 计算公式
% temp=f0*2*pi*samp/1000 (余玄函数真实采样间隔)
% Tn=N*temp (余玄函数真实周期数)
% f(x)=cos(x*temp)*s1*w1   x=-location,-location+1,......,-2
% f(x)=1                   x=0
% f(x)=cos(x*temp)*s2*w2   x=2,3,......,N-location-1
% 其中s1、s2为衰减系数，w1、w2为最优窗函数的左、右部分

% ----------程序----------
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
    error('location 必须是数据长度的0——1之间的数')
end
if(N*samp*f0<3000)
    error('时窗太短，波形失真，请增大采样点数或采样间隔或主频')
end
tt=samp*f0/30;%形状维持参数
leftattenuation=0.95^tt;%零左侧衰减系数
rightattenuation=0.97^tt;%零右侧衰减系数
l=location;
temp=f0*2*pi*samp/1000;%真实采样间隔
fc=4*f0;%假设为最大频率
fs=1000/samp;%采样频率
if(fs<2*fc)
    error('采样频率已小于奈奎斯特频率，请减小采样间隔或主频')
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
sleft=leftattenuation.^nleft;%零左侧衰减
aa(1:ll)=cos(a(1:ll)).*sleft;
aa(ll+1)=cos(temp);%零值
nright=1:N-ll-1;
sright=rightattenuation.^nright;%零右侧衰减
aa(ll+2:N)=cos(a(ll+2:N)).*sright;
aa=smooth(aa,6)';
aa=aa/max(abs(aa));
%加最优窗
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
%窗函数左右均衡
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
wind=d(Lleft-ll+1:Lleft+N-ll);%最终窗函数
aa=aa.*wind; %加窗
dw=aa;    %输出